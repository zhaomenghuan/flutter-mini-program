import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/HtmlParser.dart';
import 'package:flutter_mini_program/StyleParser.dart';
import 'package:flutter_mini_program/engine/JSContext.dart';
import 'package:html/dom.dart' as dom;

class PageParser {
  /// Parse HTML Page
  static Page parse(Page page) {
    List<Widget> widgetList = new List();
    HtmlParser htmlParser = new HtmlParser();
    dom.Element docBody = htmlParser.parseHTML(page.html);

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
      page.widgetList = widgetList;
    }

    // script
    List<dom.Element> scriptElements = docBody.getElementsByTagName("script");
    if (scriptElements.length > 0) {
      dom.Element scriptElement = scriptElements.first;
      page.jsContext.setProperty("Page", (Map options) {
        page.config = options['config'];
        page.data = options['data'];
      });
      registerPageLogic(page.jsContext, scriptElement.text.trim());
    }

    return page;
  }

  // Register Page Logic
  static void registerPageLogic(JSContext jsContext, String script) async {
    await jsContext.evaluateScript(script);
  }
}
