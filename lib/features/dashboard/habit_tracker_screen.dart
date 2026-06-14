import 'package:flutter/material.dart';

import 'package:kairo/models/onboarding_data.dart';

import 'package:kairo/core/constants/app_colors.dart';

import 'package:kairo/core/services/adaptive_orchestrator.dart';
import 'package:kairo/core/services/habit_engine.dart';

class HabitTrackerScreen extends StatefulWidget {
  final OnboardingData onboardingData;

  const HabitTrackerScreen({super.key, required this.onboardingData});

  @override
  State<HabitTrackerScreen> createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {
  final List<Map<String, dynamic>> habits = [
    {'title': 'Workout Completed', 'completed': false},

    {'title': 'Protein Goal Hit', 'completed': false},

    {'title': 'Hydration Goal', 'completed': false},

    {'title': 'Sleep 7+ Hours', 'completed': false},

    {'title': 'Stretch / Mobility', 'completed': false},
  ];

  int completion = 0;

  String state = 'FOUNDATION';

  String message = 'Build consistency daily.';

  Future<void> updateHabits() async {
    final habitStates = habits
        .map((habit) => habit['completed'] as bool)
        .toList();

    completion = HabitEngine.calculateCompletion(habitStates);

    state = HabitEngine.adherenceState(completion);

    message = HabitEngine.motivationalMessage(completion);

    widget.onboardingData.dailyCompletion = completion;

    widget.onboardingData.streakDays = HabitEngine.updateStreak(
      currentStreak: widget.onboardingData.streakDays,

      completion: completion,
    );

    await AdaptiveOrchestrator.analyzeAndPersist(widget.onboardingData);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: const Text('Habit Tracker'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =========================
            // HEADER CARD
            // =========================
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                gradient: AppColors.cardGradient,

                borderRadius: BorderRadius.circular(26),

                border: Border.all(color: Colors.white10, width: 1),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Discipline System',

                    style: TextStyle(
                      color: AppColors.textSecondary,

                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    '$completion%',

                    style: const TextStyle(
                      color: Colors.white,

                      fontSize: 46,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    state,

                    style: const TextStyle(
                      color: AppColors.primary,

                      fontSize: 16,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 22),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),

                    child: LinearProgressIndicator(
                      value: completion / 100,

                      minHeight: 10,

                      backgroundColor: Colors.white10,

                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Text(
                    message,

                    style: const TextStyle(
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
            // STREAK CARD
            // =========================
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                color: AppColors.card,

                borderRadius: BorderRadius.circular(24),
              ),

              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.15),

                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: const Icon(
                      Icons.local_fire_department,

                      color: Colors.orange,

                      size: 34,
                    ),
                  ),

                  const SizedBox(width: 18),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          'Current Streak',

                          style: TextStyle(
                            color: AppColors.textSecondary,

                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          '${widget.onboardingData.streakDays} Days',

                          style: const TextStyle(
                            color: Colors.white,

                            fontSize: 28,

                            fontWeight: FontWeight.bold,
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
            // HABITS
            // =========================
            const Text(
              'Daily Habits',

              style: TextStyle(
                color: Colors.white,

                fontSize: 24,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ...habits.asMap().entries.map((entry) {
              final index = entry.key;

              final habit = entry.value;

              return GestureDetector(
                onTap: () {
                  habits[index]['completed'] = !habits[index]['completed'];

                  updateHabits();
                },

                child: Container(
                  width: double.infinity,

                  margin: const EdgeInsets.only(bottom: 18),

                  padding: const EdgeInsets.all(22),

                  decoration: BoxDecoration(
                    gradient: AppColors.cardGradient,

                    borderRadius: BorderRadius.circular(22),

                    border: Border.all(
                      color: habit['completed']
                          ? AppColors.primary
                          : Colors.white10,

                      width: 1,
                    ),
                  ),

                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),

                        height: 28,

                        width: 28,

                        decoration: BoxDecoration(
                          color: habit['completed']
                              ? AppColors.primary
                              : Colors.transparent,

                          borderRadius: BorderRadius.circular(8),

                          border: Border.all(
                            color: habit['completed']
                                ? AppColors.primary
                                : Colors.white38,

                            width: 2,
                          ),
                        ),

                        child: habit['completed']
                            ? const Icon(
                                Icons.check,

                                size: 18,

                                color: Colors.black,
                              )
                            : null,
                      ),

                      const SizedBox(width: 18),

                      Expanded(
                        child: Text(
                          habit['title'],

                          style: const TextStyle(
                            color: Colors.white,

                            fontSize: 17,

                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
