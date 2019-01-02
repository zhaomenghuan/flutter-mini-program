import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';

class ViewPage extends Page {
  String url;
  BuildContext mContext;
  Page mPage;

  ViewPage({this.url});

  @override
  void onCreate(BuildContext context, Page page) {
    mContext = context;
    mPage = page;
    print(page.url);
    page.data = {"message": "Hello Flutter MiniProgram"};
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
