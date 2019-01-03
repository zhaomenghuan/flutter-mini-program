import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:html/dom.dart' as dom;
import 'package:csslib/parser.dart' as css;
import 'package:csslib/visitor.dart';

class StyleParser {
  /**
   * Spin-up CSS parser in checked mode to detect any problematic CSS.  Normally,
   * CSS will allow any property/value pairs regardless of validity; all of our
   * tests (by default) will ensure that the CSS is really valid.
   */
  static StyleSheet parseCss(String cssInput,
          {List<css.Message> errors, css.PreprocessorOptions opts}) =>
      css.parse(cssInput,
          errors: errors,
          options: opts == null
              ? css.PreprocessorOptions(
                  useColors: true,
                  verbose: true,
                  checked: true,
                  warningsAsErrors: true,
                  polyfill: true,
                  inputFile: 'memory')
              : opts);

  static formatCss(String cssInput) {
    StyleSheet styleSheet = parseCss(cssInput);
    var clsVisits = new CssPrinter();
    return clsVisits..visitStyleSheet(styleSheet).toString();
  }

  static Map visitStyleSheet(String cssInput) {
    StyleSheet styleSheet = parseCss(cssInput);
    Map styleSheetMap = new Map();
    for (RuleSet ruleSet in styleSheet.topLevels) {
      String selectorName = ruleSet.selectorGroup.span.text;
      Map declarationMap = new Map();
      for (var declaration in ruleSet.declarationGroup.declarations) {
        List<String> declarationTextSpan = declaration.span.text.split(':');
        String property = declarationTextSpan[0].trim();
        String value = declarationTextSpan[1].trim();
        declarationMap[property] = value;
      }
      styleSheetMap[selectorName] = declarationMap;
    }
    return styleSheetMap;
  }

  /// Parse Class Attribute
  static Map parseClassAttribute(Page page, dom.Node node, Map nodeStyles) {
    if (node is dom.Element) {
      if (page.style != null && node.classes != null) {
        node.classes.forEach((name) {
          Map declarationMap = page.style['.$name'];
          if (declarationMap != null) {
            declarationMap.forEach((property, value) {
              nodeStyles[property] = value;
            });
          }
        });
      }
    }
    return nodeStyles;
  }

  // Parse Style Attribute
  static Map parseStyleAttribute(dom.Node node, Map nodeStyles) {
    RegExp _style = new RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');
    var styleText = node.attributes['style'];
    if (styleText != null) {
      Iterable<Match> matches = _style.allMatches(styleText);
      for (Match match in matches) {
        String property = match[1].trim();
        String value = match[2].trim();
        nodeStyles[property] = value;
      }
    }
    return nodeStyles;
  }

  // Parse Node Tag Style
  static Map parseTagStyleSheet(Page page, dom.Node node) {
    Map nodeStyles = {};
    // 1. Class Attribute
    parseClassAttribute(page, node, nodeStyles);
    // 2. Style Attribute
    parseStyleAttribute(node, nodeStyles);
    return nodeStyles;
  }

