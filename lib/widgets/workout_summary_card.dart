import 'package:flutter/material.dart';
import 'package:kairo/data/models/workout_session.dart';
import 'package:kairo/core/constants/app_colors.dart';

class WorkoutSummaryCard extends StatelessWidget {
  final WorkoutSession session;
  final VoidCallback onClose;

  const WorkoutSummaryCard({
    super.key,
    required this.session,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    // Group muscles and calculate sets count for breakdown
    final Map<String, int> muscleSetCount = {};
    int totalCompletedSets = 0;
    for (var exercise in session.exercises) {
      final completed = exercise.sets.where((s) => s.isCompleted).length;
      if (completed > 0) {
        muscleSetCount[exercise.muscleGroup] = (muscleSetCount[exercise.muscleGroup] ?? 0) + completed;
        totalCompletedSets += completed;
      }
    }

    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emoji_events_outlined, color: AppColors.success, size: 36),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Workout Completed!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Great effort! Here is your performance summary.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white12),
              const SizedBox(height: 16),

              // STATS ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Duration', '${session.durationMinutes}m'),
                  _buildStatItem('Volume', '${session.totalVolumeKg.round()}kg'),
                  _buildStatItem('Sets', '${session.totalSets}'),
                  _buildStatItem('Reps', '${session.totalReps}'),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white12),
              const SizedBox(height: 16),

              // MUSCLE BREAKDOWN
              const Text(
                'Muscles Trained',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 12),
              if (muscleSetCount.isEmpty)
                const Text('No sets completed', style: TextStyle(color: AppColors.textSecondary, fontSize: 13))
              else
                ...muscleSetCount.entries.map((entry) {
                  final percent = totalCompletedSets > 0 ? entry.value / totalCompletedSets : 0.0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.key, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                            Text('${entry.value} sets (${(percent * 100).round()}%)',
                                style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percent,
                            minHeight: 5,
                            backgroundColor: Colors.white12,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: onClose,
                  child: const Text('SAVE & CLOSE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String val) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
