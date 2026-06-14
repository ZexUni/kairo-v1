import 'package:flutter/material.dart';

import 'package:kairo/models/onboarding_data.dart';

import 'package:kairo/core/constants/app_colors.dart';
import 'package:kairo/core/widgets/primary_button.dart';

class PreferencesScreen extends StatefulWidget {
  final OnboardingData onboardingData;

  const PreferencesScreen({super.key, required this.onboardingData});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool notificationsEnabled = true;

  bool adaptiveCoaching = true;

  bool darkMode = true;

  bool autoRecoveryAdjustments = true;

  String measurementUnit = 'Metric';

  Widget preferenceTile({
    required String title,

    required String subtitle,

    required bool value,

    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: Colors.white10, width: 1),
      ),

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    color: Colors.white,

                    fontSize: 17,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  subtitle,

                  style: const TextStyle(
                    color: AppColors.textSecondary,

                    fontSize: 14,

                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: value,

            activeThumbColor: AppColors.primary,

            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget unitSelector(String unit) {
    final bool selected = measurementUnit == unit;

    return GestureDetector(
      onTap: () {
        setState(() {
          measurementUnit = unit;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),

        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.card,

          borderRadius: BorderRadius.circular(18),
        ),

        child: Text(
          unit,

          style: TextStyle(
            color: selected ? Colors.black : Colors.white,

            fontWeight: FontWeight.bold,

            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void savePreferences() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Preferences Updated')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: const Text('Preferences'),
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
                    'System Preferences',

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 30,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'Customize your adaptive training ecosystem.',

                    style: TextStyle(
                      color: AppColors.textSecondary,

                      fontSize: 15,

                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // =========================
            // TOGGLES
            // =========================
            preferenceTile(
              title: 'Notifications',

              subtitle: 'Workout reminders and system alerts.',

              value: notificationsEnabled,

              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),

            preferenceTile(
              title: 'Adaptive Coaching',

              subtitle:
                  'Enable intelligent recommendations and recovery adaptation.',

              value: adaptiveCoaching,

              onChanged: (value) {
                setState(() {
                  adaptiveCoaching = value;
                });
              },
            ),

            preferenceTile(
              title: 'Dark Mode',

              subtitle: 'Use the premium dark interface.',

              value: darkMode,

              onChanged: (value) {
                setState(() {
                  darkMode = value;
                });
              },
            ),

            preferenceTile(
              title: 'Auto Recovery Adjustments',

              subtitle: 'Automatically adapt workload based on recovery state.',

              value: autoRecoveryAdjustments,

              onChanged: (value) {
                setState(() {
                  autoRecoveryAdjustments = value;
                });
              },
            ),

            const SizedBox(height: 35),

            // =========================
            // UNIT SELECTION
            // =========================
            const Text(
              'Measurement Unit',

              style: TextStyle(
                color: Colors.white,

                fontSize: 22,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(child: unitSelector('Metric')),

                const SizedBox(width: 16),

                Expanded(child: unitSelector('Imperial')),
              ],
            ),

            const SizedBox(height: 50),

            // =========================
            // SAVE BUTTON
            // =========================
            PrimaryButton(
              text: 'SAVE PREFERENCES',

              icon: Icons.save,

              onPressed: savePreferences,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
