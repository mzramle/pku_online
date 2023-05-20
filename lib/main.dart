import 'package:flutter/material.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/routes/router.dart';
import 'package:MAP-02-G007-PKUOnline-Flutter-App/utils/textscale.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: fixTextScale,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: routes,
    );
  }
}
