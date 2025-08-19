import 'package:flutter/material.dart';
import 'package:qurademy_hybrid/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quraademy',
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 25,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),

          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 32,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w700,
              color: AppColors.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,
              color: AppColors.tertairyTextColor,
            ),
          ),
          const SizedBox(height: 20),
          Flexible(
            flex: 1,
            child: SvgPicture.asset(
              image,
              height: 400, // control height directly
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
