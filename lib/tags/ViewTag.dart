import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/HtmlParser.dart';
import 'package:html/dom.dart' as dom;

// https://flutter.io/docs/development/ui/widgets/layout
class ViewTag extends StatelessWidget {
  final Page page;
  final dom.Node element;

  ViewTag({this.page, this.element});

  @override
  Widget build(BuildContext context) {
    HtmlParser htmlParser = new HtmlParser();
    List<Widget> widgetList = new List();
    List<dom.Node> nodes = element.children;
    double padding = 0.0;

    if (nodes.isEmpty) {
      return new Container(height: 0.0, width: 0.0);
    }

    if (nodes.length == 1) {
      htmlParser.parseChildren(page, nodes.single, widgetList);
    } else {
      nodes.forEach(
          (dom.Node node) => htmlParser.parseChildren(page, node, widgetList));
    }

    return Container(
      margin: EdgeInsets.only(top: 0),
      padding: EdgeInsets.all(padding),
      child: Wrap(children: widgetList),
    );
  }
}
