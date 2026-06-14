class WorkoutSet {
  final int setNumber;

  final int reps;

  final double weight;

  final bool completed;

  WorkoutSet({
    required this.setNumber,

    required this.reps,

    required this.weight,

    this.completed = false,
  });

  double get volume {
    return reps * weight;
  }

  Map<String, dynamic> toMap() {
    return {
      'setNumber': setNumber,

      'reps': reps,

      'weight': weight,

      'completed': completed,
    };
  }

  factory WorkoutSet.fromMap(Map<String, dynamic> map) {
    return WorkoutSet(
      setNumber: map['setNumber'] ?? 0,

      reps: map['reps'] ?? 0,

      weight: (map['weight'] ?? 0).toDouble(),

      completed: map['completed'] ?? false,
    );
  }

  WorkoutSet copyWith({
    int? setNumber,

    int? reps,

    double? weight,

    bool? completed,
  }) {
    return WorkoutSet(
      setNumber: setNumber ?? this.setNumber,

      reps: reps ?? this.reps,

      weight: weight ?? this.weight,

      completed: completed ?? this.completed,
    );
  }
}
