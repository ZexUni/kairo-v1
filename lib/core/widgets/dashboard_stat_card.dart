import 'package:flutter/material.dart';

import 'package:kairo/core/constants/app_colors.dart';

class DashboardStatCard extends StatelessWidget {
  final String title;

  final String value;

  final String subtitle;

  final IconData icon;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

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
              Container(
                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),

                  borderRadius: BorderRadius.circular(16),
                ),

                child: Icon(icon, color: AppColors.primary, size: 28),
              ),

              const Icon(Icons.trending_up, color: AppColors.success),
            ],
          ),

          const SizedBox(height: 24),

          Text(
            title,

            style: const TextStyle(
              color: AppColors.textSecondary,

              fontSize: 14,

              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            value,

            style: const TextStyle(
              color: AppColors.textPrimary,

              fontSize: 32,

              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            subtitle,

            style: const TextStyle(
              color: AppColors.primary,

              fontSize: 13,

              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
