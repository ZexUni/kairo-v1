import 'dart:convert';
import 'package:kairo/data/models/exercise_log.dart';

class WorkoutSession {
  final String id;
  final String userId;
  final DateTime startedAt;
  final DateTime completedAt;
  final List<ExerciseLog> exercises;
  final double totalVolumeKg;
  final int totalSets;
  final int totalReps;
  final int durationMinutes;
  final String notes;

  const WorkoutSession({
    required this.id,
    required this.userId,
    required this.startedAt,
    required this.completedAt,
    required this.exercises,
    required this.totalVolumeKg,
    required this.totalSets,
    required this.totalReps,
    required this.durationMinutes,
    required this.notes,
  });

  WorkoutSession copyWith({
    String? id,
    String? userId,
    DateTime? startedAt,
    DateTime? completedAt,
    List<ExerciseLog>? exercises,
    double? totalVolumeKg,
    int? totalSets,
    int? totalReps,
    int? durationMinutes,
    String? notes,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      exercises: exercises ?? this.exercises,
      totalVolumeKg: totalVolumeKg ?? this.totalVolumeKg,
      totalSets: totalSets ?? this.totalSets,
      totalReps: totalReps ?? this.totalReps,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt.toIso8601String(),
      'totalVolumeKg': totalVolumeKg,
      'totalSets': totalSets,
      'totalReps': totalReps,
      'durationMinutes': durationMinutes,
      'notes': notes,
    };
  }

  factory WorkoutSession.fromMap(Map<String, dynamic> map,
      {List<ExerciseLog>? exercises}) {
    return WorkoutSession(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      startedAt: map['startedAt'] != null
          ? DateTime.parse(map['startedAt'])
          : DateTime.now(),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : DateTime.now(),
      exercises: exercises ?? [],
      totalVolumeKg: (map['totalVolumeKg'] ?? 0.0).toDouble(),
      totalSets: map['totalSets'] ?? 0,
      totalReps: map['totalReps'] ?? 0,
      durationMinutes: map['durationMinutes'] ?? 0,
      notes: map['notes'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutSession.fromJson(String source) =>
      WorkoutSession.fromMap(json.decode(source));
}
