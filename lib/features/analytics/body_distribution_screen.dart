import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:kairo/services/auth_service.dart';
import 'package:kairo/data/repositories/workout_repository.dart';
import 'package:kairo/widgets/body_heatmap_widget.dart';
import 'package:kairo/core/constants/app_colors.dart';

class BodyDistributionScreen extends StatefulWidget {
  const BodyDistributionScreen({super.key});

  @override
  State<BodyDistributionScreen> createState() => _BodyDistributionScreenState();
}

class _BodyDistributionScreenState extends State<BodyDistributionScreen> {
  bool _loading = true;
  DateTime _currentWeekStart = DateTime.now();

  Map<String, int> _weeklySets = {
    'Chest': 0,
    'Back': 0,
    'Shoulders': 0,
    'Biceps': 0,
    'Triceps': 0,
    'Legs': 0,
    'Core': 0,
  };

  @override
  void initState() {
    super.initState();
    // Start of current week (Sunday)
    final now = DateTime.now();
    _currentWeekStart = now.subtract(Duration(days: now.weekday % 7));
    _loadWeeklyDistribution();
  }

  Future<void> _loadWeeklyDistribution() async {
    setState(() => _loading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final userId = auth.currentUser?.uid ?? 'local_user';

      final workoutRepo = WorkoutRepository();

      // Start date is Sunday 00:00:00, end date is Saturday 23:59:59
      final start = DateTime(_currentWeekStart.year, _currentWeekStart.month, _currentWeekStart.day);
      final end = start.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

      final sessions = await workoutRepo.getSessionsForPeriod(userId, start, end);

      // Reset sets
      _weeklySets = {
        'Chest': 0,
        'Back': 0,
        'Shoulders': 0,
        'Biceps': 0,
        'Triceps': 0,
        'Legs': 0,
        'Core': 0,
      };

      for (var s in sessions) {
        for (var ex in s.exercises) {
          final group = _normalizeMuscleGroup(ex.muscleGroup);
          if (_weeklySets.containsKey(group)) {
            final completed = ex.sets.where((set) => set.isCompleted).length;
            _weeklySets[group] = _weeklySets[group]! + completed;
          }
        }
      }
    } catch (e) {
      debugPrint("Error loading weekly distribution: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _normalizeMuscleGroup(String muscle) {
    muscle = muscle.trim().toLowerCase();
    if (muscle == 'biceps') return 'Biceps';
    if (muscle == 'triceps') return 'Triceps';
    if (muscle == 'arms') return 'Biceps';
    if (muscle == 'chest') return 'Chest';
    if (muscle == 'back' || muscle == 'lats') return 'Back';
    if (muscle == 'shoulders' || muscle == 'traps') return 'Shoulders';
    if (muscle == 'legs' || muscle == 'quads' || muscle == 'calves' || muscle == 'hamstrings' || muscle == 'glutes') return 'Legs';
    if (muscle == 'core' || muscle == 'abs') return 'Core';
    return 'Chest';
  }

  void _changeWeek(bool next) {
    setState(() {
      if (next) {
        _currentWeekStart = _currentWeekStart.add(const Duration(days: 7));
      } else {
        _currentWeekStart = _currentWeekStart.subtract(const Duration(days: 7));
      }
      _loadWeeklyDistribution();
    });
  }

  String _formatWeekRange() {
    final end = _currentWeekStart.add(const Duration(days: 6));
    final formatter = DateFormat('MMM d');
    return "${formatter.format(_currentWeekStart)} - ${formatter.format(end)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Anatomical Workload'),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(24.0),
                physics: const BouncingScrollPhysics(),
                children: [
                  // Week Selector Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary, size: 18),
                        onPressed: () => _changeWeek(false),
                      ),
                      Text(
                        _formatWeekRange(),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, color: AppColors.textPrimary, size: 18),
                        onPressed: () => _changeWeek(true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Heatmap figures
                  Card(
                    color: AppColors.card,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: BodyHeatmapWidget(muscleSets: _weeklySets),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Detail list below
                  const Text(
                    'WEEKLY SETS BREAKDOWN',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._weeklySets.entries.map((entry) => Card(
                        color: AppColors.card,
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                          title: Text(entry.key, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: entry.value > 0 ? AppColors.primary.withOpacity(0.1) : Colors.white10,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${entry.value} sets",
                              style: TextStyle(
                                color: entry.value > 0 ? AppColors.primary : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
      ),
    );
  }
}
