import 'package:flutter/material.dart';

import 'package:kairo/models/onboarding_data.dart';

import 'package:kairo/core/constants/app_colors.dart';

import 'package:kairo/models/dish_model.dart';
import 'package:kairo/core/services/dish_database.dart';

class DishBrowserScreen extends StatelessWidget {
  final OnboardingData onboardingData;

  const DishBrowserScreen({super.key, required this.onboardingData});

  @override
  Widget build(BuildContext context) {
    final dishes = DishDatabase.dishes.where((dish) {
      if (onboardingData.dietPreference == 'Veg') {
        return dish.vegetarian;
      }

      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: const Text('Dish Browser'),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(24),

        itemCount: dishes.length,

        itemBuilder: (context, index) {
          final Dish dish = dishes[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 20),

            decoration: BoxDecoration(
              color: AppColors.card,

              borderRadius: BorderRadius.circular(20),
            ),

            child: ExpansionTile(
              collapsedIconColor: Colors.white,

              iconColor: AppColors.primary,

              title: Text(
                dish.name,

                style: const TextStyle(
                  color: Colors.white,

                  fontSize: 20,

                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                '${dish.calories.toStringAsFixed(0)} kcal',

                style: const TextStyle(color: AppColors.primary),
              ),

              children: [
                Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      macroRow('Protein', dish.protein),

                      macroRow('Carbs', dish.carbs),

                      macroRow('Fats', dish.fats),

                      const SizedBox(height: 20),

                      const Text(
                        'Ingredients',

                        style: TextStyle(
                          color: Colors.white,

                          fontSize: 18,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      ...dish.ingredients.map((ingredient) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),

                          child: Text(
                            '• $ingredient',

                            style: const TextStyle(color: Colors.white70),
                          ),
                        );
                      }),

                      const SizedBox(height: 20),

                      const Text(
                        'Instructions',

                        style: TextStyle(
                          color: Colors.white,

                          fontSize: 18,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      ...dish.instructions.asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),

                          child: Text(
                            '${entry.key + 1}. ${entry.value}',

                            style: const TextStyle(color: Colors.white70),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget macroRow(String title, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Text(title, style: const TextStyle(color: Colors.white)),

          Text(
            '${value.toStringAsFixed(0)} g',

            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
