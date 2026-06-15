import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:kairo/services/auth_service.dart';
import 'package:kairo/services/physiology_engine.dart';
import 'package:kairo/services/nutrition_engine.dart';
import 'package:kairo/data/repositories/user_repository.dart';
import 'package:kairo/data/repositories/nutrition_repository.dart';
import 'package:kairo/data/repositories/recovery_repository.dart';
import 'package:kairo/data/database/food_database.dart';
import 'package:kairo/data/models/nutrition_log.dart';
import 'package:kairo/data/models/meal_entry.dart';
import 'package:kairo/core/constants/app_colors.dart';

class MealLogScreen extends StatefulWidget {
  final String? initialMealType;

  const MealLogScreen({
    super.key,
    this.initialMealType,
  });

  @override
  State<MealLogScreen> createState() => _MealLogScreenState();
}

class _MealLogScreenState extends State<MealLogScreen> {
  final _uuid = const Uuid();
  String _mealType = 'breakfast';
  final _searchController = TextEditingController();
  String _searchQuery = "";

  FoodModel? _selectedFood;
  final _servingController = TextEditingController(text: '100');
  double _servingSize = 100.0;

  @override
  void initState() {
    super.initState();
    _mealType = widget.initialMealType ?? 'breakfast';
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
    _servingController.addListener(() {
      setState(() {
        _servingSize = double.tryParse(_servingController.text.trim()) ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _servingController.dispose();
    super.dispose();
  }

  List<FoodModel> _getFilteredFoods() {
    if (_searchQuery.isEmpty) return FoodDatabase.foods.take(15).toList();
    return FoodDatabase.foods.where((f) => f.name.toLowerCase().contains(_searchQuery)).toList();
  }

  Future<void> _saveMeal() async {
    if (_selectedFood == null || _servingSize <= 0) return;

    final auth = Provider.of<AuthService>(context, listen: false);
    final userId = auth.currentUser?.uid ?? 'local_user';

    final userRepo = UserRepository();
    final nutritionRepo = NutritionRepository();

    // 1. Calculate nutrient values for the custom serving size
    final factor = _servingSize / 100.0;
    final calories = _selectedFood!.caloriesPer100g * factor;
    final protein = _selectedFood!.proteinPer100g * factor;
    final carbs = _selectedFood!.carbsPer100g * factor;
    final fat = _selectedFood!.fatPer100g * factor;
    final fiber = _selectedFood!.fiberPer100g * factor;

    // 2. Fetch existing daily log or create new
    final today = DateTime.now();
    final logDateStr = DateFormat('yyyy-MM-dd').format(today);
    final logId = "${userId}_$logDateStr";
    
    var log = await nutritionRepo.getLogForDate(userId, today);
    
    if (log == null) {
      // Fetch targets to set baseline
      double targetCal = 2000.0;
      double targetProt = 150.0;
      double targetCarb = 250.0;
      double targetFat = 70.0;

      final profile = await userRepo.getProfile(userId);
      final measurements = await userRepo.getLatestMeasurements(userId);
      final lifestyle = await userRepo.getLatestLifestyle(userId);
      final performance = await userRepo.getLatestPerformance(userId);

      if (profile != null && measurements != null && lifestyle != null && performance != null) {
        final snap = PhysiologyEngine().computeSnapshot(
          profile: profile,
          measurements: measurements,
          lifestyle: lifestyle,
          performance: performance,
          latestCheckin: null,
        );
        final targets = NutritionEngine().calculateTargets(snap, profile, lifestyle);
        targetCal = targets.calories;
        targetProt = targets.proteinG;
        targetCarb = targets.carbsG;
        targetFat = targets.fatG;
      }

      log = NutritionLog(
        id: logId,
        userId: userId,
        logDate: today,
        meals: [],
        totalCalories: 0.0,
        totalProteinG: 0.0,
        totalCarbsG: 0.0,
        totalFatG: 0.0,
        totalFiberG: 0.0,
        waterMl: 0.0,
        targetCalories: targetCal,
        targetProteinG: targetProt,
        targetCarbsG: targetCarb,
        targetFatG: targetFat,
      );
    }

    // 3. Create meal entry
    final entry = MealEntry(
      id: _uuid.v4(),
      nutritionLogId: logId,
      mealType: _mealType,
      foodName: _selectedFood!.name,
      servingSize: _servingSize,
      servingUnit: 'g',
      calories: calories,
      proteinG: protein,
      carbsG: carbs,
      fatG: fat,
      fiberG: fiber,
      loggedAt: DateTime.now(),
    );

    // 4. Re-calculate totals
    final updatedMeals = List<MealEntry>.from(log.meals)..add(entry);
    double totalCal = 0.0;
    double totalProt = 0.0;
    double totalCarb = 0.0;
    double totalFat = 0.0;
    double totalFiber = 0.0;

    for (var m in updatedMeals) {
      totalCal += m.calories;
      totalProt += m.proteinG;
      totalCarb += m.carbsG;
      totalFat += m.fatG;
      totalFiber += m.fiberG;
    }

    final updatedLog = log.copyWith(
      meals: updatedMeals,
      totalCalories: totalCal,
      totalProteinG: totalProt,
      totalCarbsG: totalCarb,
      totalFatG: totalFat,
      totalFiberG: totalFiber,
    );

    await nutritionRepo.saveLog(updatedLog);

    // Recompute Physiology Snapshot
    final profile = await userRepo.getProfile(userId);
    final measurements = await userRepo.getLatestMeasurements(userId);
    final lifestyle = await userRepo.getLatestLifestyle(userId);
    final performance = await userRepo.getLatestPerformance(userId);
    final recoveryCheckin = await RecoveryRepository().getLatestCheckin(userId);

    if (profile != null && measurements != null && lifestyle != null && performance != null) {
      final snap = PhysiologyEngine().computeSnapshot(
        profile: profile,
        measurements: measurements,
        lifestyle: lifestyle,
        performance: performance,
        latestCheckin: recoveryCheckin,
      );
      await userRepo.saveSnapshot(snap);
    }

    PhysiologyEngine().triggerUpdate();

    if (!mounted) return;
    context.pop();
  }

  Widget _buildMealTypeChip(String label, String value) {
    final isSelected = _mealType == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _mealType = value);
      },
      selectedColor: AppColors.primary,
      checkmarkColor: Colors.black,
      labelStyle: TextStyle(
        color: isSelected ? Colors.black : AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foods = _getFilteredFoods();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Log Food'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Meal Type Chips
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMealTypeChip('Breakfast', 'breakfast'),
                  _buildMealTypeChip('Lunch', 'lunch'),
                  _buildMealTypeChip('Dinner', 'dinner'),
                  _buildMealTypeChip('Snacks', 'snack'),
                ],
              ),
            ),

            if (_selectedFood == null) ...[
              // Food Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Search food...',
                    prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Foods List
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    final f = foods[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                      title: Text(f.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        "P: ${f.proteinPer100g.round()}g | C: ${f.carbsPer100g.round()}g | F: ${f.fatPer100g.round()}g",
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      trailing: Text("${f.caloriesPer100g.round()} kcal/100g", style: const TextStyle(color: AppColors.primary, fontSize: 13)),
                      onTap: () {
                        setState(() {
                          _selectedFood = f;
                        });
                      },
                    );
                  },
                ),
              ),
            ] else ...[
              // Food Detail & Serving size input
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24.0),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedFood!.name,
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white54),
                          onPressed: () => setState(() => _selectedFood = null),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedFood!.category.toUpperCase(),
                      style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),

                    // Serving Size Input
                    TextField(
                      controller: _servingController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        labelText: 'Serving Size (grams)',
                        prefixIcon: Icon(Icons.scale),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // SCALE PREVIEW
                    const Text(
                      'MACRO PREVIEW',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 12),
                    _buildPreviewRow('Calories', '${(_selectedFood!.caloriesPer100g * (_servingSize / 100.0)).round()} kcal', AppColors.primary),
                    _buildPreviewRow('Protein', '${(_selectedFood!.proteinPer100g * (_servingSize / 100.0)).toStringAsFixed(1)} g', AppColors.success),
                    _buildPreviewRow('Carbs', '${(_selectedFood!.carbsPer100g * (_servingSize / 100.0)).toStringAsFixed(1)} g', AppColors.warning),
                    _buildPreviewRow('Fat', '${(_selectedFood!.fatPer100g * (_servingSize / 100.0)).toStringAsFixed(1)} g', AppColors.danger),
                    
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 58,
                      child: ElevatedButton(
                        onPressed: _saveMeal,
                        child: const Text('LOG MEAL'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(height: 10, width: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            ],
          ),
          Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
