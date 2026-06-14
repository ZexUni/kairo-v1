import 'package:kairo/models/nutrition_plan.dart';

import 'package:kairo/models/dish_model.dart';
import 'package:kairo/core/services/dish_database.dart';

class MealGenerator {
  static List<Dish> generateMeals({required NutritionPlan plan}) {
    List<Dish> selectedMeals = [];

    int currentCalories = 0;

    for (final dish in DishDatabase.dishes) {
      // Vegetarian Filter

      if (plan.dietType == 'Vegetarian' && !dish.vegetarian) {
        continue;
      }

      // Vegan Filter
      // (temporary simple logic)

      if (plan.dietType == 'Vegan' && !dish.vegetarian) {
        continue;
      }

      selectedMeals.add(dish);

      currentCalories += dish.calories;

      // Stop once close to target

      if (currentCalories >= plan.calories * 0.9) {
        break;
      }
    }

    return selectedMeals;
  }

  static int totalCalories(List<Dish> meals) {
    int total = 0;

    for (final meal in meals) {
      total += meal.calories;
    }

    return total;
  }

  static int totalProtein(List<Dish> meals) {
    int total = 0;

    for (final meal in meals) {
      total += meal.protein;
    }

    return total;
  }

  static int totalCarbs(List<Dish> meals) {
    int total = 0;

    for (final meal in meals) {
      total += meal.carbs;
    }

    return total;
  }

  static int totalFats(List<Dish> meals) {
    int total = 0;

    for (final meal in meals) {
      total += meal.fats;
    }

    return total;
  }
}
