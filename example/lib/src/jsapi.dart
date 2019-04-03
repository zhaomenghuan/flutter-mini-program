import 'package:flutter/material.dart';
import 'package:flutter_mini_program/Page.dart';
import 'package:flutter_mini_program/engine/JSContext.dart';

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
      JSContext jsContext = new JSContext();
      const code = """
        // Attached as a property of the current global context scope.
        var obj = {
          number: 1,
          string: 'string',
          date: new Date(),
          array: [1, 'string', null, undefined],
          func: function () {}
        };
        var a = 10;
        // Is a variable, and not attached as a property of the context.
        let objLet = { number: 1, yayForLet: true };
        """;
      await jsContext.evaluateScript(code);

      jsContext.setProperty("log", (String message) async {
        print("[log] $message");
      });
      await jsContext.evaluateScript("log(JSON.stringify(obj))");

      print("******************************");
      var obj = await jsContext.property("obj");
      print("obj = $obj");
      print("******************************");
    }
  };
}