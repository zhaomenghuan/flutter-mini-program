import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/StyleParser.dart';
import 'package:flutter_mini_program/tags/BreakTag.dart';
import 'package:flutter_mini_program/tags/ButtonTag.dart';
import 'package:flutter_mini_program/tags/CheckboxGroupTag.dart';
import 'package:flutter_mini_program/tags/HrTag.dart';
import 'package:flutter_mini_program/tags/IconTag.dart';
import 'package:flutter_mini_program/tags/ImageTag.dart';
import 'package:flutter_mini_program/tags/InputTag.dart';
import 'package:flutter_mini_program/tags/ListViewTag.dart';
import 'package:flutter_mini_program/tags/SliderTag.dart';
import 'package:flutter_mini_program/tags/SwitchTag.dart';
import 'package:flutter_mini_program/tags/TableTag.dart';
import 'package:flutter_mini_program/tags/TextTag.dart';
import 'package:flutter_mini_program/tags/VideoTag.dart';
import 'package:flutter_mini_program/tags/ViewTag.dart';
import 'package:flutter_mini_program/tags/WebViewTag.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

class HtmlParser {
  /// Parse HTML File
  dom.Element parseHTML(String html) {
    dom.Document document = parse(html);
    return document.body;
  }

  /// Parse Node Element
  parseTag(Page page, dom.Node node) {
    Widget widget = new Container(height: 0.0, width: 0.0);

    if (node is dom.Text) {
      dom.Text text = node as dom.Text;
      String data = text.data.trim();
      if (data.isNotEmpty) {
        widget = new Text(data);
      }
    }

    if (node is dom.Element) {
      Map nodeStyles = StyleParser.parseTagStyleDeclaration(page, node);
      var name = node.localName;
      switch (name) {
        case 'div':
        case 'view':
          widget = new ViewTag(page: page, element: node, style: nodeStyles);
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
          widget = new TextTag(page: page, element: node, style: nodeStyles);
          break;
        case 'table':
          widget = new TableTag(page: page, element: node, style: nodeStyles);
          break;
        case 'hr':
          widget = new HrTag(page: page, element: node, style: nodeStyles);
          break;
        case 'br':
          widget = new BreakTag(page: page, element: node, style: nodeStyles);
          break;
        case 'icon':
          widget = new IconTag(page: page, element: node, style: nodeStyles);
          break;
        case 'input':
          widget = new InputTag(page: page, element: node, style: nodeStyles);
          break;
        case 'button':
          widget = new ButtonTag(page: page, element: node, style: nodeStyles);
          break;
        case 'checkbox-group':
          widget = new CheckboxGroupTag(
              page: page, element: node, style: nodeStyles);
          break;
        case 'switch':
          widget = new SwitchTag(page: page, element: node, style: nodeStyles);
          break;
        case 'slider':
          widget = new SliderTag(page: page, element: node, style: nodeStyles);
          break;
        case 'list-view':
          widget =
              new ListViewTag(page: page, element: node, style: nodeStyles);
          break;
        case 'image':
        case 'img':
          widget = new ImageTag(page: page, element: node, style: nodeStyles);
          break;
        case 'video':
          widget = new VideoTag(page: page, element: node, style: nodeStyles);
          break;
        case 'web-view':
          widget = new WebViewTag(page: page, element: node, style: nodeStyles);
          break;
        default:
          break;
      }

      return widget;
    }
  }
}
