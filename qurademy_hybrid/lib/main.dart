import 'package:flutter/material.dart';
import 'package:qurademy_hybrid/pages/onboarding_page.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 52, 51, 53),
        ),
        useMaterial3: true,
      ),
      home: const OnboardingPage(),
    );
  }
}
