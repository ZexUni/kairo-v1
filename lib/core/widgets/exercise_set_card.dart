import 'package:flutter/material.dart';

import 'package:kairo/core/constants/app_colors.dart';

class ExerciseSetCard extends StatelessWidget {
  final String exerciseName;

  final int sets;

  final int reps;

  final double weight;

  final double volume;

  final VoidCallback? onTap;

  const ExerciseSetCard({
    super.key,
    required this.exerciseName,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.volume,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Expanded(
                  child: Text(
                    exerciseName,

                    style: const TextStyle(
                      color: AppColors.textPrimary,

                      fontSize: 22,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,

                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),

                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: const Text(
                    'LOGGED',

                    style: TextStyle(
                      color: AppColors.primary,

                      fontWeight: FontWeight.bold,

                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: metricTile(title: 'Sets', value: sets.toString()),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: metricTile(title: 'Reps', value: reps.toString()),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: metricTile(
                    title: 'Weight',

                    value: '${weight.toStringAsFixed(0)} kg',
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: metricTile(
                    title: 'Volume',

                    value: volume.toStringAsFixed(0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget metricTile({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),

        borderRadius: BorderRadius.circular(18),
      ),

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

          const SizedBox(height: 10),

          Text(
            value,

            style: const TextStyle(
              color: AppColors.textPrimary,

              fontSize: 20,

              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
