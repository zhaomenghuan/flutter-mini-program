import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program_example/application.dart';

class IndexPage extends Page {
  String url;
  BuildContext mContext;

  IndexPage({this.url});

  @override
  void onCreate(BuildContext context, Page page) {
    mContext = context;

    print(page);
    print(page.emitter);
    print(page.view);
    print(Application.router);
    page.emitter.on('lifecycle', () => print('监听'));
  }

  Map data = {
    "list": [
      {"title": "View", "subtitle": "视图容器", "routeName": "/view"},
      {"title": "Icon", "subtitle": "图标", "routeName": "/icon"},
      {"title": "Text", "subtitle": "文本", "routeName": "/text"},
      {"title": "Button", "subtitle": "按钮", "routeName": "/button"},
      {"title": "Checkbox", "subtitle": "复选框", "routeName": "/checkbox"},
      {"title": "Image", "subtitle": "图片", "routeName": "/image"},
      {"title": "Video", "subtitle": "视频", "routeName": "/video"}
    ]
  };

  Map<String, Function> get methods => {
    "openPage": (String path) {
      Application.navigateTo(mContext, path);
    }
  };
}
