import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:kairo/core/constants/app_colors.dart';

class PhysiologyStateCard extends StatelessWidget {
  final String label;
  final double score; // 0.0 to 1.0
  final Color color;
  final bool invert; // if true, lower is better (stress)

  const PhysiologyStateCard({
    super.key,
    required this.label,
    required this.score,
    required this.color,
    this.invert = false,
  });

  @override
  Widget build(BuildContext context) {
    // For inverted (like stress), show green if score is low, red if high
    final displayColor = invert
        ? (score < 0.4 ? AppColors.success : (score < 0.7 ? AppColors.warning : AppColors.danger))
        : color;

    final percentValue = score.clamp(0.0, 1.0);

    return Card(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 7.0,
              percent: percentValue,
              center: Text(
                "${(percentValue * 100).round()}%",
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              progressColor: displayColor,
              backgroundColor: Colors.white12,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 1000,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
