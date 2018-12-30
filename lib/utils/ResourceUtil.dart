import 'package:flutter/material.dart';

class ResourceUtil {
  static loadStringFromAssetFile(BuildContext context, String url) async {
    return await DefaultAssetBundle.of(context).loadString(url);
  }
}