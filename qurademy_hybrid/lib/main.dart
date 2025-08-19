import 'package:flutter/material.dart';
import 'package:qurademy_hybrid/pages/intro_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qurademy Hybrid',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A3AFF)),
        useMaterial3: true,
      ),
      home: const IntroPage(),
    );
  }
}
