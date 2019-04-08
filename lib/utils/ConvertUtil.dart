import 'dart:convert';

import 'package:path/path.dart' as path;

class ConvertUtil {
  /// Convert the value of String type to the value of dynamic type.
  ///
  /// Example:
  ///
  /// var aa = ConvertUtil.parseValue("'string'");
  /// print(aa == 'string'); // true
  ///
  /// var bb = ConvertUtil.parseValue("123");
  /// print(bb == 123); // true
  ///
  /// var cc = ConvertUtil.parseValue("false");
  /// print(cc == false); // true
  ///
  /// Map map = {
  ///    "type": 'string'
  /// };
  /// var dd = ConvertUtil.parseValue('type', map);
  /// print(dd);
  ///
  static parseValue(dynamic value, [dynamic global]) {
    if (value.runtimeType == String) {
      if (value == "true") return true;
      if (value == "false") return false;
      dynamic realValue = value.trim();
      try {
        realValue = "{'value':${realValue}}".replaceAll(r"'", "\"");
        realValue = json.decode(realValue)['value'];
      } catch (e) {
        realValue = (global is Map) ? global[value] : null;
      }
      return realValue;
    }
    return value;
  }

  static Map parseFunction(String input) {
    Map map = new Map();
    String name = "";
    List arguments = new List();
    RegExp nameExp = new RegExp(r"(^.+)\(");
    RegExp argumentsExp = new RegExp(r"\((.+?)\)");

    Match nameMatch = nameExp.firstMatch(input);
    if (nameMatch != null) {
      name = nameMatch.group(1);
    } else {
      name = input;
    }

    Match argumentsMatch = argumentsExp.firstMatch(input);
    if (argumentsMatch != null) {
      List<String> argumentsList = argumentsMatch.group(1).trim().split(r",");
      for (String argument in argumentsList) {
        arguments.add(parseValue(argument));
      }
    }

    map['name'] = name;
    map['arguments'] = arguments;

    return map;
  }

  static String parsePath(String pagePath, String filePath) {
    List pageList = path.split(pagePath);
    pageList.removeLast();

    List<String> fileList = filePath.split(r"/");
    for (var i = 0; i < fileList.length; i++) {
      String item = fileList[i];
      if (item == ".") {
        fileList.removeAt(i);
      }
      if (item == "..") {
        fileList.removeAt(i);
        pageList.removeLast();
      }
    }

    return path.join(pageList.join('/'), fileList.join("/"));
  }

  static String compileTemplateString(String template, Map data) {
    if (template != null && data != null) {
      RegExp regExp = new RegExp(r'{{(.+?)}}');
      Iterable<Match> matches = regExp.allMatches(template);
      for (Match match in matches) {
        String origin = match[0];
        String variable = match[1];
        String value =
            data.isNotEmpty && variable.isNotEmpty ? data[variable] : "";
        template = template.replaceAll(new RegExp(origin), value);
      }
    }
    return template;
  }
}
