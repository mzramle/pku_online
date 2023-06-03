import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:pku_online/routes/router.dart';
import 'package:pku_online/utils/textscale.dart';
import 'package:pku_online/firebase_options.dart';
import 'package:pku_online/page/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: fixTextScale,
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}
