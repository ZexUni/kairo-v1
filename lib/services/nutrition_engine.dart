import 'package:flutter/material.dart';
import 'package:kairo/data/models/user_profile.dart';
import 'package:kairo/data/models/lifestyle_assessment.dart';
import 'package:kairo/data/models/physiology_snapshot.dart';
import 'package:kairo/data/database/food_database.dart';
import 'package:kairo/core/utils/physiology_formulas.dart';

class NutritionTargets {
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  const NutritionTargets({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });
}

class MealPlan {
  final List<FoodModel> breakfast;
  final List<FoodModel> lunch;
  final List<FoodModel> dinner;
  final List<FoodModel> snacks;

  const MealPlan({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snacks,
  });
}

class NutritionEngine extends ChangeNotifier {
  // Singleton pattern
  static final NutritionEngine _instance = NutritionEngine._internal();
  factory NutritionEngine() => _instance;
  NutritionEngine._internal();

  /// Calculates BMR, TDEE, and macro targets
  NutritionTargets calculateTargets(PhysiologySnapshot snap, UserProfile profile, LifestyleAssessment lifestyle) {
    final isMale = !profile.gender.toLowerCase().startsWith('f');
    final bmr = PhysiologyFormulas.calculateBMR(
      weightKg: profile.weightKg,
      heightCm: profile.heightCm,
      ageYears: profile.age,
      isMale: isMale,
    );

    // Determine activity multiplier
    final scoreSum = lifestyle.cardioScore + lifestyle.dailyMovementScore;
    double tdeeMultiplier = 1.2; // Sedentary default
    if (scoreSum > 8.0) {
      tdeeMultiplier = 1.9; // Very active
    } else if (scoreSum > 6.0) {
      tdeeMultiplier = 1.725; // Active
    } else if (scoreSum > 4.0) {
      tdeeMultiplier = 1.55; // Moderate
    } else if (scoreSum > 2.0) {
      tdeeMultiplier = 1.375; // Light
    }

    final tdee = bmr * tdeeMultiplier;

    // Adjust calories by goal
    double calories = tdee;
    if (profile.primaryGoal == PrimaryGoal.bulk) {
      calories = tdee + 300.0;
    } else if (profile.primaryGoal == PrimaryGoal.cut) {
      calories = tdee - 400.0;
    }

    // Determine state-specific macros
    double proteinG = 2.0 * profile.weightKg;
    double carbsG = 4.0 * profile.weightKg;
    double fatG = 0.9 * profile.weightKg;

    // Choose macros based on archetype & state
    // Let's first look at the four states:
    // RS recovery, SS stress, AS anabolic, MS metabolic
    final maxScore = [snap.recoveryScore, snap.stressScore, snap.anabolicScore, snap.metabolicScore].reduce((a, b) => a > b ? a : b);

    if (maxScore == snap.anabolicScore) {
      // Anabolic State
      proteinG = 2.2 * snap.leanBodyMassKg;
      carbsG = 6.0 * profile.weightKg;
      fatG = 1.0 * profile.weightKg;
    } else if (maxScore == snap.metabolicScore) {
      // Metabolic State
      proteinG = 1.8 * profile.weightKg;
      carbsG = 4.0 * profile.weightKg;
      fatG = 0.8 * profile.weightKg;
    } else if (maxScore == snap.stressScore) {
      // Stress State
      proteinG = 2.4 * profile.weightKg;
      carbsG = 3.0 * profile.weightKg;
      fatG = 1.0 * profile.weightKg;
    } else {
      // Recovery State
      proteinG = 2.5 * snap.leanBodyMassKg;
      carbsG = 5.0 * profile.weightKg;
      fatG = 0.8 * profile.weightKg;
    }

    // Tweak macros by archetype
    if (snap.archetype == PhysiqueArchetype.vTaper || snap.archetype == PhysiqueArchetype.classicBodybuilder) {
      // Skinny / underdeveloped archetype check -> high carb surplus
      if (profile.weightKg / ((profile.heightCm / 100.0) * (profile.heightCm / 100.0)) < 20.0) {
        // Skinny/Underdeveloped surplus +15%
        calories = tdee * 1.15;
        proteinG = 2.2 * snap.leanBodyMassKg;
        carbsG = 6.0 * profile.weightKg;
        fatG = 1.0 * profile.weightKg;
      }
    } else if (snap.archetype == PhysiqueArchetype.leanWarrior) {
      // Skinny-fat check
      if (snap.bodyFatPercent > 18.0 && profile.weightKg / ((profile.heightCm / 100.0) * (profile.heightCm / 100.0)) < 23.0) {
        // Skinny-fat maintenance
        calories = tdee;
        proteinG = 2.4 * profile.weightKg;
        carbsG = 3.0 * profile.weightKg;
        fatG = 0.8 * profile.weightKg;
      }
    }

    // Keep calories positive
    calories = calories.clamp(1200.0, 5000.0);
    proteinG = proteinG.clamp(40.0, 300.0);
    carbsG = carbsG.clamp(50.0, 600.0);
    fatG = fatG.clamp(20.0, 200.0);

    return NutritionTargets(
      calories: calories,
      proteinG: proteinG,
      carbsG: carbsG,
      fatG: fatG,
    );
  }

  /// Recommend suitable foods for the current physiological state
  List<FoodModel> recommendFoods(PhysiologySnapshot snap) {
    // Determine the state string
    final scores = {
      'anabolic': snap.anabolicScore,
      'metabolic': snap.metabolicScore,
      'stress': snap.stressScore,
      'recovery': snap.recoveryScore,
    };
    final bestState = scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    final recommended = FoodDatabase.forState(bestState);
    if (recommended.isEmpty) return FoodDatabase.foods.take(10).toList();
    
    final list = List<FoodModel>.from(recommended)..shuffle();
    return list.take(10).toList();
  }

  /// Generates a daily meal plan based on goals and state
  MealPlan generateMealPlan(PhysiologySnapshot snap, UserProfile profile) {
    // Determine state
    final scores = {
      'anabolic': snap.anabolicScore,
      'metabolic': snap.metabolicScore,
      'stress': snap.stressScore,
      'recovery': snap.recoveryScore,
    };
    final bestState = scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    final list = FoodDatabase.forState(bestState);

    // Select breakfast
    final breakfastFoods = _selectFromList(list.where((f) => f.category == 'Fruits' || f.category == 'Dry Fruits').toList(), 2);
    // Select lunch
    final lunchFoods = _selectFromList(list.where((f) => f.category == 'Rice Dishes' || f.category.contains('Main Course')).toList(), 2);
    // Select dinner
    final dinnerFoods = _selectFromList(list.where((f) => f.category.contains('Main Course') || f.category == 'Dal').toList(), 2);
    // Select snacks
    final snackFoods = _selectFromList(list.where((f) => f.category == 'Dry Fruits' || f.category == 'Fruits').toList(), 2);

    return MealPlan(
      breakfast: breakfastFoods,
      lunch: lunchFoods,
      dinner: dinnerFoods,
      snacks: snackFoods,
    );
  }

  List<FoodModel> _selectFromList(List<FoodModel> src, int count) {
    if (src.isEmpty) {
      return FoodDatabase.foods.take(count).toList();
    }
    final copy = List<FoodModel>.from(src)..shuffle();
    return copy.take(count).toList();
  }
}
