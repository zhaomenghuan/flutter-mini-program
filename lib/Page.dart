import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mini_program/EventEmitter.dart';
import 'package:flutter_mini_program/PageParser.dart';
import 'package:flutter_mini_program/utils/ConvertUtil.dart';
import 'package:flutter_mini_program/utils/ResourceUtil.dart';

abstract class Page extends StatefulWidget {
  String url;
  EventEmitter emitter;
  Widget view;
  String content;

  // Config Tag
  Map config = {};

  // Style Tag
  Map style = {};

  // Data
  Map data = {};

  // Methods
  Map<String, Function> methods;

  Page({this.url}) {
    emitter = new EventEmitter();
  }

  @override
  PageState createState() => PageState();

  void onCreate(BuildContext context, Page page);

  void invoke(String functionTag) {
    if (functionTag != null) {
      Map methodMap = ConvertUtil.parseFunction(functionTag);
      String name = methodMap['name'];
      List arguments = methodMap['arguments'];
      if (methods != null && methods.containsKey(name)) {
        Function callback = methods[name];
        Function.apply(callback, arguments);
      }
    }
  }
}

class PageState extends State<Page> {
  bool _didFailToParse = false;

  @override
  void initState() {
    super.initState();
    parseContent();
  }

  @override
  void didUpdateWidget(Page oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content != widget.content) {
      _didFailToParse = false;
      parseContent();
    }
  }

  void failToBuild() {
    Timer.run(() => setState(() {
          _didFailToParse = true;
        }));
  }

  void parseContent() async {
    try {
      widget.content =
          await ResourceUtil.loadStringFromAssetFile(context, widget.url);
      setState(() {
        widget.view = PageParser.parse(widget.content, widget);
      });
    } on Exception catch (_) {
      setState(() => _didFailToParse = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_didFailToParse || widget.view == null) {
      return new Container(width: 0.0, height: 0.0);
    }
    if (widget.onCreate != null) {
      widget.onCreate(context, widget);
    }
    widget.emitter.emit('lifecycle');
    return widget.view;
  }
}
