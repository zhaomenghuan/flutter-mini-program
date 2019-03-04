import 'package:flutter/material.dart';
import 'package:flutter_mini_program/App.dart';
import 'package:flutter_mini_program/Page.dart';

class IndexPage extends Page {
  String url;
  BuildContext mContext;

  IndexPage({this.url});

  @override
  void onCreate(BuildContext context, Page page) {
    mContext = context;
    print(page);
//    print(page.emitter);
//    print(page.view);
//    print(Application.router);
//    page.emitter.on('lifecycle', () => print('监听'));
  }

  Map<String, Function> get methods => {
    "openPage": (String path) {
      App.navigateTo(mContext, path);
    }
  };
}
