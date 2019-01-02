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
//    print(page);
//    print(page.emitter);
//    print(page.view);
//    print(Application.router);
//    page.emitter.on('lifecycle', () => print('监听'));
  }

  Map data = {
    "list": [
      {"title": "View", "subtitle": "视图容器", "link": "/view"},
      {"title": "Icon", "subtitle": "图标", "link": "/icon"},
      {"title": "Text", "subtitle": "文本", "link": "/text"},
      {"title": "Button", "subtitle": "按钮", "link": "/button"},
      {"title": "Checkbox", "subtitle": "复选框", "link": "/checkbox"},
      {"title": "Image", "subtitle": "图片", "link": "/image"},
      {"title": "Video", "subtitle": "视频", "link": "/video"}
    ]
  };

  Map<String, Function> get methods => {
    "openPage": (String path) {
      Application.navigateTo(mContext, path);
    }
  };
}
