import 'package:flutter/services.dart';

class JSRuntime {
  static const MethodChannel _channel =
      const MethodChannel('mini_program/JSRuntime');

  static Future<String> evaluateJavascript(String script) async {
    Map<String, dynamic> params = <String, dynamic>{'script': script};
    return await _channel.invokeMethod('evaluateJavascript', params);
  }

  static Future<String> invokeMethod(String name, List arguments) async {
    return await _channel.invokeMethod('invokeMethod');
  }
}
