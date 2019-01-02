import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';

class ButtonPage extends Page {
  String url;

  ButtonPage({this.url});

  @override
  void onCreate(BuildContext context, Page page) {
//    print(page.url);
//    print(page.emitter);
//    print(page.view);
//    page.emitter.on('lifecycle', () => print('监听'));
  }
}