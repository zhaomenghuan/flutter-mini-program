import 'package:flutter/material.dart';
import 'package:csslib/parser.dart' as css;
import 'package:csslib/visitor.dart';

class StyleParser {
  static const simpleOptionsWithCheckedAndWarningsAsErrors =
      const css.PreprocessorOptions(
          useColors: true,
          verbose: true,
          checked: true,
          warningsAsErrors: true,
          polyfill: true,
          inputFile: 'memory');

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
              ? simpleOptionsWithCheckedAndWarningsAsErrors
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
      Map declarationGroup = new Map();
      for (var declaration in ruleSet.declarationGroup.declarations) {
        List<String> declarationTextSpan = declaration.span.text.split(':');
        String property = declarationTextSpan[0].trim();
        String value = declarationTextSpan[1].trim();
        declarationGroup[property] = value;
      }
      styleSheetMap[ruleSet.selectorGroup.span.text] = declarationGroup;
    }
    return styleSheetMap;
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
  static Map parseStyle(BuildContext context, String tag, String style) {
    Map styleMap = new Map();

    List _blockTags = const ['h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'p'];
    RegExp _style = new RegExp(r'([a-zA-Z\-]+)\s*:\s*([^;]*)');

    // BlockTags
    if (_blockTags.contains(tag)) {
      styleMap['display'] = 'block';
    } else {
      styleMap['display'] = 'inline';
    }

    switch (tag) {
      case 'h1':
        styleMap['fontSize'] = 32.0;
        break;
      case 'h2':
        styleMap['fontSize'] = 24.0;
        break;
      case 'h3':
        styleMap['fontSize'] = 20.0;
        break;
      case 'h4':
        styleMap['fontSize'] = 16.0;
        break;
      case 'h5':
        styleMap['fontSize'] = 12.8;
        break;
      case 'h6':
        styleMap['fontSize'] = 11.2;
        break;
      case 'a':
        styleMap['textDecoration'] = TextDecoration.underline;
        styleMap['color'] = parseColor("#1965B5");
        break;
      case 'b':
      case 'strong':
        styleMap['fontWeight'] = FontWeight.bold;
        break;
      case 'i':
      case 'em':
        styleMap['fontStyle'] = FontStyle.italic;
        break;
      case 'u':
        styleMap['textDecoration'] = TextDecoration.underline;
        break;
    }

    // style 属性
    if (style != null) {
      Iterable<Match> matches = _style.allMatches(style);
      for (Match match in matches) {
        String param = match[1].trim();
        String value = match[2].trim();

        switch (param) {
          case 'display':
            styleMap['display'] = value;
            break;
          case 'margin':
            styleMap['margin'] = parseMargin(value);
            break;
          case 'color':
            styleMap['color'] = parseColor(value);
            break;
          case 'background-color':
            styleMap['backgroundColor'] = parseColor(value);
            break;
          case 'font-weight':
            styleMap['fontWeight'] = parseFontWeight(value);
            break;
          case 'font-style':
            styleMap['fontStyle'] =
                (value == 'italic') ? FontStyle.italic : FontStyle.normal;
            break;
          case 'font-size':
            value = value.replaceAll('px', '').trim();
            styleMap['fontSize'] = double.parse(value);
            break;
          case 'text-decoration':
            styleMap['textDecoration'] = parseTextDecoration(value);
            break;
          case 'text-decoration-color':
            styleMap['textDecorationColor'] = parseColor(value);
            break;
          case 'text-decoration-style':
            styleMap['textDecorationStyle'] = parseTextDecorationStyle(value);
            break;
          case 'text-align':
            styleMap['textAlign'] = parseTextAlign(value);
            break;
          case 'direction':
            styleMap['textDirection'] =
                (value == 'ltr') ? TextDirection.ltr : TextDirection.rtl;
            break;
        }
      }
    }

    return styleMap;
  }

  /// 解析文本对齐方式
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

  static parseMargin(String value) {}

  /// 解析颜色
  static parseColor(String value) {
    Color color;
    RegExp colorRegExp = new RegExp(r'^#([a-fA-F0-9]{6})$');
    if (colorRegExp.hasMatch(value)) {
      value = value.replaceAll('#', '').trim();
      color = new Color(int.parse('0xFF' + value));
    }
    return color;
  }

  /// 解析字体粗细程度
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

  /// 解析文本修饰 —— [text-decoration](https://developer.mozilla.org/en-US/docs/Web/CSS/text-decoration)
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

  /// 设定线的样式 —— [text-decoration-style](https://developer.mozilla.org/en-US/docs/Web/CSS/text-decoration-style)
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
}
