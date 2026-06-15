import 'package:flutter/material.dart';
import 'package:kairo/core/constants/app_colors.dart';

class BodyHeatmapWidget extends StatelessWidget {
  final Map<String, int> muscleSets; // Muscle -> Sets count

  const BodyHeatmapWidget({
    super.key,
    required this.muscleSets,
  });

  Color _getMuscleColor(String muscle) {
    // Normalize muscle group naming
    final sets = muscleSets[muscle] ?? 0;
    if (sets == 0) return Colors.white10;
    if (sets <= 5) return AppColors.primary.withOpacity(0.3);
    if (sets <= 12) return AppColors.primary.withOpacity(0.65);
    return AppColors.primary; // Intense blue
  }

  Widget _buildMuscleBlock(String displayLabel, String dbKey) {
    final sets = muscleSets[dbKey] ?? 0;
    final color = _getMuscleColor(dbKey);
    final isTrained = sets > 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isTrained ? color : Colors.white12,
          width: isTrained ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            displayLabel,
            style: TextStyle(
              color: isTrained ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: isTrained ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isTrained ? color : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              "$sets sets",
              style: TextStyle(
                color: isTrained ? Colors.black : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            // FRONT BODY
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Text(
                      'FRONT PROFILE',
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMuscleBlock('Chest', 'Chest'),
                  const SizedBox(height: 8),
                  _buildMuscleBlock('Shoulders', 'Shoulders'),
                  const SizedBox(height: 8),
                  _buildMuscleBlock('Biceps', 'Biceps'),
                  const SizedBox(height: 8),
                  _buildMuscleBlock('Abs / Core', 'Core'),
                  const SizedBox(height: 8),
                  _buildMuscleBlock('Quads / Legs', 'Legs'),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // REAR BODY
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Text(
                      'REAR PROFILE',
                      style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMuscleBlock('Traps', 'Shoulders'), // mapped to shoulders
                  const SizedBox(height: 8),
                  _buildMuscleBlock('Lats / Back', 'Back'),
                  const SizedBox(height: 8),
                  _buildMuscleBlock('Triceps', 'Triceps'),
                  const SizedBox(height: 8),
                  _buildMuscleBlock('Glutes / Legs', 'Legs'),
                  const SizedBox(height: 8),
                  _buildMuscleBlock('Calves', 'Legs'), // mapped to legs
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Color Guide legend
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildLegendItem('0 sets', Colors.white10),
            _buildLegendItem('1–5 sets', AppColors.primary.withOpacity(0.3)),
            _buildLegendItem('6–12 sets', AppColors.primary.withOpacity(0.65)),
            _buildLegendItem('13+ sets', AppColors.primary),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: Colors.white24),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }
}
