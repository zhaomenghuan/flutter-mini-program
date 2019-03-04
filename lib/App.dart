import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class App {
  static Router router;

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
  }

  static navigateTo(BuildContext context, String path) {
    App.router
        .navigateTo(context, path, transition: TransitionType.inFromRight);
  }
}
