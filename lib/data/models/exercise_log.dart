import 'dart:convert';
import 'package:kairo/data/models/set_log.dart';

class ExerciseLog {
  final String id;
  final String sessionId;
  final String exerciseName;
  final String muscleGroup;
  final List<SetLog> sets;
  final String notes;

  const ExerciseLog({
    required this.id,
    required this.sessionId,
    required this.exerciseName,
    required this.muscleGroup,
    required this.sets,
    required this.notes,
  });

  ExerciseLog copyWith({
    String? id,
    String? sessionId,
    String? exerciseName,
    String? muscleGroup,
    List<SetLog>? sets,
    String? notes,
  }) {
    return ExerciseLog(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseName: exerciseName ?? this.exerciseName,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      sets: sets ?? this.sets,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sessionId': sessionId,
      'exerciseName': exerciseName,
      'muscleGroup': muscleGroup,
      'notes': notes,
    };
  }

  factory ExerciseLog.fromMap(Map<String, dynamic> map, {List<SetLog>? sets}) {
    return ExerciseLog(
      id: map['id'] ?? '',
      sessionId: map['sessionId'] ?? '',
      exerciseName: map['exerciseName'] ?? '',
      muscleGroup: map['muscleGroup'] ?? '',
      sets: sets ?? [],
      notes: map['notes'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseLog.fromJson(String source) =>
      ExerciseLog.fromMap(json.decode(source));
}
