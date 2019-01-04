import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program_example/app.dart';
import 'package:flutter_mini_program_example/src/button.dart';
import 'package:flutter_mini_program_example/src/checkbox.dart';
import 'package:flutter_mini_program_example/src/icon.dart';
import 'package:flutter_mini_program_example/src/image.dart';
import 'package:flutter_mini_program_example/src/index.dart';
import 'package:flutter_mini_program_example/src/switch.dart';
import 'package:flutter_mini_program_example/src/text.dart';
import 'package:flutter_mini_program_example/src/video.dart';
import 'package:flutter_mini_program_example/src/view.dart';

void main() {
  runApp(MiniProgramApp());
}

class MiniProgramApp extends StatefulWidget {
  @override
  MiniProgramAppState createState() => MiniProgramAppState();
}

class MiniProgramAppState extends State<MiniProgramApp> {
  MiniProgramAppState() {
    App.init({
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
      // Image
      "/image": ImagePage(url: 'assets/page/image.html'),
      // Video
      "/video": VideoPage(url: 'assets/page/video.html'),
      // WebView
      "/webview": Page(url: 'assets/page/webview.html')
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(onGenerateRoute: App.router.generator);
  }
}
