import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/utils/ConvertUtil.dart';
import 'package:html/dom.dart' as dom;

/// Load a Image from a <image> tag.
class ImageTag extends StatelessWidget {
  final Page page;
  final dom.Element element;
  final Map style;

  ImageTag({this.page, this.element, this.style});

  @override
  Widget build(BuildContext context) {
    var attributes = element.attributes;
    String src = attributes['src'];
    double width = style['width'];
    double height = style['height'];
    BoxFit fit = parseBoxFit(attributes);

    if (src.startsWith("http") || src.startsWith("https")) {
      return new CachedNetworkImage(
          imageUrl: src, width: width, height: height, fit: fit);
    } else if (src.startsWith('data:image')) {
      var exp = new RegExp(r'data:.*;base64,');
      var base64Str = src.replaceAll(exp, '');
      var bytes = base64.decode(base64Str);
      return new Image.memory(bytes, width: width, height: height, fit: fit);
    } else {
      String imageUrl = ConvertUtil.parsePath(this.page.url, src);
      return Image.asset(imageUrl, width: width, height: height, fit: fit);
    }
  }

  /// Parse BoxFit mode
  BoxFit parseBoxFit(attributes) {
    String mode = attributes['fit'];
    switch (mode) {
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'cover':
        return BoxFit.cover;
      case 'fitWidth':
        return BoxFit.fitWidth;
      case 'fitHeight':
        return BoxFit.fitHeight;
      case 'none':
        return BoxFit.none;
      case 'scaleDown':
        return BoxFit.scaleDown;
    }
  }
}
