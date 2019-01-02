import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/HtmlParser.dart';
import 'package:html/dom.dart' as dom;

// https://flutter.io/docs/development/ui/widgets/layout
class ViewTag extends StatelessWidget {
  final Page page;
  final dom.Node element;
  final Map style;

  ViewTag({this.page, this.element, this.style});

  @override
  Widget build(BuildContext context) {
    HtmlParser htmlParser = new HtmlParser();
    List<Widget> widgetList = new List();
    List<dom.Node> nodes = element.children;

    if (nodes.isEmpty) {
      return new Container(height: 0.0, width: 0.0);
    }

    if (nodes.length == 1) {
      htmlParser.parseChildren(page, nodes.single, widgetList);
    } else {
      nodes.forEach(
          (dom.Node node) => htmlParser.parseChildren(page, node, widgetList));
    }

    var attributes = element.attributes;
    var onTap = attributes['ontap'];
    var onLongTap = attributes['onlongtap'];

    return GestureDetector(
        onTap: () {
          if (onTap != null) {
            page.invoke(onTap);
          }
        },
        onLongPress: () {
          if (onLongTap != null) {
            page.invoke(onLongTap);
          }
        },
        child: Container(
            alignment: parseAlignment(),
            margin: style['margin'],
            padding: style['padding'],
            child: Wrap(children: widgetList)));
  }

  Alignment parseAlignment() {
    var alignment = element.attributes['alignment'];
    switch (alignment) {
      case 'topLeft':
        return Alignment.topLeft;
      case 'topCenter':
        return Alignment.topCenter;
      case 'topRight':
        return Alignment.topRight;
      case 'centerLeft':
        return Alignment.centerLeft;
      case 'center':
        return Alignment.center;
      case 'centerRight':
        return Alignment.centerRight;
      case 'centerRight':
        return Alignment.bottomLeft;
      case 'centerRight':
        return Alignment.bottomCenter;
      case 'centerRight':
        return Alignment.bottomRight;
      default:
        return Alignment.topLeft;
    }
  }
}
