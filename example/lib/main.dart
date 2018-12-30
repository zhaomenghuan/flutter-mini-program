import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'package:flutter_mini_program_example/application.dart';
import 'package:flutter_mini_program_example/routes.dart';

void main() {
  runApp(MiniProgramApp());
}

class MiniProgramApp extends StatefulWidget {
  @override
  MiniProgramAppState createState() => MiniProgramAppState();
}

class MiniProgramAppState extends State<MiniProgramApp> {
  var AppConfig = null;

  MiniProgramAppState() {
    final router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(onGenerateRoute: Application.router.generator);
  }
}
