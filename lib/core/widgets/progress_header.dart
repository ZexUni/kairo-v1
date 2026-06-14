import 'package:flutter/material.dart';

import 'package:kairo/core/constants/app_colors.dart';

class ProgressHeader extends StatelessWidget {
  final int step;

  final int totalSteps;

  const ProgressHeader({
    super.key,
    required this.step,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = step / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Text(
              'Step $step of $totalSteps',

              style: const TextStyle(
                color: AppColors.textSecondary,

                fontSize: 14,

                fontWeight: FontWeight.w500,
              ),
            ),

            Text(
              '${(progress * 100).toInt()}%',

              style: const TextStyle(
                color: AppColors.primary,

                fontSize: 14,

                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        ClipRRect(
          borderRadius: BorderRadius.circular(20),

          child: LinearProgressIndicator(
            value: progress,

            minHeight: 10,

            backgroundColor: Colors.white10,

            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      ],
    );
  }
}
