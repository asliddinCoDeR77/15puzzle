import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puzzels15/setup/setup.dart';
import 'package:puzzels15/views/screens/introduce/splash_screen.dart';

void main() {
  dependencysetup();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
