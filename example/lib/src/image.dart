import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';

class ImagePage extends Page {
  String url;
  BuildContext mContext;

  ImagePage({this.url});

  @override
  void onCreate(BuildContext context, Page page) {
    mContext = context;
    print(page.url);
  }
}