import 'package:flutter/material.dart';
import 'package:flutter_mini_program/App.dart';
import 'package:flutter_mini_program/HtmlParser.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/StyleParser.dart';
import 'package:html/dom.dart' as dom;

class PageParser {
  /// Parse HTML Page
  static Future<Page> parse(Page page) async {
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
          (dom.Node node) => widgetList.add(htmlParser.parseTag(page, node)));
      page.widgetList = widgetList;
    }

    // script
    List<dom.Element> scriptElements = docBody.getElementsByTagName("script");
    if (scriptElements.length > 0) {
      dom.Element scriptElement = scriptElements.first;
      page.jsContext.setProperty("Page", (Map options) {});
      var global = await registerPageLogic(page.url, scriptElement.text.trim());
      page.config = global['config'];
      page.data = global['data'];
      page.methods = global['methods'];
    }

    return page;
  }

  // Register Page Logic
  static dynamic registerPageLogic(String name, String script) async {
    await App.jsContext.evaluateScript('''
    pages['$name'] = $script;
    ''');
    var pages = await App.jsContext.property("pages");
    return pages[name];
  }
}
