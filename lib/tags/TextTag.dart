import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/utils/ConvertUtil.dart';
import 'package:html/dom.dart' as dom;

/// Builds a [Text] widget from a [dom.Text] element.
class TextTag extends StatelessWidget {
  final Page page;
  final dom.Element element;
  final Map style;

  TextTag({this.page, this.element, this.style});

  @override
  Widget build(BuildContext context) {
    String text = element.text.trim();
    text = ConvertUtil.compileTemplateString(text, page.data);

    Text textWidget = new Text(text,
        style: TextStyle(
            color: style['color'],
            fontWeight: style['fontWeight'],
            fontStyle: style['fontStyle'],
            decoration: style['textDecoration'],
            decorationColor: style['textDecorationColor'],
            decorationStyle: style['textDecorationStyle'],
            fontSize: style['fontSize'],
            height: style['height']),
        softWrap: true,
        textAlign: style['textAlign'],
        textDirection: style['direction'],
        overflow: TextOverflow.clip);
    if (style['display'] == 'block') {
      return Row(
        children: <Widget>[textWidget],
      );
    } else if (style['display'] == 'inline') {
      return textWidget;
    }
  }
}
