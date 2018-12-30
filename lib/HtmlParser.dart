import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/tags/BreakTag.dart';
import 'package:flutter_mini_program/tags/ButtonTag.dart';
import 'package:flutter_mini_program/tags/CheckboxTag.dart';
import 'package:flutter_mini_program/tags/IconTag.dart';
import 'package:flutter_mini_program/tags/ListViewTag.dart';
import 'package:flutter_mini_program/tags/TextTag.dart';
import 'package:flutter_mini_program/tags/ImageTag.dart';

import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

class HtmlParser {
  /**
   * 解析 HTML 文件
   */
  dom.Document parseHTML(String html) {
    return parse(html);
  }

  /**
   * 解析 Node 元素
   */
  parseChildren(Page widget, dom.Node node, widgetList) {
    if (node is dom.Text) {
      dom.Text text = node as dom.Text;
      String data = text.data.trim();
      if (data.isNotEmpty) {
        widgetList(new Text(data));
      }
    }

    if (node is dom.Element) {
      var name = node.localName;
      switch (name) {
        case 'icon':
          widgetList.add(new IconTag(page: widget, element: node));
          break;
        case 'text':
          widgetList.add(new TextTag(page: widget, element: node));
          break;
        case 'image':
        case 'img':
          widgetList.add(new ImageTag(page: widget, element: node));
          break;
        case 'button':
          widgetList.add(new ButtonTag(page: widget, element: node));
          break;
        case 'checkbox':
          widgetList.add(new CheckboxTag(page: widget, element: node));
          break;
        case 'list-view':
          widgetList.add(new ListViewTag(page: widget, element: node));
          break;
        case 'br':
          widgetList.add(new BreakTag(page: widget, element: node));
          break;
        default:
          node.children
              .forEach((element) => parseChildren(widget, element, widgetList));
      }
    }
  }
}
