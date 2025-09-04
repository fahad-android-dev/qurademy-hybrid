import 'package:flutter/material.dart';
import 'package:qurademy_hybrid/utils/colors.dart';
import 'package:qurademy_hybrid/widgets/onboarding_content.dart';
import 'package:qurademy_hybrid/pages/role_selection_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  children: const [
                    OnboardingContent(
                      image:
                          'assets/images/onboarding1.svg', // Placeholder, replace with actual image
                      title: 'Learn Anytime, Anywhere',
                      description:
                          'Access world-class courses from top instructors on your phone, anytime you want.',
                    ),
                    OnboardingContent(
                      image:
                          'assets/images/onboarding1.svg', // Placeholder, replace with actual image
                      title: 'Courses Tailored \nFor You',
                      description:
                          'Pick subjects you love and get personalized recommendations to grow faster.',
                    ),
                    OnboardingContent(
                      image:
                          'assets/images/onboarding1.svg', // Placeholder, replace with actual image
                      title: 'Track Your \nProgress',
                      description:
                          'Stay motivated by tracking your learning hours, completed lessons, and certificates',
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_pageIndex == 2) {
                      // Mark onboarding as seen and navigate to role selection
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('hasSeenOnboarding', true);
                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RoleSelectionPage(),
                        ),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  style:
                      ElevatedButton.styleFrom(
                        padding: EdgeInsets
                            .zero, // Remove default padding to allow gradient
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            15,
                          ), // Rounded corners
                        ),
                      ).copyWith(
                        overlayColor: WidgetStateProperty.resolveWith<Color?>((
                          Set<WidgetState> states,
                        ) {
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.white.withOpacity(
                              0.2,
                            ); // Splash effect
                          }
                          return null;
                        }),
                      ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.secondaryColor,
                        ], // Soft gradients
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: 65,
                      child: Text(
                        _pageIndex == 2 ? 'Get Started' : 'Next',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: DotIndicator(isActive: index == _pageIndex),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryColor : AppColors.greyColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
