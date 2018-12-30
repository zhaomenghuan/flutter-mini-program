import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/utils/TextStyleUtil.dart';
import 'package:html/dom.dart' as dom;

/// Builds a [Text] widget from a [dom.Text] element.
class TextTag extends StatelessWidget {
  final Page page;
  final dom.Element element;

  TextTag({this.page, this.element});

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyleUtil.parseStyle(
        context, this.element.localName, this.element.attributes);
    return new Text(this.element.text, style: style);
  }
}
