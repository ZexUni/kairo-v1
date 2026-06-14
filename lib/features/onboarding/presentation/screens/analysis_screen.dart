import 'package:flutter/material.dart';

import 'package:kairo/models/onboarding_data.dart';

import 'package:kairo/core/constants/app_colors.dart';

import 'package:kairo/features/analysis/presentation/screens/analysis_result_screen.dart';

class AnalysisScreen extends StatefulWidget {
  final OnboardingData onboardingData;

  const AnalysisScreen({super.key, required this.onboardingData});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  double progress = 0.0;

  String loadingText = 'Initializing Analysis...';

  @override
  void initState() {
    super.initState();

    startAnalysis();
  }

  Future<void> startAnalysis() async {
    await Future.delayed(const Duration(milliseconds: 600));

    setState(() {
      progress = 0.2;

      loadingText = 'Analyzing Body Metrics...';
    });

    await Future.delayed(const Duration(milliseconds: 900));

    setState(() {
      progress = 0.45;

      loadingText = 'Building Physiological Profile...';
    });

    await Future.delayed(const Duration(milliseconds: 900));

    setState(() {
      progress = 0.7;

      loadingText = 'Generating Adaptive Systems...';
    });

    await Future.delayed(const Duration(milliseconds: 900));

    setState(() {
      progress = 1.0;

      loadingText = 'Finalizing Intelligence Matrix...';
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,

      MaterialPageRoute(
        builder: (context) =>
            AnalysisResultScreen(onboardingData: widget.onboardingData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(30),

              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
              // =========================
              // AI CORE
              // =========================
              Container(
                height: 140,

                width: 140,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: AppColors.primaryGradient,

                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),

                      blurRadius: 40,

                      spreadRadius: 4,
                    ),
                  ],
                ),

                child: const Icon(
                  Icons.psychology,

                  color: Colors.black,

                  size: 70,
                ),
              ),

              const SizedBox(height: 50),

              // =========================
              // TITLE
              // =========================
              const Text(
                'KAIRO Intelligence',

                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Colors.white,

                  fontSize: 34,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Constructing your adaptive physiological system.',

                textAlign: TextAlign.center,

                style: TextStyle(
                  color: AppColors.textSecondary,

                  fontSize: 16,

                  height: 1.5,
                ),
              ),

              const SizedBox(height: 60),

              // =========================
              // LOADING TEXT
              // =========================
              Text(
                loadingText,

                textAlign: TextAlign.center,

                style: const TextStyle(
                  color: AppColors.primary,

                  fontSize: 18,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // =========================
              // PROGRESS BAR
              // =========================
              ClipRRect(
                borderRadius: BorderRadius.circular(20),

                child: LinearProgressIndicator(
                  value: progress,

                  minHeight: 12,

                  backgroundColor: Colors.white10,

                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),

              const SizedBox(height: 18),

              Align(
                alignment: Alignment.centerRight,

                child: Text(
                  '${(progress * 100).toInt()}%',

                  style: const TextStyle(
                    color: AppColors.textSecondary,

                    fontSize: 14,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
