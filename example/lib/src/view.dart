import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';

class ViewPage extends Page {
  String url;
  BuildContext mContext;

  ViewPage({this.url});

  @override
  void onCreate(BuildContext context, Page widget) {
    mContext = context;
    print(widget.url);
  }

  Map<String, Function> get methods => {
    "topLeftOnTap": () {
      print("topLeft onTap");
    },
    "topLeftOnLongTap": () {
      print("topLeft onLongTap");
    }
  };
}