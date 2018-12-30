// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_mini_program_example/main.dart';

void main() {
  testWidgets('Verify Platform version', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MiniProgramApp());

    // Verify that platform version is retrieved.
    expect(
      find.byWidgetPredicate(
        (Widget widget) => widget is Text &&
                           widget.data.startsWith('Running on:'),
      ),
      findsOneWidget,
    );

//      Map<String, dynamic> pages = AppConfig['pages'];
//      if (Application.router == null) {
//        for (var page in pages.entries) {
//          var pagePath = pages[page.key];
//          registerRoute(router, page.key, "assets/$pagePath");
//        }
//        Application.router = router;
//      }
//
//    Future<void> loadAppConfig() async {
//      var config =
//      await ResourceUtil.loadStringFromAssetFile(context, "assets/app.json");
//      setState(() {
//        AppConfig = json.decode(config);
//      });
//    }
//
//    void registerRoute(Router router, String routePath, String pagePath) {
//      router.define(routePath, handler: new Handler(
//          handlerFunc: (BuildContext context, Map<String, List<String>> params) {
//            return new BasePageView(url: pagePath);
//          }));
//    }
  });
}
