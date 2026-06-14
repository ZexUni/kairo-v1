import 'package:flutter/material.dart';

import 'package:kairo/models/onboarding_data.dart';

import 'package:kairo/core/constants/app_colors.dart';

import 'package:kairo/core/widgets/primary_button.dart';
import 'package:kairo/core/widgets/primary_textfield.dart';
import 'package:kairo/core/widgets/progress_header.dart';

import 'package:kairo/features/onboarding/presentation/screens/goal_selection_screen.dart';

class BodyMetricsScreen extends StatefulWidget {
  final OnboardingData onboardingData;

  const BodyMetricsScreen({super.key, required this.onboardingData});

  @override
  State<BodyMetricsScreen> createState() => _BodyMetricsScreenState();
}

class _BodyMetricsScreenState extends State<BodyMetricsScreen> {
  final TextEditingController ageController = TextEditingController();

  final TextEditingController heightController = TextEditingController();

  final TextEditingController weightController = TextEditingController();

  String selectedGender = 'Male';

  Widget genderCard(String gender) {
    final bool selected = selectedGender == gender;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedGender = gender;
          });
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),

          padding: const EdgeInsets.symmetric(vertical: 20),

          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.card,

            borderRadius: BorderRadius.circular(20),
          ),

          child: Column(
            children: [
              Icon(
                gender == 'Male' ? Icons.male : Icons.female,

                color: selected ? Colors.black : Colors.white,

                size: 34,
              ),

              const SizedBox(height: 12),

              Text(
                gender,

                style: TextStyle(
                  color: selected ? Colors.black : Colors.white,

                  fontWeight: FontWeight.bold,

                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void continueFlow() {
    final age = int.tryParse(ageController.text);

    final height = double.tryParse(heightController.text);

    final weight = double.tryParse(weightController.text);

    if (age == null || height == null || weight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid body metrics.')),
      );

      return;
    }

    widget.onboardingData.age = age;

    widget.onboardingData.gender = selectedGender;

    widget.onboardingData.height = height;

    widget.onboardingData.weight = weight;

    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) =>
            GoalSelectionScreen(onboardingData: widget.onboardingData),
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
              const ProgressHeader(step: 2, totalSteps: 3),

              const SizedBox(height: 35),

              const Text(
                'Body Metrics',

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 34,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                'Build your physiological profile.',

                style: TextStyle(
                  color: AppColors.textSecondary,

                  fontSize: 16,

                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              // =========================
              // AGE
              // =========================
              const Text(
                'Age',

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 18,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              PrimaryTextField(
                controller: ageController,

                hintText: 'Enter your age',

                keyboardType: TextInputType.number,

                prefixIcon: Icons.cake,
              ),

              const SizedBox(height: 30),

              // =========================
              // GENDER
              // =========================
              const Text(
                'Gender',

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 18,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  genderCard('Male'),

                  const SizedBox(width: 16),

                  genderCard('Female'),
                ],
              ),

              const SizedBox(height: 30),

              // =========================
              // HEIGHT
              // =========================
              const Text(
                'Height (cm)',

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 18,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              PrimaryTextField(
                controller: heightController,

                hintText: 'Enter your height',

                keyboardType: TextInputType.number,

                prefixIcon: Icons.height,
              ),

              const SizedBox(height: 30),

              // =========================
              // WEIGHT
              // =========================
              const Text(
                'Weight (kg)',

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 18,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              PrimaryTextField(
                controller: weightController,

                hintText: 'Enter your weight',

                keyboardType: TextInputType.number,

                prefixIcon: Icons.monitor_weight,
              ),

              const SizedBox(height: 50),

              // =========================
              // BUTTON
              // =========================
              PrimaryButton(
                text: 'CONTINUE',

                icon: Icons.arrow_forward,

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
