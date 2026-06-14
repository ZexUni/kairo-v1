import 'package:kairo/core/services/exercise_database.dart';

class ExerciseSelector {
  static List<ExerciseData> exercisesForEnvironment(String environment) {
    return ExerciseDatabase.exercises.where((exercise) {
      // Full Gym

      if (environment == 'Full Gym') {
        return true;
      }

      // Dumbbells Only

      if (environment == 'Dumbbells Only') {
        return exercise.equipment == 'Dumbbells';
      }

      // Bodyweight Only

      if (environment == 'Bodyweight Only') {
        return exercise.equipment == 'Bodyweight';
      }

      return false;
    }).toList();
  }

  static List<ExerciseData> filterByMuscleGroup({
    required List<ExerciseData> exercises,

    required String muscleGroup,
  }) {
    return exercises
        .where((exercise) => exercise.muscleGroup == muscleGroup)
        .toList();
  }

  static List<ExerciseData> filterByDifficulty({
    required List<ExerciseData> exercises,

    required String difficulty,
  }) {
    return exercises
        .where((exercise) => exercise.difficulty == difficulty)
        .toList();
  }

  static List<ExerciseData> compoundExercises(List<ExerciseData> exercises) {
    return exercises.where((exercise) => exercise.compound).toList();
  }

  static List<ExerciseData> isolationExercises(List<ExerciseData> exercises) {
    return exercises.where((exercise) => !exercise.compound).toList();
  }
}
