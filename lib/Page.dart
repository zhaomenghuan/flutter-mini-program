import 'package:flutter/material.dart';
import 'package:flutter_mini_program/App.dart';
import 'package:flutter_mini_program/EventEmitter.dart';
import 'package:flutter_mini_program/PageParser.dart';
import 'package:flutter_mini_program/engine/JSContext.dart';
import 'package:flutter_mini_program/utils/ConvertUtil.dart';
import 'package:flutter_mini_program/utils/ResourceUtil.dart';

class Page extends StatefulWidget {
  String url;
  EventEmitter emitter;
  Widget view;
  BuildContext context;
  JSContext jsContext;

  List<Widget> widgetList = new List();

  // Page DSL
  String html;

  // Page Config
  Map config = {};

  // Page Style
  Map style = {};

  // Page Data
  Map data = {};

  // Page Methods
  Map methods = {};

  Page({this.url}) {
    emitter = new EventEmitter();
  }

  @override
  PageState createState() => PageState();

  void onCreate(BuildContext context, Page page) {
    this.context = context;
  }

  void invoke(String functionTag) {
    if (functionTag != null) {
      Map methodMap = ConvertUtil.parseFunction(functionTag);
      String name = methodMap['name'];
      List arguments = methodMap['arguments'];

      print('---------------------');
      print('method: $name');
      print('arguments: $arguments');
      print('---------------------');

      if (methods != null && methods.containsKey(name)) {
        String callback = methods[name];
        print(callback);
        // Function.apply(callback, arguments);

        // TODO: API
        switch (name) {
          case 'openPage':
            App.navigateTo(this.context, arguments[0]);
            break;
        }
      }
    }
  }
}

class PageState extends State<Page> {
  bool _didFailToParse = false;

  // Init Page
  void initPageContext() async {
    widget.jsContext = new JSContext();
    widget.jsContext.setProperty("log", (String message) async {
      print("[log] $message");
    });
  }

  @override
  void initState() {
    super.initState();
    initPageContext();
  }

  void parseContent() async {
    try {
      widget.html =
          await ResourceUtil.loadStringFromAssetFile(context, widget.url);
      Page page = await PageParser.parse(widget);

      setState(() {
        widget.config = page.config;
        widget.data = page.data;
        widget.methods = page.methods;
        widget.widgetList = page.widgetList;
      });
    } catch (e) {
      setState(() {
        _didFailToParse = true;
      });
    }
  }

  String parseTitle() {
    var title = '';
    if (widget.config != null &&
        widget.config.containsKey('navigationBarTitleText')) {
      title = widget.config['navigationBarTitleText'];
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    parseContent();

    if (_didFailToParse || widget.widgetList == null) {
      return new Container(width: 0.0, height: 0.0);
    }
    if (widget.onCreate != null) {
      widget.onCreate(context, widget);
    }

    return new Scaffold(
        appBar: AppBar(title: Text(parseTitle()), centerTitle: true),
        body: SingleChildScrollView(child: Wrap(children: widget.widgetList)));
  }
}
