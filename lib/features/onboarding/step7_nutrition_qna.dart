import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kairo/features/onboarding/onboarding_controller.dart';
import 'package:kairo/data/models/user_profile.dart';
import 'package:kairo/core/constants/app_colors.dart';

class Step7NutritionQna extends StatefulWidget {
  const Step7NutritionQna({super.key});

  @override
  State<Step7NutritionQna> createState() => _Step7NutritionQnaState();
}

class _Step7NutritionQnaState extends State<Step7NutritionQna> {
  EquipmentMode _selectedMode = EquipmentMode.fullGym;

  @override
  void initState() {
    super.initState();
    final c = Provider.of<OnboardingController>(context, listen: false);
    _selectedMode = c.equipmentMode;
  }

  void _next() {
    final c = Provider.of<OnboardingController>(context, listen: false);
    c.equipmentMode = _selectedMode;
    c.nextStep();
  }

  Widget _buildCard(EquipmentMode mode, String title, String subtitle, IconData icon) {
    final isSelected = _selectedMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedMode = mode);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white10,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 30,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Select Equipment',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose your primary training environment to personalize exercise selection.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _buildCard(
                  EquipmentMode.bodyweight,
                  'BODYWEIGHT',
                  'No equipment needed. Train anywhere, anytime using your body.',
                  Icons.sports_gymnastics,
                ),
                _buildCard(
                  EquipmentMode.homeGym,
                  'HOME GYM',
                  'Basic home gym setup. Dumbbells, resistance bands, pull-up bar.',
                  Icons.home_outlined,
                ),
                _buildCard(
                  EquipmentMode.fullGym,
                  'FULL GYM',
                  'Access to commercial gym. Barbell, plates, cables, machines.',
                  Icons.fitness_center_outlined,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 58,
                  child: ElevatedButton(
                    onPressed: _next,
                    child: const Text('CONTINUE'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
