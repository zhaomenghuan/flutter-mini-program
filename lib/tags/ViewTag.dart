import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/HtmlParser.dart';
import 'package:html/dom.dart' as dom;

class ViewTag extends StatelessWidget {
  final Page widget;
  final List<dom.Node> nodes;

  ViewTag({this.widget, this.nodes});

  @override
  Widget build(BuildContext context) {
    HtmlParser htmlParser = new HtmlParser();
    List<Widget> widgetList = new List();

    if (nodes.isEmpty) {
      return new Container(height: 0.0, width: 0.0);
    }

    if (nodes.length == 1) {
      return htmlParser.parseChildren(widget, nodes.single, widgetList);
    }

    nodes.forEach(
        (dom.Node node) => htmlParser.parseChildren(widget, node, widgetList));
    return SingleChildScrollView(
      child: Wrap(
        children: widgetList,
      ),
    );
  }
}
