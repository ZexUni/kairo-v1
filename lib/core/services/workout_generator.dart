import 'package:kairo/models/onboarding_data.dart';

import 'package:kairo/core/services/exercise_database.dart';

import 'package:kairo/core/services/exercise_selector.dart';

class WorkoutGenerator {
  static List<String> generateWorkout(OnboardingData data) {
    // =========================
    // ENVIRONMENT FILTER
    // =========================

    List<ExerciseData> availableExercises =
        ExerciseSelector.exercisesForEnvironment(data.trainingEnvironment);

    // =========================
    // EXPERIENCE FILTER
    // =========================

    if (data.experienceLevel == 'Beginner') {
      availableExercises = ExerciseSelector.filterByDifficulty(
        exercises: availableExercises,

        difficulty: 'Beginner',
      );
    }

    // =========================
    // GOAL-BASED WORKOUT
    // =========================

    List<String> workout = [];

    // BULK

    if (data.physiqueGoal == 'Bulk') {
      workout.addAll(
        ExerciseSelector.compoundExercises(
          availableExercises,
        ).take(6).map((exercise) => exercise.name),
      );
    }
    // SLIM
    else if (data.physiqueGoal == 'Slim') {
      workout.addAll(
        availableExercises
            .where((exercise) => exercise.muscleGroup != 'Arms')
            .take(8)
            .map((exercise) => exercise.name),
      );
    }
    // BALANCED
    else {
      workout.addAll(
        availableExercises.take(7).map((exercise) => exercise.name),
      );
    }

    // =========================
    // FALLBACK
    // =========================

    if (workout.isEmpty) {
      workout = ['Push Ups', 'Squats', 'Plank'];
    }

    return workout;
  }

  static Map<String, int> recommendedSetsReps(String goal) {
    // BULK

    if (goal == 'Bulk') {
      return {'sets': 4, 'reps': 8};
    }

    // SLIM

    if (goal == 'Slim') {
      return {'sets': 3, 'reps': 15};
    }

    // BALANCED

    return {'sets': 4, 'reps': 12};
  }

  static String workoutFocus(String goal) {
    if (goal == 'Bulk') {
      return 'Hypertrophy and progressive overload.';
    }

    if (goal == 'Slim') {
      return 'Conditioning and caloric expenditure.';
    }

    return 'Balanced athletic development.';
  }

  static int estimatedWorkoutTime(String goal) {
    if (goal == 'Bulk') {
      return 75;
    }

    if (goal == 'Slim') {
      return 50;
    }

    return 60;
  }
}
