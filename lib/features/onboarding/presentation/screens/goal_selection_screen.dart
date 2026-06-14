import 'package:flutter/material.dart';

import 'package:kairo/models/onboarding_data.dart';

import 'package:kairo/core/constants/app_colors.dart';

import 'package:kairo/core/widgets/progress_header.dart';
import 'package:kairo/core/widgets/primary_button.dart';

import 'package:kairo/features/onboarding/presentation/screens/analysis_screen.dart';

class GoalSelectionScreen extends StatefulWidget {
  final OnboardingData onboardingData;

  const GoalSelectionScreen({super.key, required this.onboardingData});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  String selectedPhysique = 'Balanced';

  String selectedEnvironment = 'Full Gym';

  String selectedExperience = 'Beginner';

  String selectedDiet = 'Non-Veg';

  Widget selectionCard({
    required String title,

    required bool selected,

    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        margin: const EdgeInsets.only(bottom: 16),

        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.card,

          borderRadius: BorderRadius.circular(20),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text(
              title,

              style: TextStyle(
                color: selected ? Colors.black : Colors.white,

                fontWeight: FontWeight.bold,

                fontSize: 16,
              ),
            ),

            if (selected) const Icon(Icons.check, color: Colors.black),
          ],
        ),
      ),
    );
  }

  void continueFlow() {
    widget.onboardingData.physiqueGoal = selectedPhysique;

    widget.onboardingData.trainingEnvironment = selectedEnvironment;

    widget.onboardingData.experienceLevel = selectedExperience;

    widget.onboardingData.dietPreference = selectedDiet;

    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) =>
            AnalysisScreen(onboardingData: widget.onboardingData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            24 + MediaQuery.viewInsetsOf(context).bottom,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const ProgressHeader(step: 3, totalSteps: 3),

              const SizedBox(height: 35),

              const Text(
                'Build Your System',

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 34,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                'Select your adaptive training profile.',

                style: TextStyle(
                  color: AppColors.textSecondary,

                  fontSize: 16,

                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              // =========================
              // TARGET PHYSIQUE
              // =========================
              const Text(
                'Target Physique',

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 20,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              selectionCard(
                title: 'Bulk',

                selected: selectedPhysique == 'Bulk',

                onTap: () {
                  setState(() {
                    selectedPhysique = 'Bulk';
                  });
                },
              ),

              selectionCard(
                title: 'Balanced',

                selected: selectedPhysique == 'Balanced',

                onTap: () {
                  setState(() {
                    selectedPhysique = 'Balanced';
                  });
                },
              ),

              selectionCard(
                title: 'Slim',

                selected: selectedPhysique == 'Slim',

                onTap: () {
                  setState(() {
                    selectedPhysique = 'Slim';
                  });
                },
              ),

              const SizedBox(height: 36),

              // =========================
              // TRAINING ENVIRONMENT
              // =========================
              const Text(
                'Training Environment',

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 20,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              selectionCard(
                title: 'Full Gym',

                selected: selectedEnvironment == 'Full Gym',

                onTap: () {
                  setState(() {
                    selectedEnvironment = 'Full Gym';
                  });
                },
              ),

              selectionCard(
                title: 'Dumbbells Only',

                selected: selectedEnvironment == 'Dumbbells Only',

                onTap: () {
                  setState(() {
                    selectedEnvironment = 'Dumbbells Only';
                  });
                },
              ),

              selectionCard(
                title: 'Bodyweight Only',

                selected: selectedEnvironment == 'Bodyweight Only',

                onTap: () {
                  setState(() {
                    selectedEnvironment = 'Bodyweight Only';
                  });
                },
              ),

              const SizedBox(height: 36),

              // =========================
              // EXPERIENCE LEVEL
              // =========================
              const Text(
                'Experience Level',

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 20,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              selectionCard(
                title: 'Beginner',

                selected: selectedExperience == 'Beginner',

                onTap: () {
                  setState(() {
                    selectedExperience = 'Beginner';
                  });
                },
              ),

              selectionCard(
                title: 'Intermediate',

                selected: selectedExperience == 'Intermediate',

                onTap: () {
                  setState(() {
                    selectedExperience = 'Intermediate';
                  });
                },
              ),

              selectionCard(
                title: 'Advanced',

                selected: selectedExperience == 'Advanced',

                onTap: () {
                  setState(() {
                    selectedExperience = 'Advanced';
                  });
                },
              ),

              const SizedBox(height: 36),

              // =========================
              // DIET PREFERENCE
              // =========================
              const Text(
                'Diet Preference',

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 20,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              selectionCard(
                title: 'Non-Veg',

                selected: selectedDiet == 'Non-Veg',

                onTap: () {
                  setState(() {
                    selectedDiet = 'Non-Veg';
                  });
                },
              ),

              selectionCard(
                title: 'Vegetarian',

                selected: selectedDiet == 'Vegetarian',

                onTap: () {
                  setState(() {
                    selectedDiet = 'Vegetarian';
                  });
                },
              ),

              selectionCard(
                title: 'Vegan',

                selected: selectedDiet == 'Vegan',

                onTap: () {
                  setState(() {
                    selectedDiet = 'Vegan';
                  });
                },
              ),

              const SizedBox(height: 50),

              // =========================
              // BUTTON
              // =========================
              PrimaryButton(
                text: 'ANALYZE SYSTEM',

                icon: Icons.auto_awesome,

                onPressed: continueFlow,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
