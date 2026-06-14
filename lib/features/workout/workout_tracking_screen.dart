import 'package:flutter/material.dart';

import 'package:kairo/models/onboarding_data.dart';

import 'package:kairo/core/constants/app_colors.dart';

import 'package:kairo/core/widgets/exercise_set_card.dart';
import 'package:kairo/core/widgets/primary_button.dart';
import 'package:kairo/core/widgets/intelligence_alert_card.dart';

class WorkoutTrackingScreen extends StatefulWidget {
  final OnboardingData onboardingData;

  const WorkoutTrackingScreen({super.key, required this.onboardingData});

  @override
  State<WorkoutTrackingScreen> createState() => _WorkoutTrackingScreenState();
}

class _WorkoutTrackingScreenState extends State<WorkoutTrackingScreen> {
  late List<Map<String, dynamic>> workoutExercises;

  int completedExercises = 0;

  double totalVolume = 0;

  @override
  void initState() {
    super.initState();

    workoutExercises = widget.onboardingData.generatedWorkout.map((exercise) {
      return {
        'name': exercise,

        'sets': 4,

        'reps': 10,

        'weight': 40.0,

        'completed': false,
      };
    }).toList();

    calculateVolume();
  }

  void calculateVolume() {
    totalVolume = 0;

    for (final exercise in workoutExercises) {
      totalVolume += exercise['sets'] * exercise['reps'] * exercise['weight'];
    }
  }

  void toggleExercise(int index) {
    setState(() {
      workoutExercises[index]['completed'] =
          !workoutExercises[index]['completed'];

      completedExercises = workoutExercises
          .where((exercise) => exercise['completed'])
          .length;
    });
  }

  void finishWorkout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workout Completed Successfully')),
    );

    Navigator.pop(context);
  }

  Widget sessionStat({required String title, required String value}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),

          borderRadius: BorderRadius.circular(18),
        ),

        child: Column(
          children: [
            Text(
              value,

              style: const TextStyle(
                color: Colors.white,

                fontSize: 24,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              title,

              style: const TextStyle(
                color: AppColors.textSecondary,

                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = completedExercises / workoutExercises.length;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: const Text('Workout Session'),
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

              padding: const EdgeInsets.all(28),

              decoration: BoxDecoration(
                gradient: AppColors.cardGradient,

                borderRadius: BorderRadius.circular(28),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Adaptive Workout',

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 30,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    widget.onboardingData.trainingSplit,

                    style: const TextStyle(
                      color: AppColors.primary,

                      fontSize: 16,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Row(
                    children: [
                      sessionStat(
                        title: 'Completed',

                        value: '$completedExercises/${workoutExercises.length}',
                      ),

                      const SizedBox(width: 14),

                      sessionStat(
                        title: 'Volume',

                        value: totalVolume.toStringAsFixed(0),
                      ),

                      const SizedBox(width: 14),

                      sessionStat(
                        title: 'Progress',

                        value: '${(progress * 100).toInt()}%',
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),

                    child: LinearProgressIndicator(
                      value: progress,

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

            const SizedBox(height: 35),

            // =========================
            // AI INSIGHT
            // =========================
            IntelligenceAlertCard(
              title: 'Workout Intelligence',

              message:
                  'Your session is optimized for ${widget.onboardingData.physiqueGoal.toLowerCase()} adaptation and progression.',

              icon: Icons.psychology,
            ),

            const SizedBox(height: 35),

            // =========================
            // EXERCISES
            // =========================
            const Text(
              'Workout Exercises',

              style: TextStyle(
                color: Colors.white,

                fontSize: 24,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 22),

            ...workoutExercises.asMap().entries.map((entry) {
              final index = entry.key;

              final exercise = entry.value;

              return GestureDetector(
                onTap: () {
                  toggleExercise(index);
                },

                child: Opacity(
                  opacity: exercise['completed'] ? 0.6 : 1,

                  child: ExerciseSetCard(
                    exerciseName: exercise['name'],

                    sets: exercise['sets'],

                    reps: exercise['reps'],

                    weight: exercise['weight'],

                    volume:
                        exercise['sets'] *
                        exercise['reps'] *
                        exercise['weight'],
                  ),
                ),
              );
            }),

            const SizedBox(height: 30),

            // =========================
            // COMPLETE BUTTON
            // =========================
            PrimaryButton(
              text: 'FINISH WORKOUT',

              icon: Icons.check_circle,

              onPressed: finishWorkout,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
