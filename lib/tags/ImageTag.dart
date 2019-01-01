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
    String src = this.element.attributes['src'];
    if (src.startsWith("http") || src.startsWith("https")) {
      return new CachedNetworkImage(
        imageUrl: src,
        fit: BoxFit.cover,
      );
    } else if (src.startsWith('data:image')) {
      var exp = new RegExp(r'data:.*;base64,');
      var base64Str = src.replaceAll(exp, '');
      var bytes = base64.decode(base64Str);
      return new Image.memory(bytes, fit: BoxFit.cover);
    } else {
      String imageUrl = ConvertUtil.parsePath(this.page.url, src);
      return Image.asset(imageUrl);
    }
  }
}
