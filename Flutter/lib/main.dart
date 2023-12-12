import 'package:beslemekahramanlari/pages/login.dart';
import 'package:beslemekahramanlari/pages/profile.dart';
import 'package:beslemekahramanlari/pages/splash.dart';
import 'package:flutter/material.dart';
import 'pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
