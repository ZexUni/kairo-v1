import 'package:flutter/material.dart';

import 'package:kairo/core/constants/app_colors.dart';

import 'package:kairo/core/widgets/exercise_set_card.dart';
import 'package:kairo/core/widgets/volume_chart.dart';

class WorkoutHistoryScreen extends StatelessWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> workoutHistory = [
      {
        'exercise': 'Barbell Bench Press',

        'sets': 4,

        'reps': 8,

        'weight': 80.0,

        'volume': 2560.0,
      },

      {
        'exercise': 'Pull Ups',

        'sets': 4,

        'reps': 10,

        'weight': 0.0,

        'volume': 0.0,
      },

      {
        'exercise': 'Barbell Squat',

        'sets': 5,

        'reps': 5,

        'weight': 120.0,

        'volume': 3000.0,
      },

      {
        'exercise': 'Overhead Press',

        'sets': 4,

        'reps': 8,

        'weight': 50.0,

        'volume': 1600.0,
      },
    ];

    final List<double> volumeData = [6200, 7100, 6800, 7600, 8100, 8500, 9200];

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: const Text('Workout History'),
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
                    'Training Archive',

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 30,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'Track progression, volume, and performance evolution.',

                    style: TextStyle(
                      color: AppColors.textSecondary,

                      fontSize: 15,

                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Row(
                    children: [
                      Expanded(
                        child: statCard(title: 'Sessions', value: '28'),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: statCard(title: 'Volume', value: '52K'),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: statCard(title: 'Streak', value: '12'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // =========================
            // VOLUME CHART
            // =========================
            VolumeChart(volumes: volumeData),

            const SizedBox(height: 35),

            // =========================
            // EXERCISE HISTORY
            // =========================
            const Text(
              'Recent Sessions',

              style: TextStyle(
                color: Colors.white,

                fontSize: 24,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 22),

            ...workoutHistory.map((workout) {
              return ExerciseSetCard(
                exerciseName: workout['exercise'],

                sets: workout['sets'],

                reps: workout['reps'],

                weight: workout['weight'],

                volume: workout['volume'],
              );
            }),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget statCard({required String title, required String value}) {
    return Container(
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
    );
  }
}
