import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kairo/data/models/user_profile.dart';
import 'package:kairo/data/models/body_measurements.dart';
import 'package:kairo/data/models/physiology_snapshot.dart';
import 'package:kairo/data/database/exercise_database.dart';
import 'package:kairo/core/constants/archetype_constants.dart';

class WorkoutDayPlan {
  final String dayName;
  final List<ExerciseModel> exercises;
  final int sets;
  final int reps;

  const WorkoutDayPlan({
    required this.dayName,
    required this.exercises,
    required this.sets,
    required this.reps,
  });
}

class WorkoutPlan {
  final String splitName;
  final Map<String, int> weeklySetsPerMuscle;
  final List<WorkoutDayPlan> days;

  const WorkoutPlan({
    required this.splitName,
    required this.weeklySetsPerMuscle,
    required this.days,
  });
}

class WorkoutEngine extends ChangeNotifier {
  // Singleton pattern
  static final WorkoutEngine _instance = WorkoutEngine._internal();
  factory WorkoutEngine() => _instance;
  WorkoutEngine._internal();

  /// Generates a customized WorkoutPlan based on snapshot and profile
  WorkoutPlan generatePlan(PhysiologySnapshot snap, UserProfile profile, BodyMeasurements measurements) {
    // 1. Calculate recovery multiplier
    double recoveryMultiplier = 1.0;
    if (snap.recoveryScore > 0.75) {
      recoveryMultiplier = 1.2;
    } else if (snap.recoveryScore < 0.50) {
      recoveryMultiplier = 0.6;
    }

    // 2. Define muscles and targets
    final isMale = !profile.gender.toLowerCase().startsWith('f');
    final Map<String, double> targets = {
      'Chest': isMale ? ArchetypeConstants.maleChestTarget : ArchetypeConstants.femaleChestTarget,
      'Back': isMale ? (ArchetypeConstants.maleBackWidthTarget + ArchetypeConstants.maleShouldersTarget) / 2.0 : (ArchetypeConstants.femaleBackWidthTarget + ArchetypeConstants.femaleShouldersTarget) / 2.0,
      'Shoulders': isMale ? ArchetypeConstants.maleShouldersTarget : ArchetypeConstants.femaleShouldersTarget,
      'Biceps': isMale ? ArchetypeConstants.maleBicepsTarget : ArchetypeConstants.femaleBicepsTarget,
      'Triceps': isMale ? ArchetypeConstants.maleBicepsTarget : ArchetypeConstants.femaleBicepsTarget,
      'Legs': isMale ? ArchetypeConstants.maleThighsTarget : ArchetypeConstants.femaleThighsTarget,
      'Core': isMale ? ArchetypeConstants.maleWaistTarget : ArchetypeConstants.femaleWaistTarget,
    };

    final Map<String, double> current = {
      'Chest': measurements.chestCm,
      'Back': measurements.backWidthCm,
      'Shoulders': measurements.shouldersCm,
      'Biceps': measurements.bicepsCm,
      'Triceps': measurements.bicepsCm, // fallback
      'Legs': measurements.thighsCm,
      'Core': measurements.waistCm,
    };

    // Calculate priority scores and dynamic volume per muscle
    final Map<String, int> weeklySets = {};
    final baseSets = 12; // baseline weekly sets per muscle group

    for (var muscle in ['Chest', 'Back', 'Shoulders', 'Biceps', 'Triceps', 'Legs', 'Core']) {
      double target = targets[muscle] ?? 50.0;
      double curr = current[muscle] ?? 40.0;
      double gap = muscle == 'Core' ? max(0.0, curr - target) : max(0.0, target - curr);

      double priorityMultiplier = 0.9;
      if (gap > 5.0) {
        priorityMultiplier = 1.5;
      } else if (gap >= 2.0) {
        priorityMultiplier = 1.2;
      }

      int sets = (baseSets * recoveryMultiplier * priorityMultiplier).round();
      weeklySets[muscle] = sets.clamp(3, 30);
    }

    // 3. Archetype specific distribution tweaks
    if (snap.archetype == PhysiqueArchetype.vTaper) {
      weeklySets['Back'] = (weeklySets['Back']! * 1.3).round();
      weeklySets['Shoulders'] = (weeklySets['Shoulders']! * 1.2).round();
      weeklySets['Legs'] = (weeklySets['Legs']! * 0.8).round();
    } else if (snap.archetype == PhysiqueArchetype.massMonster) {
      weeklySets.updateAll((key, val) => (val * 1.2).round().clamp(10, 32));
    } else if (snap.archetype == PhysiqueArchetype.leanWarrior) {
      weeklySets.updateAll((key, val) => (val * 0.9).round());
      weeklySets['Core'] = (weeklySets['Core']! * 1.2).round();
    }

    // 4. Split Selection based on target frequency or simple profile settings
    // Let's assume split is decided based on primary goal or default to 3/4/5 days
    int trainingDays = 3;
    if (profile.primaryGoal == PrimaryGoal.bulk) {
      trainingDays = 5;
    } else if (profile.primaryGoal == PrimaryGoal.cut) {
      trainingDays = 4;
    } else if (profile.primaryGoal == PrimaryGoal.recomp) {
      trainingDays = 5;
    } else {
      trainingDays = 3;
    }

    String splitName = "Full Body x3";
    List<WorkoutDayPlan> days = [];

    final eqModeStr = profile.equipmentMode == EquipmentMode.bodyweight
        ? 'bodyweight'
        : (profile.equipmentMode == EquipmentMode.homeGym ? 'home_gym' : 'full_gym');

    if (trainingDays == 3) {
      splitName = "Full Body x3";
      // Generate 3 identical or slightly different Full Body days
      for (int i = 1; i <= 3; i++) {
        final dayExercises = [
          ...selectExercises('Chest', eqModeStr, 1),
          ...selectExercises('Back', eqModeStr, 1),
          ...selectExercises('Shoulders', eqModeStr, 1),
          ...selectExercises('Legs', eqModeStr, 2),
          ...selectExercises('Core', eqModeStr, 1),
        ];
        days.add(WorkoutDayPlan(
          dayName: "Full Body - Day $i",
          exercises: dayExercises,
          sets: 3,
          reps: profile.primaryGoal == PrimaryGoal.bulk ? 8 : 12,
        ));
      }
    } else if (trainingDays == 4) {
      splitName = "Upper/Lower Split";
      // Upper 1, Lower 1, Upper 2, Lower 2
      final upper1 = [
        ...selectExercises('Chest', eqModeStr, 2),
        ...selectExercises('Back', eqModeStr, 2),
        ...selectExercises('Shoulders', eqModeStr, 1),
        ...selectExercises('Biceps', eqModeStr, 1),
        ...selectExercises('Triceps', eqModeStr, 1),
      ];
      final lower1 = [
        ...selectExercises('Legs', eqModeStr, 4),
        ...selectExercises('Core', eqModeStr, 2),
      ];
      final upper2 = [
        ...selectExercises('Chest', eqModeStr, 2),
        ...selectExercises('Back', eqModeStr, 2),
        ...selectExercises('Shoulders', eqModeStr, 1),
        ...selectExercises('Biceps', eqModeStr, 1),
        ...selectExercises('Triceps', eqModeStr, 1),
      ];
      final lower2 = [
        ...selectExercises('Legs', eqModeStr, 4),
        ...selectExercises('Core', eqModeStr, 2),
      ];
      days.add(WorkoutDayPlan(dayName: "Upper Day A", exercises: upper1, sets: 4, reps: 10));
      days.add(WorkoutDayPlan(dayName: "Lower Day A", exercises: lower1, sets: 4, reps: 10));
      days.add(WorkoutDayPlan(dayName: "Upper Day B", exercises: upper2, sets: 4, reps: 12));
      days.add(WorkoutDayPlan(dayName: "Lower Day B", exercises: lower2, sets: 4, reps: 12));
    } else {
      splitName = "Push/Pull/Legs/Upper/Lower"; // 5 days
      final push = [
        ...selectExercises('Chest', eqModeStr, 2),
        ...selectExercises('Shoulders', eqModeStr, 2),
        ...selectExercises('Triceps', eqModeStr, 1),
      ];
      final pull = [
        ...selectExercises('Back', eqModeStr, 3),
        ...selectExercises('Biceps', eqModeStr, 2),
      ];
      final legs = [
        ...selectExercises('Legs', eqModeStr, 4),
        ...selectExercises('Core', eqModeStr, 2),
      ];
      final upper = [
        ...selectExercises('Chest', eqModeStr, 1),
        ...selectExercises('Back', eqModeStr, 1),
        ...selectExercises('Shoulders', eqModeStr, 1),
        ...selectExercises('Biceps', eqModeStr, 1),
        ...selectExercises('Triceps', eqModeStr, 1),
      ];
      final lower = [
        ...selectExercises('Legs', eqModeStr, 3),
        ...selectExercises('Core', eqModeStr, 2),
      ];
      days.add(WorkoutDayPlan(dayName: "Push Day", exercises: push, sets: 4, reps: 8));
      days.add(WorkoutDayPlan(dayName: "Pull Day", exercises: pull, sets: 4, reps: 8));
      days.add(WorkoutDayPlan(dayName: "Legs Day", exercises: legs, sets: 4, reps: 10));
      days.add(WorkoutDayPlan(dayName: "Upper Hypertrophy", exercises: upper, sets: 3, reps: 12));
      days.add(WorkoutDayPlan(dayName: "Lower Hypertrophy", exercises: lower, sets: 3, reps: 12));
    }

    return WorkoutPlan(
      splitName: splitName,
      weeklySetsPerMuscle: weeklySets,
      days: days,
    );
  }

  /// Helper to query exercises
  List<ExerciseModel> selectExercises(String muscleGroup, String equipment, int count) {
    final available = ExerciseDatabase.forMuscleAndEquipment(muscleGroup, equipment);
    if (available.isEmpty) {
      // Fallback
      return ExerciseDatabase.exercises.where((e) => e.muscleGroup.toLowerCase() == muscleGroup.toLowerCase()).take(count).toList();
    }
    // Randomize or take first
    final list = List<ExerciseModel>.from(available)..shuffle();
    return list.take(count).toList();
  }
}
