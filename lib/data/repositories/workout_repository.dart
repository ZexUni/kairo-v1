import 'package:uuid/uuid.dart';
import 'package:kairo/services/database_service.dart';
import 'package:kairo/data/models/workout_session.dart';
import 'package:kairo/data/models/exercise_log.dart';
import 'package:kairo/data/models/set_log.dart';

class WorkoutRepository {
  final DatabaseService _db = DatabaseService();
  final _uuid = const Uuid();

  Future<void> saveSession(WorkoutSession s) async {
    // 1. Insert session
    await _db.insert('workout_sessions', s.toMap());

    // 2. Insert exercises and sets
    for (var exercise in s.exercises) {
      final Map<String, dynamic> exerciseMap = exercise.toMap();
      exerciseMap['userId'] = s.userId; // attach userId
      await _db.insert('exercise_logs', exerciseMap);

      for (var set in exercise.sets) {
        final Map<String, dynamic> setMap = set.toMap();
        setMap['userId'] = s.userId; // attach userId
        await _db.insert('set_logs', setMap);
      }
    }
  }

  Future<List<WorkoutSession>> getSessionsForPeriod(String userId, DateTime start, DateTime end) async {
    // Query sessions
    final sessionList = await _db.query(
      'workout_sessions',
      where: 'userId = ? AND startedAt >= ? AND startedAt <= ?',
      whereArgs: [userId, start.toIso8601String(), end.toIso8601String()],
      orderBy: 'startedAt DESC',
    );

    List<WorkoutSession> sessions = [];

    for (var sessionRow in sessionList) {
      final sessionId = sessionRow['id'] as String;

      // Query exercise logs
      final exerciseList = await _db.query(
        'exercise_logs',
        where: 'sessionId = ?',
        whereArgs: [sessionId],
      );

      List<ExerciseLog> exercises = [];

      for (var exerciseRow in exerciseList) {
        final exerciseLogId = exerciseRow['id'] as String;

        // Query set logs
        final setList = await _db.query(
          'set_logs',
          where: 'exerciseLogId = ?',
          whereArgs: [exerciseLogId],
          orderBy: 'setNumber ASC',
        );

        List<SetLog> sets = setList.map((row) => SetLog.fromMap(row)).toList();
        exercises.add(ExerciseLog.fromMap(exerciseRow, sets: sets));
      }

      sessions.add(WorkoutSession.fromMap(sessionRow, exercises: exercises));
    }

    return sessions;
  }

  Future<Map<String, int>> getWeeklySetsPerMuscle(String userId) async {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    // Get sessions in last 7 days
    final sessions = await getSessionsForPeriod(userId, sevenDaysAgo, now);

    final Map<String, int> weeklySets = {
      'Chest': 0,
      'Back': 0,
      'Shoulders': 0,
      'Biceps': 0,
      'Triceps': 0,
      'Legs': 0,
      'Core': 0,
    };

    for (var session in sessions) {
      for (var exercise in session.exercises) {
        final muscle = _normalizeMuscleGroup(exercise.muscleGroup);
        if (weeklySets.containsKey(muscle)) {
          // Add completed sets count
          final completedSets = exercise.sets.where((s) => s.isCompleted).length;
          weeklySets[muscle] = weeklySets[muscle]! + completedSets;
        }
      }
    }

    return weeklySets;
  }

  String _normalizeMuscleGroup(String muscle) {
    muscle = muscle.trim();
    if (muscle.toLowerCase() == 'arms') {
      return 'Biceps'; // fallback
    }
    // Capitalize first letter
    if (muscle.isEmpty) return 'Chest';
    return muscle[0].toUpperCase() + muscle.substring(1).toLowerCase();
  }
}
