import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/AppService.dart';

class JSAPIPage extends Page {
  String url;
  BuildContext mContext;

  JSAPIPage({this.url});

  @override
  void onCreate(BuildContext context, Page page) {
    mContext = context;
  }

  Map<String, Function> get methods => {
    "onEvaluateJavascript": () async {
      print("evaluateJavascript: ");
      var result = await JSRuntime.evaluateJavascript("window.Math.abs(-4)");
      print(result);
      await JSRuntime.evaluateJavascript("window.fmp.showToast('1')");
    },
    "invokeMethod": () async {
      print("invokeMethod: ");
    }
  };
}