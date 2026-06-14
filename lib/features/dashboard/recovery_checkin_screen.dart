import 'package:flutter/material.dart';

import 'package:kairo/models/onboarding_data.dart';

import 'package:kairo/core/constants/app_colors.dart';

import 'package:kairo/core/widgets/primary_button.dart';

import 'package:kairo/core/services/adaptive_orchestrator.dart';
import 'package:kairo/core/services/recovery_engine.dart';
import 'package:kairo/models/recovery_input.dart';

class RecoveryCheckinScreen extends StatefulWidget {
  final OnboardingData onboardingData;

  const RecoveryCheckinScreen({super.key, required this.onboardingData});

  @override
  State<RecoveryCheckinScreen> createState() => _RecoveryCheckinScreenState();
}

class _RecoveryCheckinScreenState extends State<RecoveryCheckinScreen> {
  double sleepHours = 7;

  double soreness = 3;

  double stress = 3;

  Widget sliderCard({
    required String title,

    required String subtitle,

    required double value,

    required double min,

    required double max,

    required Function(double) onChanged,
  }) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 22),

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: Colors.white10, width: 1),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,

                      style: const TextStyle(
                        color: Colors.white,

                        fontSize: 18,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      subtitle,

                      style: const TextStyle(
                        color: AppColors.textSecondary,

                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,

                  vertical: 10,
                ),

                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),

                  borderRadius: BorderRadius.circular(16),
                ),

                child: Text(
                  value.toStringAsFixed(0),

                  style: const TextStyle(
                    color: AppColors.primary,

                    fontWeight: FontWeight.bold,

                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Slider(
            value: value,

            min: min,

            max: max,

            activeColor: AppColors.primary,

            inactiveColor: Colors.white12,

            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Future<void> analyzeRecovery() async {
    final recovery = RecoveryInput(
      sleepHours: sleepHours,
      soreness: soreness,
      stress: stress,
    );

    await AdaptiveOrchestrator.analyzeAndPersist(
      widget.onboardingData,
      recoveryInput: recovery,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Recovery Updated')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final readinessState = RecoveryEngine.readinessState(
      RecoveryEngine.calculateReadiness(
        sleepHours: sleepHours,

        soreness: soreness,

        stress: stress,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: const Text('Recovery Check-In'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =========================
            // HEADER
            // =========================
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(26),

              decoration: BoxDecoration(
                gradient: AppColors.cardGradient,

                borderRadius: BorderRadius.circular(28),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Recovery Intelligence',

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 30,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'Analyze fatigue, recovery, and physiological readiness.',

                    style: TextStyle(
                      color: AppColors.textSecondary,

                      fontSize: 15,

                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,

                      vertical: 14,
                    ),

                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),

                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Row(
                      children: [
                        const Icon(Icons.psychology, color: AppColors.primary),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            readinessState,

                            style: const TextStyle(
                              color: AppColors.primary,

                              fontSize: 16,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // =========================
            // SLIDERS
            // =========================
            sliderCard(
              title: 'Sleep Hours',

              subtitle: 'How much sleep did you get?',

              value: sleepHours,

              min: 0,

              max: 12,

              onChanged: (value) {
                setState(() {
                  sleepHours = value;
                });
              },
            ),

            sliderCard(
              title: 'Muscle Soreness',

              subtitle: 'Rate your muscle soreness level.',

              value: soreness,

              min: 0,

              max: 10,

              onChanged: (value) {
                setState(() {
                  soreness = value;
                });
              },
            ),

            sliderCard(
              title: 'Stress Level',

              subtitle: 'How mentally stressed are you?',

              value: stress,

              min: 0,

              max: 10,

              onChanged: (value) {
                setState(() {
                  stress = value;
                });
              },
            ),

            const SizedBox(height: 40),

            // =========================
            // BUTTON
            // =========================
            PrimaryButton(
              text: 'ANALYZE RECOVERY',

              icon: Icons.favorite,

              onPressed: analyzeRecovery,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
