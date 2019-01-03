import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:toast/toast.dart';

class SwitchPage extends Page {
  String url;

  SwitchPage({this.url});

  @override
  void onCreate(BuildContext context, Page page) {
    print(page.url);
  }

  Map<String, Function> get methods => {
    "switchChange": (bool checked) {
      Toast.show("switchChange 事件，值: $checked", duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
  };
}