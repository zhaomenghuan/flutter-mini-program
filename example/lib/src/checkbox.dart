import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';

class CheckboxPage extends Page {
  String url;

  CheckboxPage({this.url});

  @override
  void onCreate(BuildContext context, Page widget) {
    print(widget.url);
  }
}