import 'dart:convert';

class SetLog {
  final String id;
  final String exerciseLogId;
  final int setNumber;
  final int reps;
  final double weightKg;
  final double rpe; // 0-10
  final bool isCompleted;
  final DateTime completedAt;

  const SetLog({
    required this.id,
    required this.exerciseLogId,
    required this.setNumber,
    required this.reps,
    required this.weightKg,
    required this.rpe,
    required this.isCompleted,
    required this.completedAt,
  });

  SetLog copyWith({
    String? id,
    String? exerciseLogId,
    int? setNumber,
    int? reps,
    double? weightKg,
    double? rpe,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return SetLog(
      id: id ?? this.id,
      exerciseLogId: exerciseLogId ?? this.exerciseLogId,
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      weightKg: weightKg ?? this.weightKg,
      rpe: rpe ?? this.rpe,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseLogId': exerciseLogId,
      'setNumber': setNumber,
      'reps': reps,
      'weightKg': weightKg,
      'rpe': rpe,
      'isCompleted': isCompleted ? 1 : 0,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory SetLog.fromMap(Map<String, dynamic> map) {
    return SetLog(
      id: map['id'] ?? '',
      exerciseLogId: map['exerciseLogId'] ?? '',
      setNumber: map['setNumber'] ?? 1,
      reps: map['reps'] ?? 0,
      weightKg: (map['weightKg'] ?? 0.0).toDouble(),
      rpe: (map['rpe'] ?? 0.0).toDouble(),
      isCompleted: (map['isCompleted'] == 1 || map['isCompleted'] == true),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SetLog.fromJson(String source) => SetLog.fromMap(json.decode(source));
}
