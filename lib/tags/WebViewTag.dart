import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/utils/ConvertUtil.dart';
import 'package:html/dom.dart' as dom;
import 'package:webview_flutter/webview_flutter.dart';

/// Load a Web Page from a <web-view> tag.
class WebViewTag extends StatelessWidget {
  final Page page;
  final dom.Element element;
  final Map style;

  WebViewTag({this.page, this.element, this.style});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var attributes = element.attributes;

    String src = attributes['src'];
    double width = attributes.containsKey("width")
        ? ConvertUtil.parseValue(attributes['width'])
        : screenSize.width;
    double height = attributes.containsKey("height")
        ? ConvertUtil.parseValue(attributes['height'])
        : screenSize.height;

    return Container(
        width: width, height: height, child: WebView(initialUrl: src));
  }
}
