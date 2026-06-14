import 'package:flutter/material.dart';

import 'package:kairo/models/onboarding_data.dart';

import 'package:kairo/core/constants/app_colors.dart';

import 'package:kairo/core/services/adaptive_orchestrator.dart';

import 'package:kairo/features/dashboard/dashboard_screen.dart';

class AnalysisResultScreen extends StatefulWidget {
  final OnboardingData onboardingData;

  const AnalysisResultScreen({super.key, required this.onboardingData});

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  bool loading = true;

  String loadingText = 'Analyzing Your Physiology...';

  @override
  void initState() {
    super.initState();

    generateAnalysis();
  }

  Future<void> generateAnalysis() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      loadingText = 'Building Adaptive Profile...';
    });

    await AdaptiveOrchestrator.analyzeAndPersist(widget.onboardingData);

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      loading = false;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,

      MaterialPageRoute(
        builder: (context) =>
            DashboardScreen(onboardingData: widget.onboardingData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: loading
          ? SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(30),

                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                    Container(
                      padding: const EdgeInsets.all(26),

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        color: AppColors.primary.withOpacity(0.1),
                      ),

                      child: const CircularProgressIndicator(
                        color: AppColors.primary,

                        strokeWidth: 3,
                      ),
                    ),

                    const SizedBox(height: 40),

                    Text(
                      loadingText,

                      textAlign: TextAlign.center,

                      style: const TextStyle(
                        color: Colors.white,

                        fontSize: 26,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      widget.onboardingData.physiqueGoal,

                      style: const TextStyle(
                        color: AppColors.textSecondary,

                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 50),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),

                      child: LinearProgressIndicator(
                        minHeight: 10,

                        backgroundColor: Colors.white10,

                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.primary,
                        ),
                      ),
                    ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          : const SizedBox(),
    );
  }
}
