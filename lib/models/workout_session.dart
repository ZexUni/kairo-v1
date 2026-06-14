class WorkoutSession {
  final String sessionName;

  final DateTime date;

  final List<String> exercises;

  final double totalVolume;

  final int completedExercises;

  final int totalExercises;

  final int durationMinutes;

  final bool completed;

  WorkoutSession({
    required this.sessionName,

    required this.date,

    required this.exercises,

    required this.totalVolume,

    required this.completedExercises,

    required this.totalExercises,

    required this.durationMinutes,

    required this.completed,
  });

  double get completionRate {
    if (totalExercises == 0) {
      return 0;
    }

    return completedExercises / totalExercises;
  }

  Map<String, dynamic> toMap() {
    return {
      'sessionName': sessionName,

      'date': date.toIso8601String(),

      'exercises': exercises,

      'totalVolume': totalVolume,

      'completedExercises': completedExercises,

      'totalExercises': totalExercises,

      'durationMinutes': durationMinutes,

      'completed': completed,
    };
  }

  factory WorkoutSession.fromMap(Map<String, dynamic> map) {
    return WorkoutSession(
      sessionName: map['sessionName'] ?? '',

      date: DateTime.parse(map['date']),

      exercises: List<String>.from(map['exercises'] ?? []),

      totalVolume: (map['totalVolume'] ?? 0).toDouble(),

      completedExercises: map['completedExercises'] ?? 0,

      totalExercises: map['totalExercises'] ?? 0,

      durationMinutes: map['durationMinutes'] ?? 0,

      completed: map['completed'] ?? false,
    );
  }

  WorkoutSession copyWith({
    String? sessionName,

    DateTime? date,

    List<String>? exercises,

    double? totalVolume,

    int? completedExercises,

    int? totalExercises,

    int? durationMinutes,

    bool? completed,
  }) {
    return WorkoutSession(
      sessionName: sessionName ?? this.sessionName,

      date: date ?? this.date,

      exercises: exercises ?? this.exercises,

      totalVolume: totalVolume ?? this.totalVolume,

      completedExercises: completedExercises ?? this.completedExercises,

      totalExercises: totalExercises ?? this.totalExercises,

      durationMinutes: durationMinutes ?? this.durationMinutes,

      completed: completed ?? this.completed,
    );
  }
}
