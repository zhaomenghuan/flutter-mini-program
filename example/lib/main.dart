import 'package:flutter/material.dart';
import 'package:flutter_mini_program/App.dart';
import 'package:flutter_mini_program/Page.dart';

void main() {
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
      "/": Page(url: 'assets/page/index.aml'),
      // View
      "/view": Page(url: 'assets/page/view.aml'),
      // Icon
      "/icon": Page(url: 'assets/page/icon.aml'),
      // Text
      "/text": Page(url: 'assets/page/text.aml'),
      // Button
      "/button": Page(url: 'assets/page/button.aml'),
      // Input
      "/input": Page(url: 'assets/page/input.aml'),
      // Checkbox
      "/checkbox": Page(url: 'assets/page/checkbox.aml'),
      // Switch
      "/switch": Page(url: 'assets/page/switch.aml'),
      // Slider
      "/slider": Page(url: 'assets/page/slider.aml'),
      // Image
      "/image": Page(url: 'assets/page/image.aml'),
      // Video
      "/video": Page(url: 'assets/page/video.aml'),
      // WebView
      "/webview": Page(url: 'assets/page/webview.aml'),
      // JS_API
      "/jsapi": Page(url: 'assets/page/jsapi.aml')
    });

    return MaterialApp(
        onGenerateRoute: App.router.generator,
        debugShowCheckedModeBanner: true);
  }
}
