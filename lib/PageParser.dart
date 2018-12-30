import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/HtmlParser.dart';

import 'package:html/dom.dart' as dom;

class PageParser {
  /**
   * 解析 HTML 文件
   */
  static Widget parse(String html, Page widget) {
    List<Widget> widgetList = new List();
    HtmlParser htmlParser = new HtmlParser();
    dom.Document document = htmlParser.parseHTML(html);
    dom.Element docBody = document.body;

    // config
    dom.Node configNode = docBody.getElementsByTagName("config").first;
    var pageConfig = json.decode(configNode.text);

    // template
    dom.Element templateElement =
        docBody.getElementsByTagName("template").first;
    List<dom.Node> templateChildren = templateElement.children;
    if (templateChildren.length > 0) {
      templateChildren.forEach((dom.Node node) =>
          htmlParser.parseChildren(widget, node, widgetList));
    }

    // script
    // dom.Node scriptNode = docBody.getElementsByTagName("script").first;
    // print(scriptNode.text);

    // style
    List<dom.Element> styleElements = docBody.getElementsByTagName("style");
    if (styleElements.length > 0) {
      for (int i = 0; i < styleElements.length; i++) {
        docBody.getElementsByTagName("style").first.remove();
      }
    }

    return new Scaffold(
        appBar: AppBar(
            title: Text(pageConfig['navigationBarTitleText']),
            centerTitle: true),
        body: SingleChildScrollView(child: Wrap(children: widgetList)));
  }
}