  ///
  /// [CSS writing order](https://github.com/necolas/idiomatic-css)
  ///
  /// 1.Positioning attribute(position, z-index, top, right, bottom, left)
  /// 2.Display & Box Model attribute(display, overflow, box-sizing, width, height, padding, margin, border)
  /// 4.Color attribute(background, color)
  /// 4.Text attribute(font, font-family, font-size, line-height, letter-spacing, text-align)
  /// 5.Other(cursor, animation, transition)
  ///
  /// TextStyle Property:
  ///
  /// inherit: 是否继承
  /// color: 字体颜色 as: #FF0000
  /// fontSize: 字体尺寸
  /// fontWeight: 字体粗细
  /// fontStyle: 字体样式(normal|italic|oblique)
  /// letterSpacing: 字母间隙(负值可以让字母更紧凑)
  /// wordSpacing: 单词间隙(负值可以让单词更紧凑)
  /// textBaseline: 文本绘制基线(alphabetic|ideographic)
  /// height: 高度
  /// locale: 区域设置
  /// foreground
  /// background
  /// shadows
  /// decoration: 文字装饰(none|underline|overline|lineThrough)
  /// decorationColor: 文字装饰颜色
  /// decorationStyle: 文字装饰样式
  /// debugLabel
  /// fontFamily: 字体
  ///
  ///
  static Map parseTagStyleDeclaration(Page page, dom.Element node) {
    Map styleDeclaration = {};
    List _blockTags = const ['view', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'p'];
    String tag = node.localName;
    Map nodeStyles = parseTagStyleSheet(page, node);

    // BlockTags
    if (_blockTags.contains(tag)) {
      styleDeclaration['display'] = 'block';
    } else {
      styleDeclaration['display'] = 'inline';
    }

    switch (tag) {
      case 'h1':
        styleDeclaration['fontSize'] = 32.0;
        break;
      case 'h2':
        styleDeclaration['fontSize'] = 24.0;
        break;
      case 'h3':
        styleDeclaration['fontSize'] = 20.0;
        break;
      case 'h4':
        styleDeclaration['fontSize'] = 16.0;
        break;
      case 'h5':
        styleDeclaration['fontSize'] = 12.8;
        break;
      case 'h6':
        styleDeclaration['fontSize'] = 11.2;
        break;
      case 'a':
        styleDeclaration['textDecoration'] = TextDecoration.underline;
        styleDeclaration['color'] = parseColor("#1965B5");
        break;
      case 'b':
      case 'strong':
        styleDeclaration['fontWeight'] = FontWeight.bold;
        break;
      case 'i':
      case 'em':
        styleDeclaration['fontStyle'] = FontStyle.italic;
        break;
      case 'u':
        styleDeclaration['textDecoration'] = TextDecoration.underline;
        break;
    }

    if (nodeStyles != null) {
      for (var property in nodeStyles.keys) {
        String value = nodeStyles[property];
        switch (property) {
          case 'display':
            styleDeclaration['display'] = value;
            break;
          case 'width':
            styleDeclaration['width'] = parsePxSize(value);
            break;
          case 'height':
            styleDeclaration['height'] = parsePxSize(value);
            break;
          case 'margin':
            styleDeclaration['margin'] = parseMargin(value);
            break;
          case 'padding':
            styleDeclaration['padding'] = parsePadding(value);
            break;
          case 'color':
            styleDeclaration['color'] = parseColor(value);
            break;
          case 'background-color':
            styleDeclaration['backgroundColor'] = parseColor(value);
            break;
          case 'font-weight':
            styleDeclaration['fontWeight'] = parseFontWeight(value);
            break;
          case 'font-style':
            styleDeclaration['fontStyle'] = parseFontStyle(value);
            break;
          case 'font-size':
            styleDeclaration['fontSize'] = parsePxSize(value);
            break;
          case 'text-decoration':
            styleDeclaration['textDecoration'] = parseTextDecoration(value);
            break;
          case 'text-decoration-color':
            styleDeclaration['textDecorationColor'] = parseColor(value);
            break;
          case 'text-decoration-style':
            styleDeclaration['textDecorationStyle'] =
                parseTextDecorationStyle(value);
            break;
          case 'text-align':
            styleDeclaration['textAlign'] = parseTextAlign(value);
            break;
          case 'direction':
            styleDeclaration['direction'] = parseTextDirection(value);
            break;
        }
      }
    }

    return styleDeclaration;
  }

  /// Parse Color
  static parseColor(String value) {
    Color color;
    RegExp colorRegExp = new RegExp(r'^#([a-fA-F0-9]{6})$');
    if (colorRegExp.hasMatch(value)) {
      value = value.replaceAll('#', '').trim();
      color = new Color(int.parse('0xFF' + value));
    }
    return color;
  }

  /// Parse Size
  static parsePxSize(String value) {
    value = value.replaceAll('px', '').trim();
    return double.parse(value);
  }

