import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/StyleParser.dart';
import 'package:html/dom.dart' as dom;

/// Builds a [Text] widget from a [dom.Text] element.
class TextTag extends StatelessWidget {
  final Page page;
  final dom.Element element;

  TextTag({this.page, this.element});

  @override
  Widget build(BuildContext context) {
    // 解析文本样式
    Map styleMap = StyleParser.parseStyle(
        context, this.element.localName, this.element.attributes['style']);

    print(styleMap);

    Text textWidget = new Text(this.element.text.trim(),
        style: TextStyle(
            color: styleMap['color'],
            fontWeight: styleMap['fontWeight'],
            fontStyle: styleMap['fontStyle'],
            decoration: styleMap['textDecoration'],
            decorationColor: styleMap['textDecorationColor'],
            decorationStyle: styleMap['textDecorationStyle'],
            fontSize: styleMap['fontSize'],
            height: styleMap['height']),
        softWrap: true,
        textAlign: styleMap['textAlign'],
        textDirection: styleMap['textDirection'],
        overflow: TextOverflow.clip);
    if (styleMap['display'] == 'block') {
      return Row(
        children: <Widget>[textWidget],
      );
    } else if (styleMap['display'] == 'inline') {
      return textWidget;
    }
  }
}
