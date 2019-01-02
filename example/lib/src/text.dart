import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';

class TextPage extends Page {
  String url;
  BuildContext mContext;

  TextPage({this.url});

  @override
  void onCreate(BuildContext context, Page page) {
    mContext = context;
    print(page.url);
  }
}