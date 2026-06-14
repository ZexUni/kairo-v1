import 'package:flutter/material.dart';

import 'package:kairo/core/constants/app_colors.dart';

class PhysiologyCard extends StatelessWidget {
  final double recovery;

  final double fatigue;

  final double readiness;

  final double adaptation;

  const PhysiologyCard({
    super.key,
    required this.recovery,
    required this.fatigue,
    required this.readiness,
    required this.adaptation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Physiological State',

            style: TextStyle(
              color: AppColors.textPrimary,

              fontSize: 24,

              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Real-time adaptive system analysis.',

            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),

          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(
                child: metricCard(
                  title: 'Recovery',

                  value: recovery,

                  icon: Icons.favorite,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: metricCard(
                  title: 'Fatigue',

                  value: fatigue,

                  icon: Icons.bolt,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: metricCard(
                  title: 'Readiness',

                  value: readiness,

                  icon: Icons.psychology,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: metricCard(
                  title: 'Adaptation',

                  value: adaptation,

                  icon: Icons.trending_up,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget metricCard({
    required String title,

    required double value,

    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(icon, color: AppColors.primary, size: 28),

          const SizedBox(height: 16),

          Text(
            title,

            style: const TextStyle(
              color: AppColors.textSecondary,

              fontSize: 14,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            value.toStringAsFixed(0),

            style: const TextStyle(
              color: AppColors.textPrimary,

              fontSize: 28,

              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),

            child: LinearProgressIndicator(
              value: value / 100,

              minHeight: 8,

              backgroundColor: Colors.white10,

              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
