import 'package:flutter/material.dart';

import 'package:kairo/core/constants/app_colors.dart';

class IntelligenceAlertCard extends StatelessWidget {
  final String title;

  final String message;

  final IconData icon;

  final Color? accentColor;

  const IntelligenceAlertCard({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = accentColor ?? AppColors.primary;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: color.withOpacity(0.25), width: 1.2),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: color.withOpacity(0.12),

              borderRadius: BorderRadius.circular(18),
            ),

            child: Icon(icon, color: color, size: 30),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    color: AppColors.textPrimary,

                    fontSize: 18,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  message,

                  style: const TextStyle(
                    color: AppColors.textSecondary,

                    fontSize: 14,

                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
