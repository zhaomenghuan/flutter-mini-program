import 'package:flutter/services.dart';

class AppService {
  static const MethodChannel _channel = const MethodChannel('mini_program/AppService');

  static Future<String> invokeMethod(String name, List arguments) async {
    var result = await _channel.invokeMethod('invokeMethod');
    print(name + result);
  }
}