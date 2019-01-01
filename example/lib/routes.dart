import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mini_program_example/src/button.dart';
import 'package:flutter_mini_program_example/src/checkbox.dart';
import 'package:flutter_mini_program_example/src/icon.dart';
import 'package:flutter_mini_program_example/src/image.dart';
import 'package:flutter_mini_program_example/src/index.dart';
import 'package:flutter_mini_program_example/src/text.dart';
import 'package:flutter_mini_program_example/src/video.dart';

class Routes {
  static void configureRoutes(Router router) {
    // 404
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new Container(width: 0.0, height: 0.0);
    });

    // Home
    defineRoute(router, "/", (BuildContext context, Map<String, List<String>> params) {
      return new IndexPage(url: 'assets/page/index.html');
    });

    // View
    defineRoute(router, "/view", (BuildContext context, Map<String, List<String>> params) {
      return new IconPage(url: 'assets/page/view.html');
    });

    // Icon
    defineRoute(router, "/icon", (BuildContext context, Map<String, List<String>> params) {
      return new IconPage(url: 'assets/page/icon.html');
    });

    // Text
    defineRoute(router, "/text",
        (BuildContext context, Map<String, List<String>> params) {
      return new TextPage(url: 'assets/page/text.html');
    });

    // Button
    defineRoute(router, "/button",
        (BuildContext context, Map<String, List<String>> params) {
      return new ButtonPage(url: 'assets/page/button.html');
    });

    // Checkbox
    defineRoute(router, "/checkbox",
            (BuildContext context, Map<String, List<String>> params) {
          return new CheckboxPage(url: 'assets/page/checkbox.html');
        });

    // Image
    defineRoute(router, "/image",
        (BuildContext context, Map<String, List<String>> params) {
      return new ImagePage(url: 'assets/page/image.html');
    });

    // Video
    defineRoute(router, "/video",
            (BuildContext context, Map<String, List<String>> params) {
          return new VideoPage(url: 'assets/page/video.html');
        });
  }

  static defineRoute(Router router, String name, HandlerFunc handlerFunc) {
    router.define(name, handler: new Handler(handlerFunc: handlerFunc));
  }
}
