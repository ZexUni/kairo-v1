import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:kairo/features/onboarding/onboarding_controller.dart';
import 'package:kairo/features/onboarding/step1_demographics.dart';
import 'package:kairo/features/onboarding/step2_measurements.dart';
import 'package:kairo/features/onboarding/step3_lifestyle_qna.dart';
import 'package:kairo/features/onboarding/step4_sleep_qna.dart';
import 'package:kairo/features/onboarding/step5_activity_qna.dart';
import 'package:kairo/features/onboarding/step6_stress_qna.dart';
import 'package:kairo/features/onboarding/step7_nutrition_qna.dart';
import 'package:kairo/features/onboarding/step8_exercise_test.dart';
import 'package:kairo/core/constants/app_colors.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _scrollToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<OnboardingController>(
        builder: (context, controller, child) {
          // Sync controller page with PageView
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_pageController.hasClients && _pageController.page?.round() != controller.currentStep) {
              _pageController.animateToPage(
                controller.currentStep,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          });

          return SafeArea(
            child: Column(
              children: [
                // Top Progress indicator
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      if (controller.currentStep > 0)
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                          onPressed: () => controller.previousStep(),
                        )
                      else
                        const SizedBox(width: 48),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (controller.currentStep + 1) / 8.0,
                            minHeight: 6,
                            backgroundColor: Colors.white10,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          "${controller.currentStep + 1}/8",
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      Step1Demographics(),
                      Step2Measurements(),
                      Step3LifestyleQna(),
                      Step4SleepQna(),
                      Step5ActivityQna(),
                      Step6StressQna(),
                      Step7NutritionQna(),
                      Step8ExerciseTest(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
