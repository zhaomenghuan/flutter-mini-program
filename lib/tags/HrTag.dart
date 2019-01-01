import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:html/dom.dart' as dom;

/// Creates a line break from a template <br/> tag.
class HrTag extends StatelessWidget {
  final Page page;
  final dom.Element element;

  HrTag({this.page, this.element});

  @override
  Widget build(BuildContext context) {
    assert(element.localName == 'hr');
    return new Divider();
  }
}
