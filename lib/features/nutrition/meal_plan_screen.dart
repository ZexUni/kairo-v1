import 'package:flutter/material.dart';

import 'package:kairo/models/onboarding_data.dart';
import 'package:kairo/models/dish_model.dart';

import 'package:kairo/core/constants/app_colors.dart';

import 'package:kairo/core/services/meal_generator.dart';

class MealPlanScreen extends StatefulWidget {
  final OnboardingData onboardingData;

  const MealPlanScreen({super.key, required this.onboardingData});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  late List<Dish> meals;

  @override
  void initState() {
    super.initState();

    meals = MealGenerator.generateMeals(
      plan: widget.onboardingData.nutritionPlan,
    );
  }

  Widget macroCard({required String title, required String value}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),

          borderRadius: BorderRadius.circular(18),
        ),

        child: Column(
          children: [
            Text(
              value,

              style: const TextStyle(
                color: Colors.white,

                fontSize: 22,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              title,

              style: const TextStyle(
                color: AppColors.textSecondary,

                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalCalories = MealGenerator.totalCalories(meals);

    final totalProtein = MealGenerator.totalProtein(meals);

    final totalCarbs = MealGenerator.totalCarbs(meals);

    final totalFats = MealGenerator.totalFats(meals);

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: const Text('Meal Plan'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // =========================
            // HEADER
            // =========================
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(28),

              decoration: BoxDecoration(
                gradient: AppColors.cardGradient,

                borderRadius: BorderRadius.circular(28),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Adaptive Nutrition',

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 30,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    widget.onboardingData.nutritionPlan.dietType,

                    style: const TextStyle(
                      color: AppColors.primary,

                      fontSize: 16,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Row(
                    children: [
                      macroCard(
                        title: 'Calories',

                        value: totalCalories.toString(),
                      ),

                      const SizedBox(width: 12),

                      macroCard(title: 'Protein', value: '${totalProtein}g'),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      macroCard(title: 'Carbs', value: '${totalCarbs}g'),

                      const SizedBox(width: 12),

                      macroCard(title: 'Fats', value: '${totalFats}g'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // =========================
            // MEALS
            // =========================
            const Text(
              'Generated Meals',

              style: TextStyle(
                color: Colors.white,

                fontSize: 24,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 22),

            ...meals.map((meal) {
              return Container(
                width: double.infinity,

                margin: const EdgeInsets.only(bottom: 20),

                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient,

                  borderRadius: BorderRadius.circular(24),

                  border: Border.all(color: Colors.white10, width: 1),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Expanded(
                          child: Text(
                            meal.name,

                            style: const TextStyle(
                              color: Colors.white,

                              fontSize: 22,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,

                            vertical: 10,
                          ),

                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),

                            borderRadius: BorderRadius.circular(16),
                          ),

                          child: Text(
                            '${meal.calories} kcal',

                            style: const TextStyle(
                              color: AppColors.primary,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(
                      meal.category,

                      style: const TextStyle(
                        color: AppColors.textSecondary,

                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        macroCard(title: 'Protein', value: '${meal.protein}g'),

                        const SizedBox(width: 12),

                        macroCard(title: 'Carbs', value: '${meal.carbs}g'),

                        const SizedBox(width: 12),

                        macroCard(title: 'Fats', value: '${meal.fats}g'),
                      ],
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
