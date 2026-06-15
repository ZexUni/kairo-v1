import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:kairo/services/auth_service.dart';
import 'package:kairo/services/physiology_engine.dart';
import 'package:kairo/services/workout_engine.dart';
import 'package:kairo/data/repositories/user_repository.dart';
import 'package:kairo/data/repositories/workout_repository.dart';
import 'package:kairo/data/repositories/recovery_repository.dart';
import 'package:kairo/data/database/exercise_database.dart';
import 'package:kairo/data/models/workout_session.dart';
import 'package:kairo/data/models/exercise_log.dart';
import 'package:kairo/data/models/set_log.dart';
import 'package:kairo/core/constants/app_colors.dart';
import 'package:kairo/widgets/workout_summary_card.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  final bool loadPlan;

  const ActiveWorkoutScreen({
    super.key,
    this.loadPlan = false,
  });

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  final _uuid = const Uuid();
  late DateTime _startedAt;
  int _secondsElapsed = 0;
  Timer? _timer;
  
  final List<ExerciseLog> _exercises = [];
  final Map<String, List<SetLog>> _exerciseSets = {}; // exerciseLogId -> sets
  final _notesController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _startedAt = DateTime.now();
    _startTimer();
    if (widget.loadPlan) {
      _loadRecommendedPlan();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  Future<void> _loadRecommendedPlan() async {
    setState(() => _loading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final userId = auth.currentUser?.uid ?? 'local_user';
      
      final userRepo = UserRepository();
      final profile = await userRepo.getProfile(userId);
      final measurements = await userRepo.getLatestMeasurements(userId);
      final lifestyle = await userRepo.getLatestLifestyle(userId);
      final performance = await userRepo.getLatestPerformance(userId);

      if (profile != null && measurements != null && lifestyle != null && performance != null) {
        final snap = PhysiologyEngine().computeSnapshot(
          profile: profile,
          measurements: measurements,
          lifestyle: lifestyle,
          performance: performance,
          latestCheckin: null,
        );
        final plan = WorkoutEngine().generatePlan(snap, profile, measurements);
        
        final dayPlan = plan.days.first;
        final sessionId = _uuid.v4();

        for (var ex in dayPlan.exercises) {
          final exerciseLogId = _uuid.v4();
          final log = ExerciseLog(
            id: exerciseLogId,
            sessionId: sessionId,
            exerciseName: ex.name,
            muscleGroup: ex.muscleGroup,
            sets: [],
            notes: "",
          );
          _exercises.add(log);

          final List<SetLog> sets = [];
          for (int s = 1; s <= dayPlan.sets; s++) {
            sets.add(SetLog(
              id: _uuid.v4(),
              exerciseLogId: exerciseLogId,
              setNumber: s,
              reps: dayPlan.reps,
              weightKg: 20.0, // default placeholder starting weight
              rpe: 8.0,
              isCompleted: false,
              completedAt: DateTime.now(),
            ));
          }
          _exerciseSets[exerciseLogId] = sets;
        }
      }
    } catch (e) {
      debugPrint("Error loading plan: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _addExercise() async {
    final selected = await context.push('/workout/pick');
    if (selected is ExerciseModel) {
      setState(() {
        final exerciseLogId = _uuid.v4();
        final log = ExerciseLog(
          id: exerciseLogId,
          sessionId: "", // populated at save
          exerciseName: selected.name,
          muscleGroup: selected.muscleGroup,
          sets: [],
          notes: "",
        );
        _exercises.add(log);

        // Add 1 default set
        _exerciseSets[exerciseLogId] = [
          SetLog(
            id: _uuid.v4(),
            exerciseLogId: exerciseLogId,
            setNumber: 1,
            reps: 10,
            weightKg: 20.0,
            rpe: 8.0,
            isCompleted: false,
            completedAt: DateTime.now(),
          )
        ];
      });
    }
  }

  void _addSet(String exerciseLogId) {
    setState(() {
      final currentSets = _exerciseSets[exerciseLogId] ?? [];
      final lastSet = currentSets.isNotEmpty ? currentSets.last : null;
      final newSetNumber = currentSets.length + 1;
      
      currentSets.add(SetLog(
        id: _uuid.v4(),
        exerciseLogId: exerciseLogId,
        setNumber: newSetNumber,
        reps: lastSet?.reps ?? 10,
        weightKg: lastSet?.weightKg ?? 20.0,
        rpe: lastSet?.rpe ?? 8.0,
        isCompleted: false,
        completedAt: DateTime.now(),
      ));
      _exerciseSets[exerciseLogId] = currentSets;
    });
  }

  void _removeSet(String exerciseLogId, int index) {
    setState(() {
      final sets = _exerciseSets[exerciseLogId] ?? [];
      if (sets.length > index) {
        sets.removeAt(index);
        // Recalculate set numbers
        for (int i = 0; i < sets.length; i++) {
          sets[i] = sets[i].copyWith(setNumber: i + 1);
        }
        _exerciseSets[exerciseLogId] = sets;
      }
    });
  }

  Future<void> _finishWorkout() async {
    final completedExercises = <ExerciseLog>[];
    double totalVolume = 0.0;
    int totalSets = 0;
    int totalReps = 0;

    final sessionId = _uuid.v4();

    for (var ex in _exercises) {
      final sets = _exerciseSets[ex.id] ?? [];
      final completedSets = sets.where((s) => s.isCompleted).toList();
      
      if (completedSets.isNotEmpty) {
        final savedExercise = ex.copyWith(
          sessionId: sessionId,
          sets: completedSets,
        );
        completedExercises.add(savedExercise);

        for (var set in completedSets) {
          totalVolume += set.weightKg * set.reps;
          totalSets++;
          totalReps += set.reps;
        }
      }
    }

    if (completedExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete at least 1 set to save.')),
      );
      return;
    }

    _timer?.cancel();

    final auth = Provider.of<AuthService>(context, listen: false);
    final userId = auth.currentUser?.uid ?? 'local_user';

    final session = WorkoutSession(
      id: sessionId,
      userId: userId,
      startedAt: _startedAt,
      completedAt: DateTime.now(),
      exercises: completedExercises,
      totalVolumeKg: totalVolume,
      totalSets: totalSets,
      totalReps: totalReps,
      durationMinutes: (_secondsElapsed ~/ 60).clamp(1, 480),
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : "Workout Plan Completed",
    );

    // Save to Database
    final workoutRepo = WorkoutRepository();
    await workoutRepo.saveSession(session);

    // Recompute Physiology Snapshot
    final userRepo = UserRepository();
    final profile = await userRepo.getProfile(userId);
    final measurements = await userRepo.getLatestMeasurements(userId);
    final lifestyle = await userRepo.getLatestLifestyle(userId);
    final performance = await userRepo.getLatestPerformance(userId);
    final latestCheckin = await RecoveryRepository().getLatestCheckin(userId);

    if (profile != null && measurements != null && lifestyle != null && performance != null) {
      final snap = PhysiologyEngine().computeSnapshot(
        profile: profile,
        measurements: measurements,
        lifestyle: lifestyle,
        performance: performance,
        latestCheckin: latestCheckin,
      );
      await userRepo.saveSnapshot(snap);
    }

    // Trigger update notifier
    PhysiologyEngine().triggerUpdate();

    if (!mounted) return;

    // Show summary card dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WorkoutSummaryCard(
        session: session,
        onClose: () {
          context.pop(); // dismiss dialog
          context.pop(); // go back to workout list
        },
      ),
    );
  }

  Widget _buildSetRow(String exerciseLogId, int index, SetLog set) {
    final repsController = TextEditingController(text: set.reps.toString());
    final weightController = TextEditingController(text: set.weightKg.toString());
    final rpeController = TextEditingController(text: set.rpe.toString());

    return Dismissible(
      key: Key(set.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppColors.danger,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _removeSet(exerciseLogId, index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
        child: Row(
          children: [
            // Set Number
            Container(
              width: 32,
              alignment: Alignment.center,
              child: Text(
                "${index + 1}",
                style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),

            // Weight Field
            Expanded(
              child: TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  hintText: 'kg',
                ),
                onChanged: (val) {
                  final parsed = double.tryParse(val) ?? 0.0;
                  _exerciseSets[exerciseLogId]![index] = set.copyWith(weightKg: parsed);
                },
              ),
            ),
            const SizedBox(width: 8),

            // Reps Field
            Expanded(
              child: TextField(
                controller: repsController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  hintText: 'reps',
                ),
                onChanged: (val) {
                  final parsed = int.tryParse(val) ?? 0;
                  _exerciseSets[exerciseLogId]![index] = set.copyWith(reps: parsed);
                },
              ),
            ),
            const SizedBox(width: 8),

            // RPE Field
            Expanded(
              child: TextField(
                controller: rpeController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  hintText: 'RPE',
                ),
                onChanged: (val) {
                  final parsed = double.tryParse(val) ?? 0.0;
                  _exerciseSets[exerciseLogId]![index] = set.copyWith(rpe: parsed);
                },
              ),
            ),
            const SizedBox(width: 12),

            // Checkbox
            GestureDetector(
              onTap: () {
                setState(() {
                  final currentVal = _exerciseSets[exerciseLogId]![index].isCompleted;
                  _exerciseSets[exerciseLogId]![index] = set.copyWith(
                    isCompleted: !currentVal,
                    completedAt: DateTime.now(),
                  );
                });
              },
              child: Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                  color: set.isCompleted ? AppColors.success : Colors.white10,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: set.isCompleted ? AppColors.success : Colors.white24,
                    width: 1.5,
                  ),
                ),
                child: set.isCompleted
                    ? const Icon(Icons.check, color: Colors.black, size: 18)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(ExerciseLog log) {
    final sets = _exerciseSets[log.id] ?? [];

    return Card(
      color: AppColors.card,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log.exerciseName,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        log.muscleGroup.toUpperCase(),
                        style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54, size: 18),
                  onPressed: () {
                    setState(() {
                      _exercises.removeWhere((e) => e.id == log.id);
                      _exerciseSets.remove(log.id);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Set Headers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: const [
                  SizedBox(width: 32, child: Text('SET', style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold))),
                  SizedBox(width: 8),
                  Expanded(child: Text('WEIGHT (KG)', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold))),
                  SizedBox(width: 8),
                  Expanded(child: Text('REPS', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold))),
                  SizedBox(width: 8),
                  Expanded(child: Text('RPE', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold))),
                  SizedBox(width: 12),
                  SizedBox(width: 28, child: Icon(Icons.check, color: AppColors.textSecondary, size: 14)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Sets Rows
            ...sets.asMap().entries.map((entry) => _buildSetRow(log.id, entry.key, entry.value)),
            const SizedBox(height: 12),
            // Add Set button
            OutlinedButton.icon(
              onPressed: () => _addSet(log.id),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.add, size: 16, color: AppColors.primary),
              label: const Text('Add Set', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Active Workout'),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 28),
          onPressed: () {
            // Minimize or discard warning
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Discard Workout?'),
                content: const Text('Are you sure you want to discard this active workout session? all progress will be lost.'),
                actions: [
                  TextButton(onPressed: () => context.pop(), child: const Text('CANCEL')),
                  TextButton(
                    onPressed: () {
                      context.pop(); // dismiss dialog
                      context.pop(); // go back
                    },
                    child: const Text('DISCARD', style: TextStyle(color: AppColors.danger)),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: _finishWorkout,
            child: const Text(
              'FINISH',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Timer banner
                  Container(
                    color: AppColors.card,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined, color: AppColors.primary, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              _formatDuration(_secondsElapsed),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Courier',
                              ),
                            ),
                          ],
                        ),
                        const Text('Active Logging', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      ],
                    ),
                  ),

                  // Session Notes Input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: TextField(
                      controller: _notesController,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Workout Notes / Title (e.g. Legs A)',
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),

                  // Active Exercises List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _exercises.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _exercises.length) {
                          // Add exercise button
                          return Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 40.0),
                            child: OutlinedButton.icon(
                              onPressed: _addExercise,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.primary, width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                foregroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              icon: const Icon(Icons.add),
                              label: const Text('ADD EXERCISE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            ),
                          );
                        }
                        return _buildExerciseCard(_exercises[index]);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