  static parseEdgeInsets(String value) {
    return EdgeInsets.all(parsePxSize(value));
  }

  /// [margin](https://developer.mozilla.org/en-US/docs/Web/CSS/margin)
  static parseMargin(String value) {
    List valueList = value.split(r" ");
    switch (valueList.length) {
      case 1:
        return EdgeInsets.all(parsePxSize(value));
      case 2:
        double vertical = parsePxSize(valueList[0]);
        double horizontal = parsePxSize(valueList[1]);
        return EdgeInsets.fromLTRB(horizontal, vertical, horizontal, vertical);
      case 3:
        double top = parsePxSize(valueList[0]);
        double horizontal = parsePxSize(valueList[1]);
        double bottom = parsePxSize(valueList[2]);
        return EdgeInsets.fromLTRB(horizontal, top, horizontal, bottom);
      case 4:
        double top = parsePxSize(valueList[0]);
        double right = parsePxSize(valueList[1]);
        double bottom = parsePxSize(valueList[2]);
        double left = parsePxSize(valueList[3]);
        return EdgeInsets.fromLTRB(left, top, right, bottom);
    }
  }

  static parsePadding(String value) {
    return parseEdgeInsets(value);
  }

  /// [font-style](https://developer.mozilla.org/en-US/docs/Web/CSS/font-style)
  static FontStyle parseFontStyle(String value) {
    return (value == 'italic') ? FontStyle.italic : FontStyle.normal;
  }

  /// [font-weight](https://developer.mozilla.org/en-US/docs/Web/CSS/font-weight]
  static FontWeight parseFontWeight(String fontWeight) {
    switch (fontWeight) {
      case 'normal':
        return FontWeight.normal;
      case 'bold':
        return FontWeight.bold;
      case '100':
        return FontWeight.w100;
      case '200':
        return FontWeight.w200;
      case '300':
        return FontWeight.w300;
      case '400':
        return FontWeight.w400;
      case '500':
        return FontWeight.w500;
      case '600':
        return FontWeight.w600;
      case '700':
        return FontWeight.w700;
      case '800':
        return FontWeight.w800;
      case '900':
        return FontWeight.w900;
    }
  }

  /// [text-align](https://developer.mozilla.org/en-US/docs/Web/CSS/text-align)
  /// TODO: Temporarily not effective
  static TextAlign parseTextAlign(String textAlign) {
    switch (textAlign) {
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      case 'center':
        return TextAlign.center;
      case 'justify':
        return TextAlign.justify;
      case 'start':
        return TextAlign.start;
      case 'end':
        return TextAlign.end;
    }
  }

  /// [text-decoration](https://developer.mozilla.org/en-US/docs/Web/CSS/text-decoration)
  static TextDecoration parseTextDecoration(String textDecoration) {
    switch (textDecoration) {
      // 默认, 定义标准的文本
      case 'none':
        return TextDecoration.none;
        break;
      // 下划线
      case 'underline':
        return TextDecoration.underline;
        break;
      // 顶划线
      case 'overline':
        return TextDecoration.overline;
        break;
      // 删除线
      case 'line-through':
        return TextDecoration.lineThrough;
        break;
    }
  }

  /// [text-decoration-style](https://developer.mozilla.org/en-US/docs/Web/CSS/text-decoration-style)
  static TextDecorationStyle parseTextDecorationStyle(
      String textDecorationStyle) {
    switch (textDecorationStyle) {
      case 'solid':
        return TextDecorationStyle.solid;
        break;
      case 'double':
        return TextDecorationStyle.double;
        break;
      case 'dotted':
        return TextDecorationStyle.dotted;
        break;
      case 'dashed':
        return TextDecorationStyle.dashed;
        break;
      case 'wavy':
        return TextDecorationStyle.wavy;
        break;
    }
  }

  /// [direction](https://developer.mozilla.org/en-US/docs/Web/CSS/direction)
  static TextDirection parseTextDirection(String value) {
    return (value == 'ltr') ? TextDirection.ltr : TextDirection.rtl;
  }
}
