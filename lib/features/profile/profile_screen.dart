import 'package:flutter/material.dart';

import 'package:kairo/models/onboarding_data.dart';

import 'package:kairo/core/constants/app_colors.dart';

import 'package:kairo/core/widgets/dashboard_stat_card.dart';
import 'package:kairo/core/widgets/intelligence_alert_card.dart';

import 'package:kairo/features/dashboard/preferences_screen.dart';

class ProfileScreen extends StatelessWidget {
  final OnboardingData onboardingData;

  const ProfileScreen({super.key, required this.onboardingData});

  Widget profileTile({
    required IconData icon,

    required String title,

    required String value,
  }) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 18),

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: Colors.white10, width: 1),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),

              borderRadius: BorderRadius.circular(18),
            ),

            child: Icon(icon, color: AppColors.primary),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    color: AppColors.textSecondary,

                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  value,

                  style: const TextStyle(
                    color: Colors.white,

                    fontSize: 18,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget actionButton({
    required String title,

    required IconData icon,

    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,

        margin: const EdgeInsets.only(bottom: 18),

        padding: const EdgeInsets.all(22),

        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,

          borderRadius: BorderRadius.circular(24),

          border: Border.all(color: Colors.white10, width: 1),
        ),

        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),

                borderRadius: BorderRadius.circular(18),
              ),

              child: Icon(icon, color: AppColors.primary),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Text(
                title,

                style: const TextStyle(
                  color: Colors.white,

                  fontSize: 18,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,

              color: AppColors.textSecondary,

              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: const Text('Profile'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =========================
            // PROFILE HEADER
            // =========================
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(30),

              decoration: BoxDecoration(
                gradient: AppColors.cardGradient,

                borderRadius: BorderRadius.circular(30),
              ),

              child: Column(
                children: [
                  Container(
                    height: 110,

                    width: 110,

                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,

                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: const Icon(
                      Icons.person,

                      color: Colors.black,

                      size: 60,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    onboardingData.name,

                    style: const TextStyle(
                      color: Colors.white,

                      fontSize: 30,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    onboardingData.experienceLevel,

                    style: const TextStyle(
                      color: AppColors.primary,

                      fontSize: 16,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  IntelligenceAlertCard(
                    title: 'Identity Matrix',

                    message: onboardingData.personalizedMessage,

                    icon: Icons.psychology,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // =========================
            // STATS
            // =========================
            DashboardStatCard(
              title: 'Readiness',

              value: '${onboardingData.readinessScore.toStringAsFixed(0)}%',

              subtitle: onboardingData.readinessState,

              icon: Icons.bolt,
            ),

            const SizedBox(height: 18),

            DashboardStatCard(
              title: 'Current Streak',

              value: '${onboardingData.streakDays}',

              subtitle: 'Consistency Days',

              icon: Icons.local_fire_department,
            ),

            const SizedBox(height: 35),

            // =========================
            // PROFILE DATA
            // =========================
            profileTile(
              icon: Icons.monitor_weight,

              title: 'Weight',

              value: '${onboardingData.weight.toStringAsFixed(1)} kg',
            ),

            profileTile(
              icon: Icons.height,

              title: 'Height',

              value: '${onboardingData.height.toStringAsFixed(0)} cm',
            ),

            profileTile(
              icon: Icons.fitness_center,

              title: 'Physique Goal',

              value: onboardingData.physiqueGoal,
            ),

            profileTile(
              icon: Icons.restaurant,

              title: 'Diet Preference',

              value: onboardingData.dietPreference,
            ),

            profileTile(
              icon: Icons.calendar_month,

              title: 'Training Split',

              value: onboardingData.trainingSplit,
            ),

            const SizedBox(height: 35),

            // =========================
            // ACTIONS
            // =========================
            actionButton(
              title: 'Preferences',

              icon: Icons.settings,

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) =>
                        PreferencesScreen(onboardingData: onboardingData),
                  ),
                );
              },
            ),

            actionButton(
              title: 'About KAIRO',

              icon: Icons.info,

              onTap: () {
                showAboutDialog(
                  context: context,

                  applicationName: 'KAIRO',

                  applicationVersion: '1.0.0',

                  applicationLegalese: 'Adaptive Performance System',
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
