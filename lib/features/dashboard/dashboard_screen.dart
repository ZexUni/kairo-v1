import 'package:flutter/material.dart';

import 'package:kairo/models/onboarding_data.dart';

import 'package:kairo/core/constants/app_colors.dart';

import 'package:kairo/core/widgets/dashboard_stat_card.dart';
import 'package:kairo/core/widgets/dashboard_section_title.dart';
import 'package:kairo/core/widgets/intelligence_alert_card.dart';
import 'package:kairo/core/widgets/physiology_card.dart';

import 'package:kairo/features/workout/workout_tracking_screen.dart';
import 'package:kairo/features/workout/workout_history_screen.dart';
import 'package:kairo/features/dashboard/recovery_checkin_screen.dart';
import 'package:kairo/features/dashboard/habit_tracker_screen.dart';
import 'package:kairo/features/nutrition/nutrition_screen.dart';

class DashboardScreen extends StatefulWidget {
  final OnboardingData onboardingData;

  const DashboardScreen({super.key, required this.onboardingData});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final physiology = widget.onboardingData.physiologicalState;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // =========================
              // HEADER
              // =========================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          'KAIRO',

                          style: TextStyle(
                            color: AppColors.primary,

                            fontSize: 14,

                            fontWeight: FontWeight.bold,

                            letterSpacing: 2,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Welcome, ${widget.onboardingData.name}',

                          maxLines: 2,

                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            color: Colors.white,

                            fontSize: 30,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  Container(
                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: AppColors.card,

                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: const Icon(Icons.person, color: AppColors.primary),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              // =========================
              // AI INSIGHT
              // =========================
              IntelligenceAlertCard(
                title: 'Adaptive Intelligence',

                message: widget.onboardingData.adaptiveInsight,

                icon: Icons.psychology,
              ),

              const SizedBox(height: 35),

              // =========================
              // PHYSIOLOGY
              // =========================
              DashboardSectionTitle(title: 'Physiology System'),

              const SizedBox(height: 18),

              PhysiologyCard(
                recovery: physiology.recovery,

                fatigue: physiology.fatigue,

                readiness: physiology.readiness,

                adaptation: physiology.adaptation,
              ),

              const SizedBox(height: 35),

              // =========================
              // STATS
              // =========================
              DashboardSectionTitle(title: 'Performance Stats'),

              const SizedBox(height: 18),

              DashboardStatCard(
                title: 'Readiness',

                value:
                    '${widget.onboardingData.readinessScore.toStringAsFixed(0)}%',

                subtitle: widget.onboardingData.readinessState,

                icon: Icons.bolt,
              ),

              const SizedBox(height: 18),

              DashboardStatCard(
                title: 'Body Category',

                value: widget.onboardingData.bodyCategory,

                subtitle: widget.onboardingData.recommendedProgram,

                icon: Icons.fitness_center,
              ),

              const SizedBox(height: 18),

              DashboardStatCard(
                title: 'Training Split',

                value: widget.onboardingData.trainingSplit,

                subtitle:
                    '${widget.onboardingData.weeklySchedule.length} sessions weekly',

                icon: Icons.calendar_month,
              ),

              const SizedBox(height: 35),

              // =========================
              // DAILY DECISION
              // =========================
              DashboardSectionTitle(title: 'Daily Decision'),

              const SizedBox(height: 18),

              IntelligenceAlertCard(
                title: 'System Recommendation',

                message: widget.onboardingData.dailyDecision,

                icon: Icons.auto_awesome,
              ),

              const SizedBox(height: 35),

              // =========================
              // QUICK ACTIONS
              // =========================
              DashboardSectionTitle(title: 'Quick Actions'),

              const SizedBox(height: 20),

              quickActionButton(
                title: 'Start Workout',

                icon: Icons.play_arrow,

                onTap: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (context) => WorkoutTrackingScreen(
                        onboardingData: widget.onboardingData,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              quickActionButton(
                title: 'Workout History',

                icon: Icons.history,

                onTap: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (context) => const WorkoutHistoryScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              quickActionButton(
                title: 'Recovery Check-In',

                icon: Icons.favorite,

                onTap: () async {
                  await Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (context) => RecoveryCheckinScreen(
                        onboardingData: widget.onboardingData,
                      ),
                    ),
                  );

                  setState(() {});
                },
              ),

              const SizedBox(height: 16),

              quickActionButton(
                title: 'Habit Tracker',

                icon: Icons.check_circle,

                onTap: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (context) => HabitTrackerScreen(
                        onboardingData: widget.onboardingData,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              quickActionButton(
                title: 'Nutrition System',

                icon: Icons.restaurant,

                onTap: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (context) => NutritionScreen(
                        onboardingData: widget.onboardingData,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget quickActionButton({
    required String title,

    required IconData icon,

    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(22),

        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,

          borderRadius: BorderRadius.circular(22),

          border: Border.all(color: Colors.white10, width: 1),
        ),

        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),

                borderRadius: BorderRadius.circular(16),
              ),

              child: Icon(icon, color: AppColors.primary),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Text(
                title,

                style: const TextStyle(
                  color: AppColors.textPrimary,

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
}
