import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/HtmlParser.dart';
import 'package:flutter_mini_program/StyleParser.dart';
import 'package:html/dom.dart' as dom;

class PageParser {
  /// Parse HTML Page
  static Widget parse(String html, Page page) {
    List<Widget> widgetList = new List();
    HtmlParser htmlParser = new HtmlParser();
    dom.Document document = htmlParser.parseHTML(html);
    dom.Element docBody = document.body;

    // config
    dom.Node configNode = docBody.getElementsByTagName("config").first;
    page.config = json.decode(configNode.text);

    // style
    List<dom.Element> styleElements = docBody.getElementsByTagName("style");
    if (styleElements.length > 0) {
      dom.Element styleElement = styleElements.first;
      page.style = StyleParser.visitStyleSheet(styleElement.text);
    }

    // template
    dom.Element templateElement =
        docBody.getElementsByTagName("template").first;
    List<dom.Node> templateChildren = templateElement.children;
    if (templateChildren.length > 0) {
      templateChildren.forEach(
          (dom.Node node) => htmlParser.parseChildren(page, node, widgetList));
    }

    // Title
    String title = "";
    if (page.config != null && page.config.containsKey("navigationBarTitleText")) {
      title = page.config['navigationBarTitleText'];
    }
    return new Scaffold(
        appBar: AppBar(title: Text(title), centerTitle: true),
        body: SingleChildScrollView(child: Wrap(children: widgetList)));
  }
}
