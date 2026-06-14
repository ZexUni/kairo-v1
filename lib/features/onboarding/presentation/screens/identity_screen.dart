import 'package:flutter/material.dart';

import 'package:kairo/models/onboarding_data.dart';

import 'package:kairo/core/constants/app_colors.dart';

import 'package:kairo/core/widgets/primary_button.dart';
import 'package:kairo/core/widgets/primary_textfield.dart';
import 'package:kairo/core/widgets/progress_header.dart';

import 'package:kairo/features/onboarding/presentation/screens/body_metrics_screen.dart';

class IdentityScreen extends StatefulWidget {
  const IdentityScreen({super.key});

  @override
  State<IdentityScreen> createState() => _IdentityScreenState();
}

class _IdentityScreenState extends State<IdentityScreen> {
  final TextEditingController nameController = TextEditingController();

  final OnboardingData onboardingData = OnboardingData();

  void continueFlow() {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your name.')));

      return;
    }

    onboardingData.name = nameController.text.trim();

    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) => BodyMetricsScreen(onboardingData: onboardingData),
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
              const ProgressHeader(step: 1, totalSteps: 3),

              const SizedBox(height: 40),

              // =========================
              // LOGO / HEADER
              // =========================
              Container(
                height: 90,

                width: 90,

                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,

                  borderRadius: BorderRadius.circular(28),
                ),

                child: const Icon(
                  Icons.psychology,

                  color: Colors.black,

                  size: 46,
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                'Welcome to KAIRO',

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 38,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Build your adaptive physiological system and evolve intelligently.',

                style: TextStyle(
                  color: AppColors.textSecondary,

                  fontSize: 16,

                  height: 1.6,
                ),
              ),

              const SizedBox(height: 50),

              // =========================
              // NAME INPUT
              // =========================
              const Text(
                'Your Identity',

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 20,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              PrimaryTextField(
                controller: nameController,

                hintText: 'Enter your name',

                prefixIcon: Icons.person,
              ),

              const SizedBox(height: 60),

              // =========================
              // BUTTON
              // =========================
              PrimaryButton(
                text: 'BEGIN ANALYSIS',

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
