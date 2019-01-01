import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/tags/BreakTag.dart';
import 'package:flutter_mini_program/tags/ButtonTag.dart';
import 'package:flutter_mini_program/tags/CheckboxTag.dart';
import 'package:flutter_mini_program/tags/HrTag.dart';
import 'package:flutter_mini_program/tags/IconTag.dart';
import 'package:flutter_mini_program/tags/ListViewTag.dart';
import 'package:flutter_mini_program/tags/TextTag.dart';
import 'package:flutter_mini_program/tags/ImageTag.dart';
import 'package:flutter_mini_program/tags/VideoTag.dart';
import 'package:flutter_mini_program/tags/ViewTag.dart';

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
  parseChildren(Page page, dom.Node node, widgetList) {
    if (node is dom.Text) {
      dom.Text text = node as dom.Text;
      String data = text.data.trim();
      if (data.isNotEmpty) {
        widgetList(new Text(data));
      }
    }

    if (node is dom.Element) {
      Map nodeStyles = {};
      node.classes.forEach((name) {
        print(page.style['.$name']);
      });

      var name = node.localName;
      switch (name) {
        case 'div':
        case 'view':
          widgetList.add(new ViewTag(page: page, element: node));
          break;
        case 'icon':
          widgetList.add(new IconTag(page: page, element: node));
          break;
        case 'text':
        case 'p':
        case 'span':
        case 'h1':
        case 'h2':
        case 'h3':
        case 'h4':
        case 'h5':
        case 'h6':
        case 'a':
          widgetList.add(new TextTag(page: page, element: node));
          break;
        case 'button':
          widgetList.add(new ButtonTag(page: page, element: node));
          break;
        case 'checkbox':
          widgetList.add(new CheckboxTag(page: page, element: node));
          break;
        case 'list-view':
          widgetList.add(new ListViewTag(page: page, element: node));
          break;
        case 'image':
        case 'img':
          widgetList.add(new ImageTag(page: page, element: node));
          break;
        case 'video':
          widgetList.add(new VideoTag(page: page, element: node));
          break;
        case 'hr':
          widgetList.add(new HrTag(page: page, element: node));
          break;
        case 'br':
          widgetList.add(new BreakTag(page: page, element: node));
          break;
        default:
          node.children
              .forEach((element) => parseChildren(page, element, widgetList));
      }
    }
  }
}
