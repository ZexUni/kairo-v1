import 'package:kairo/models/nutrition_plan.dart';

class NutritionEngine {
  static NutritionPlan generatePlan({
    required double weight,

    required String goal,

    required String dietType,
  }) {
    // =========================
    // Base Calories
    // =========================

    double calories = weight * 33;

    // =========================
    // Goal Adjustment
    // =========================

    if (goal == 'Bulk') {
      calories += 350;
    } else if (goal == 'Slim') {
      calories -= 400;
    }

    // =========================
    // Macros
    // =========================

    double protein = weight * 2.2;

    double carbs = weight * 4;

    double fats = weight * 0.8;

    // =========================
    // Final Plan
    // =========================

    return NutritionPlan(
      calories: calories.round(),

      protein: protein.round(),

      carbs: carbs.round(),

      fats: fats.round(),

      dietType: dietType,
    );
  }

  static String nutritionFocus(String goal) {
    if (goal == 'Bulk') {
      return 'Caloric surplus and progressive overload.';
    }

    if (goal == 'Slim') {
      return 'Caloric deficit with protein preservation.';
    }

    return 'Balanced body recomposition.';
  }

  static String hydrationAdvice(double weight) {
    final liters = (weight * 0.04).toStringAsFixed(1);

    return 'Recommended hydration: $liters L/day';
  }

  static String proteinAdvice(double weight) {
    final protein = (weight * 2.2).round();

    return 'Recommended protein intake: $protein g/day';
  }
}
