import 'package:flutter/material.dart';
import 'package:qurademy_hybrid/pages/onboarding_page.dart';
import 'package:qurademy_hybrid/pages/role_selection_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      home: const RootDecider(),
    );
  }
}

class RootDecider extends StatelessWidget {
  const RootDecider({super.key});

  Future<bool> _hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasSeenOnboarding') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasSeenOnboarding(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final seen = snapshot.data ?? false;
        if (seen) {
          return const RoleSelectionPage();
        } else {
          return const OnboardingPage();
        }
      },
    );
  }
}
