class ExercisePerformance {
  final String exerciseName;

  final int sets;

  final int reps;

  final double weight;

  final double volume;

  final DateTime date;

  ExercisePerformance({
    required this.exerciseName,

    required this.sets,

    required this.reps,

    required this.weight,

    required this.volume,

    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'exerciseName': exerciseName,

      'sets': sets,

      'reps': reps,

      'weight': weight,

      'volume': volume,

      'date': date.toIso8601String(),
    };
  }

  factory ExercisePerformance.fromMap(Map<String, dynamic> map) {
    return ExercisePerformance(
      exerciseName: map['exerciseName'] ?? '',

      sets: map['sets'] ?? 0,

      reps: map['reps'] ?? 0,

      weight: (map['weight'] ?? 0).toDouble(),

      volume: (map['volume'] ?? 0).toDouble(),

      date: DateTime.parse(map['date']),
    );
  }

  ExercisePerformance copyWith({
    String? exerciseName,

    int? sets,

    int? reps,

    double? weight,

    double? volume,

    DateTime? date,
  }) {
    return ExercisePerformance(
      exerciseName: exerciseName ?? this.exerciseName,

      sets: sets ?? this.sets,

      reps: reps ?? this.reps,

      weight: weight ?? this.weight,

      volume: volume ?? this.volume,

      date: date ?? this.date,
    );
  }
}
