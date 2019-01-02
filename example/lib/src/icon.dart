import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';

class IconPage extends Page {
  String url;
  BuildContext mContext;

  IconPage({this.url});

  @override
  void onCreate(BuildContext context, Page page) {
    mContext = context;
    print(page.url);
  }
}