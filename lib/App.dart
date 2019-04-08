import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mini_program/engine/JSContext.dart';

class App {
  static Router router;
  static JSContext jsContext;

  static init(BuildContext context, {routes}) {
    // Router
    var router = new Router();

    // 404
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new Container(width: 0.0, height: 0.0);
    });

    routes.forEach((name, page) {
      router.define(name, handler: new Handler(handlerFunc:
          (BuildContext context, Map<String, List<String>> params) {
        return page;
      }));
    });

    App.router = router;
    App.jsContext = new JSContext();

    initFramework();
  }

  static initFramework() async {
    await App.jsContext.evaluateScript('''
    var pages = {};
    function Page(options) {
      var page = {};
      page.config = options.config || {};
      page.data = options.data || {};
      page.methods = {};
      if(options.methods) {
        for(var key in options.methods) {
          page.methods[key] = options.methods[key].toString();
        }
      }
      return page;
    }
    ''');

    jsContext.setProperty(
        "invokeMethod", (String method, List arguments) async {});
  }

  static navigateTo(BuildContext context, String path) {
    App.router
        .navigateTo(context, path, transition: TransitionType.inFromRight);
  }
}
