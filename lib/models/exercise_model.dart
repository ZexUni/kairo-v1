class Exercise {
  final String name;

  final int sets;

  final int reps;

  final double weight;

  final bool completed;

  Exercise({
    required this.name,

    required this.sets,

    required this.reps,

    required this.weight,

    this.completed = false,
  });

  Exercise copyWith({
    String? name,

    int? sets,

    int? reps,

    double? weight,

    bool? completed,
  }) {
    return Exercise(
      name: name ?? this.name,

      sets: sets ?? this.sets,

      reps: reps ?? this.reps,

      weight: weight ?? this.weight,

      completed: completed ?? this.completed,
    );
  }

  double get volume {
    return sets * reps * weight;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,

      'sets': sets,

      'reps': reps,

      'weight': weight,

      'completed': completed,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'] ?? '',

      sets: map['sets'] ?? 0,

      reps: map['reps'] ?? 0,

      weight: (map['weight'] ?? 0).toDouble(),

      completed: map['completed'] ?? false,
    );
  }
}
