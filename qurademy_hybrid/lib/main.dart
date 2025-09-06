import 'package:flutter/material.dart';
import 'package:qurademy_hybrid/pages/onboarding_page.dart';
import 'package:qurademy_hybrid/pages/role_selection_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qurademy_hybrid/pages/student_home_page.dart';
import 'package:qurademy_hybrid/pages/teacher_home_page.dart';

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

  // Decide which widget to show at app start
  Future<Widget> _decideStartWidget() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final String role = prefs.getString('userRole') ?? '';
    final bool hasSeenOnboarding =
        prefs.getBool('hasSeenOnboarding') ?? false;

    if (isLoggedIn) {
      // Route directly to the correct home page
      if (role.toLowerCase() == 'teacher') {
        return const TeacherHomePage();
      } else {
        return const StudentHomePage();
      }
    }

    // Not logged in: keep existing flow (onboarding -> role selection)
    if (hasSeenOnboarding) {
      return const RoleSelectionPage();
    } else {
      return const OnboardingPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _decideStartWidget(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data ?? const OnboardingPage();
      },
    );
  }
}
