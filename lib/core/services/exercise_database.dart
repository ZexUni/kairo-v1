class ExerciseData {
  final String name;

  final String muscleGroup;

  final String equipment;

  final bool compound;

  final String difficulty;

  const ExerciseData({
    required this.name,

    required this.muscleGroup,

    required this.equipment,

    required this.compound,

    required this.difficulty,
  });
}

class ExerciseDatabase {
  static const List<ExerciseData> exercises = [
    // =========================
    // CHEST
    // =========================
    ExerciseData(
      name: 'Bench Press',
      muscleGroup: 'Chest',
      equipment: 'Full Gym',
      compound: true,
      difficulty: 'Intermediate',
    ),

    ExerciseData(
      name: 'Incline Dumbbell Press',
      muscleGroup: 'Chest',
      equipment: 'Dumbbells',
      compound: true,
      difficulty: 'Intermediate',
    ),

    ExerciseData(
      name: 'Push Ups',
      muscleGroup: 'Chest',
      equipment: 'Bodyweight',
      compound: true,
      difficulty: 'Beginner',
    ),

    ExerciseData(
      name: 'Chest Fly',
      muscleGroup: 'Chest',
      equipment: 'Full Gym',
      compound: false,
      difficulty: 'Beginner',
    ),

    // =========================
    // BACK
    // =========================
    ExerciseData(
      name: 'Pull Ups',
      muscleGroup: 'Back',
      equipment: 'Bodyweight',
      compound: true,
      difficulty: 'Intermediate',
    ),

    ExerciseData(
      name: 'Barbell Row',
      muscleGroup: 'Back',
      equipment: 'Full Gym',
      compound: true,
      difficulty: 'Intermediate',
    ),

    ExerciseData(
      name: 'One Arm Dumbbell Row',
      muscleGroup: 'Back',
      equipment: 'Dumbbells',
      compound: true,
      difficulty: 'Beginner',
    ),

    ExerciseData(
      name: 'Lat Pulldown',
      muscleGroup: 'Back',
      equipment: 'Full Gym',
      compound: true,
      difficulty: 'Beginner',
    ),

    // =========================
    // LEGS
    // =========================
    ExerciseData(
      name: 'Squat',
      muscleGroup: 'Legs',
      equipment: 'Full Gym',
      compound: true,
      difficulty: 'Intermediate',
    ),

    ExerciseData(
      name: 'Goblet Squat',
      muscleGroup: 'Legs',
      equipment: 'Dumbbells',
      compound: true,
      difficulty: 'Beginner',
    ),

    ExerciseData(
      name: 'Lunges',
      muscleGroup: 'Legs',
      equipment: 'Bodyweight',
      compound: true,
      difficulty: 'Beginner',
    ),

    ExerciseData(
      name: 'Romanian Deadlift',
      muscleGroup: 'Legs',
      equipment: 'Full Gym',
      compound: true,
      difficulty: 'Advanced',
    ),

    // =========================
    // SHOULDERS
    // =========================
    ExerciseData(
      name: 'Overhead Press',
      muscleGroup: 'Shoulders',
      equipment: 'Full Gym',
      compound: true,
      difficulty: 'Intermediate',
    ),

    ExerciseData(
      name: 'Dumbbell Shoulder Press',
      muscleGroup: 'Shoulders',
      equipment: 'Dumbbells',
      compound: true,
      difficulty: 'Beginner',
    ),

    ExerciseData(
      name: 'Lateral Raise',
      muscleGroup: 'Shoulders',
      equipment: 'Dumbbells',
      compound: false,
      difficulty: 'Beginner',
    ),

    ExerciseData(
      name: 'Pike Push Ups',
      muscleGroup: 'Shoulders',
      equipment: 'Bodyweight',
      compound: true,
      difficulty: 'Intermediate',
    ),

    // =========================
    // ARMS
    // =========================
    ExerciseData(
      name: 'Barbell Curl',
      muscleGroup: 'Arms',
      equipment: 'Full Gym',
      compound: false,
      difficulty: 'Beginner',
    ),

    ExerciseData(
      name: 'Hammer Curl',
      muscleGroup: 'Arms',
      equipment: 'Dumbbells',
      compound: false,
      difficulty: 'Beginner',
    ),

    ExerciseData(
      name: 'Tricep Pushdown',
      muscleGroup: 'Arms',
      equipment: 'Full Gym',
      compound: false,
      difficulty: 'Beginner',
    ),

    ExerciseData(
      name: 'Diamond Push Ups',
      muscleGroup: 'Arms',
      equipment: 'Bodyweight',
      compound: true,
      difficulty: 'Intermediate',
    ),

    // =========================
    // CORE
    // =========================
    ExerciseData(
      name: 'Plank',
      muscleGroup: 'Core',
      equipment: 'Bodyweight',
      compound: false,
      difficulty: 'Beginner',
    ),

    ExerciseData(
      name: 'Hanging Leg Raise',
      muscleGroup: 'Core',
      equipment: 'Full Gym',
      compound: false,
      difficulty: 'Intermediate',
    ),

    ExerciseData(
      name: 'Russian Twist',
      muscleGroup: 'Core',
      equipment: 'Bodyweight',
      compound: false,
      difficulty: 'Beginner',
    ),

    // =========================
    // FULL BODY
    // =========================
    ExerciseData(
      name: 'Deadlift',
      muscleGroup: 'Full Body',
      equipment: 'Full Gym',
      compound: true,
      difficulty: 'Advanced',
    ),

    ExerciseData(
      name: 'Burpees',
      muscleGroup: 'Full Body',
      equipment: 'Bodyweight',
      compound: true,
      difficulty: 'Intermediate',
    ),

    ExerciseData(
      name: 'Thrusters',
      muscleGroup: 'Full Body',
      equipment: 'Dumbbells',
      compound: true,
      difficulty: 'Advanced',
    ),
  ];
}
