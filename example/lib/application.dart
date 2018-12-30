import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Application {
  static Router router;

  // 保留当前页面，跳转到应用内的某个页面
  static navigateTo(BuildContext context, String path) {
    Application.router.navigateTo(context, path, transition: TransitionType.inFromRight);
  }
}