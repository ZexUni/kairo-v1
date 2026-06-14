import 'package:flutter/material.dart';

import 'package:kairo/models/onboarding_data.dart';

import 'package:kairo/core/constants/app_colors.dart';

import 'package:kairo/core/widgets/dashboard_section_title.dart';
import 'package:kairo/core/widgets/intelligence_alert_card.dart';

import 'package:kairo/features/nutrition/meal_plan_screen.dart';
import 'package:kairo/features/nutrition/dish_browser_screen.dart';

class NutritionScreen extends StatefulWidget {
  final OnboardingData onboardingData;

  const NutritionScreen({super.key, required this.onboardingData});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  Widget macroCard({
    required String title,

    required String value,

    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,

          borderRadius: BorderRadius.circular(22),

          border: Border.all(color: Colors.white10, width: 1),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Icon(icon, color: AppColors.primary, size: 28),

            const SizedBox(height: 18),

            Text(
              value,

              style: const TextStyle(
                color: Colors.white,

                fontSize: 28,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              title,

              style: const TextStyle(
                color: AppColors.textSecondary,

                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget actionButton({
    required String title,

    required String subtitle,

    required IconData icon,

    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,

        margin: const EdgeInsets.only(bottom: 18),

        padding: const EdgeInsets.all(22),

        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,

          borderRadius: BorderRadius.circular(24),

          border: Border.all(color: Colors.white10, width: 1),
        ),

        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),

                borderRadius: BorderRadius.circular(18),
              ),

              child: Icon(icon, color: AppColors.primary),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: const TextStyle(
                      color: Colors.white,

                      fontSize: 18,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    subtitle,

                    style: const TextStyle(
                      color: AppColors.textSecondary,

                      fontSize: 14,

                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,

              color: AppColors.textSecondary,

              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.onboardingData.nutritionPlan;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        elevation: 0,

        title: const Text('Nutrition System'),
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
                    widget.onboardingData.physiqueGoal,

                    style: const TextStyle(
                      color: AppColors.primary,

                      fontSize: 16,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 28),

                  IntelligenceAlertCard(
                    title: 'Nutrition Intelligence',

                    message:
                        'Your nutrition system is optimized for ${widget.onboardingData.physiqueGoal.toLowerCase()} adaptation and recovery.',

                    icon: Icons.restaurant,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // =========================
            // MACROS
            // =========================
            DashboardSectionTitle(title: 'Daily Targets'),

            const SizedBox(height: 20),

            Row(
              children: [
                macroCard(
                  title: 'Calories',

                  value: '${plan.calories}',

                  icon: Icons.local_fire_department,
                ),

                const SizedBox(width: 14),

                macroCard(
                  title: 'Protein',

                  value: '${plan.protein}g',

                  icon: Icons.fitness_center,
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                macroCard(
                  title: 'Carbs',

                  value: '${plan.carbs}g',

                  icon: Icons.bolt,
                ),

                const SizedBox(width: 14),

                macroCard(
                  title: 'Fats',

                  value: '${plan.fats}g',

                  icon: Icons.water_drop,
                ),
              ],
            ),

            const SizedBox(height: 35),

            // =========================
            // ACTIONS
            // =========================
            DashboardSectionTitle(title: 'Nutrition Tools'),

            const SizedBox(height: 20),

            actionButton(
              title: 'Generated Meal Plan',

              subtitle:
                  'AI-generated meals aligned to your physiological goal.',

              icon: Icons.restaurant_menu,

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) =>
                        MealPlanScreen(onboardingData: widget.onboardingData),
                  ),
                );
              },
            ),

            actionButton(
              title: 'Dish Browser',

              subtitle: 'Explore high-protein meals and nutritional dishes.',

              icon: Icons.menu_book,

              onTap: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (context) => DishBrowserScreen(
                      onboardingData: widget.onboardingData,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
