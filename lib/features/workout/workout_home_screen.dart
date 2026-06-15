import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kairo/services/auth_service.dart';
import 'package:kairo/services/physiology_engine.dart';
import 'package:kairo/services/workout_engine.dart';
import 'package:kairo/data/repositories/user_repository.dart';
import 'package:kairo/data/repositories/workout_repository.dart';
import 'package:kairo/data/models/user_profile.dart';
import 'package:kairo/data/models/body_measurements.dart';
import 'package:kairo/data/models/lifestyle_assessment.dart';
import 'package:kairo/data/models/performance_assessment.dart';
import 'package:kairo/data/models/recovery_checkin.dart';
import 'package:kairo/data/models/workout_session.dart';
import 'package:kairo/core/constants/app_colors.dart';
import 'package:kairo/widgets/bottom_nav_bar.dart';

class WorkoutHomeScreen extends StatefulWidget {
  const WorkoutHomeScreen({super.key});

  @override
  State<WorkoutHomeScreen> createState() => _WorkoutHomeScreenState();
}

class _WorkoutHomeScreenState extends State<WorkoutHomeScreen> {
  bool _loading = true;
  List<WorkoutSession> _history = [];
  WorkoutPlan? _todayPlan;
  UserProfile? _profile;
  BodyMeasurements? _measurements;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final userId = auth.currentUser?.uid ?? 'local_user';

      final workoutRepo = WorkoutRepository();
      final userRepo = UserRepository();

      // Get history for last 30 days
      final end = DateTime.now();
      final start = end.subtract(const Duration(days: 30));
      _history = await workoutRepo.getSessionsForPeriod(userId, start, end);

      _profile = await userRepo.getProfile(userId);
      _measurements = await userRepo.getLatestMeasurements(userId);
      final lifestyle = await userRepo.getLatestLifestyle(userId);
      final performance = await userRepo.getLatestPerformance(userId);
      final latestCheckin = await userRepo.getLatestSnapshot(userId); // fallback check

      if (_profile != null && _measurements != null && lifestyle != null && performance != null) {
        final snap = PhysiologyEngine().computeSnapshot(
          profile: _profile!,
          measurements: _measurements!,
          lifestyle: lifestyle,
          performance: performance,
          latestCheckin: null,
        );
        _todayPlan = WorkoutEngine().generatePlan(snap, _profile!, _measurements!);
      }
    } catch (e) {
      debugPrint("Error loading workout home: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildSessionCard(WorkoutSession session) {
    return Card(
      color: AppColors.card,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  session.notes.isNotEmpty ? session.notes : "Custom Session",
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  DateFormat('MMM d, h:mm a').format(session.completedAt),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMiniStat('Duration', '${session.durationMinutes}m'),
                _buildMiniStat('Volume', '${session.totalVolumeKg.round()}kg'),
                _buildMiniStat('Sets', '${session.totalSets}'),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.white10),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: session.exercises.map((e) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  e.exerciseName,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(val, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Workout Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            onPressed: _loadData,
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(24.0),
                physics: const BouncingScrollPhysics(),
                children: [
                  // BUTTONS ROW
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            context.push('/workout/active').then((_) => _loadData());
                          },
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.play_circle_outline, color: AppColors.primary, size: 36),
                                SizedBox(height: 8),
                                Text(
                                  'Start Empty',
                                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (_todayPlan != null) {
                              context.push('/workout/active?loadPlan=true').then((_) => _loadData());
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('No recommended plan today. Start empty!')),
                              );
                            }
                          },
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.fitness_center, color: Colors.black, size: 36),
                                SizedBox(height: 8),
                                Text(
                                  'Use Today\'s Plan',
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // TODAY'S RECOMMENDATION PREVIEW
                  if (_todayPlan != null) ...[
                    Card(
                      color: AppColors.card,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Today's Plan Preview",
                                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    _todayPlan!.splitName,
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ..._todayPlan!.days.take(1).map((day) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: day.exercises.take(3).map((e) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Text(
                                          "• ${e.name} (${e.muscleGroup})",
                                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                        ),
                                      )).toList(),
                                )),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // RECENT WORKOUTS
                  const Text(
                    'RECENT WORKOUTS (30 DAYS)',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_history.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Center(
                        child: Text(
                          'No workouts logged recently. Start training!',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    ..._history.map((session) => _buildSessionCard(session)),
                ],
              ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
