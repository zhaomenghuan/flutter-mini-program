import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mini_program/utils/ConvertUtil.dart';
import 'package:path/path.dart';

void main() {
  String _string = 'string';
  print(_string == String.fromEnvironment("a", defaultValue: 'string'));

  bool _bool = false;
  bool b = true;
  print(bool.fromEnvironment("b"));

  // var aa = ConvertUtil.parseValue("a");
  // print(aa);
}