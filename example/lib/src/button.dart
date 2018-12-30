import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';

class ButtonPage extends Page {
  String url;

  ButtonPage({this.url});

  @override
  void onCreate(BuildContext context, Page widget) {
    print(widget.url);
//    print(widget.emitter);
//    print(widget.view);
//    widget.emitter.on('lifecycle', () => print('监听'));
  }
}