import 'package:flutter/material.dart';
import 'package:flutter_stetho/flutter_stetho.dart';

import 'package:flutter_mini_program/App.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program_example/src/button.dart';
import 'package:flutter_mini_program_example/src/checkbox.dart';
import 'package:flutter_mini_program_example/src/icon.dart';
import 'package:flutter_mini_program_example/src/image.dart';
import 'package:flutter_mini_program_example/src/index.dart';
import 'package:flutter_mini_program_example/src/jsapi.dart';
import 'package:flutter_mini_program_example/src/switch.dart';
import 'package:flutter_mini_program_example/src/text.dart';
import 'package:flutter_mini_program_example/src/video.dart';
import 'package:flutter_mini_program_example/src/view.dart';

void main() {
  Stetho.initialize();
  runApp(MiniProgramApp());
}

class MiniProgramApp extends StatefulWidget {
  @override
  MiniProgramAppState createState() => MiniProgramAppState();
}

class MiniProgramAppState extends State<MiniProgramApp> {
  @override
  Widget build(BuildContext context) {
    App.init(context, routes: {
      // Home
      "/": IndexPage(url: 'assets/page/index.html'),
      // View
      "/view": ViewPage(url: 'assets/page/view.html'),
      // Icon
      "/icon": IconPage(url: 'assets/page/icon.html'),
      // Text
      "/text": TextPage(url: 'assets/page/text.html'),
      // Button
      "/button": ButtonPage(url: 'assets/page/button.html'),
      // Input
      "/input": Page(url: 'assets/page/input.html'),
      // Checkbox
      "/checkbox": CheckboxPage(url: 'assets/page/checkbox.html'),
      // Switch
      "/switch": SwitchPage(url: 'assets/page/switch.html'),
      // Slider
      "/slider": Page(url: 'assets/page/slider.html'),
      // Image
      "/image": ImagePage(url: 'assets/page/image.html'),
      // Video
      "/video": VideoPage(url: 'assets/page/video.html'),
      // WebView
      "/webview": Page(url: 'assets/page/webview.html'),
      // JS_API
      "/jsapi": JSAPIPage(url: 'assets/page/jsapi.html')
    });

    return MaterialApp(
        onGenerateRoute: App.router.generator,
        debugShowCheckedModeBanner: false);
  }
}
