import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kairo/services/auth_service.dart';
import 'package:kairo/services/physiology_engine.dart';
import 'package:kairo/services/nutrition_engine.dart';
import 'package:kairo/data/repositories/user_repository.dart';
import 'package:kairo/data/repositories/nutrition_repository.dart';
import 'package:kairo/data/models/user_profile.dart';
import 'package:kairo/data/models/physiology_snapshot.dart';
import 'package:kairo/data/models/nutrition_log.dart';
import 'package:kairo/data/models/meal_entry.dart';
import 'package:kairo/core/constants/app_colors.dart';
import 'package:kairo/widgets/bottom_nav_bar.dart';

class NutritionHomeScreen extends StatefulWidget {
  const NutritionHomeScreen({super.key});

  @override
  State<NutritionHomeScreen> createState() => _NutritionHomeScreenState();
}

class _NutritionHomeScreenState extends State<NutritionHomeScreen> {
  bool _loading = true;
  NutritionLog? _log;
  UserProfile? _profile;
  NutritionTargets? _targets;

  @override
  void initState() {
    super.initState();
    _loadNutritionData();
  }

  Future<void> _loadNutritionData() async {
    setState(() => _loading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final userId = auth.currentUser?.uid ?? 'local_user';

      final userRepo = UserRepository();
      final nutritionRepo = NutritionRepository();

      _profile = await userRepo.getProfile(userId);
      _log = await nutritionRepo.getLogForDate(userId, DateTime.now());

      final measurements = await userRepo.getLatestMeasurements(userId);
      final lifestyle = await userRepo.getLatestLifestyle(userId);
      final performance = await userRepo.getLatestPerformance(userId);

      if (_profile != null && measurements != null && lifestyle != null && performance != null) {
        final snap = PhysiologyEngine().computeSnapshot(
          profile: _profile!,
          measurements: measurements,
          lifestyle: lifestyle,
          performance: performance,
          latestCheckin: null,
        );
        _targets = NutritionEngine().calculateTargets(snap, _profile!, lifestyle);
      }
    } catch (e) {
      debugPrint("Error loading nutrition: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _addWater(double ml) async {
    if (_profile == null || _targets == null) return;
    
    final auth = Provider.of<AuthService>(context, listen: false);
    final userId = auth.currentUser?.uid ?? 'local_user';

    final currentLog = _log ?? NutritionLog(
      id: "${userId}_${DateFormat('yyyy-MM-dd').format(DateTime.now())}",
      userId: userId,
      logDate: DateTime.now(),
      meals: [],
      totalCalories: 0.0,
      totalProteinG: 0.0,
      totalCarbsG: 0.0,
      totalFatG: 0.0,
      totalFiberG: 0.0,
      waterMl: 0.0,
      targetCalories: _targets!.calories,
      targetProteinG: _targets!.proteinG,
      targetCarbsG: _targets!.carbsG,
      targetFatG: _targets!.fatG,
    );

    final updatedLog = currentLog.copyWith(waterMl: currentLog.waterMl + ml);
    final nutritionRepo = NutritionRepository();
    await nutritionRepo.saveLog(updatedLog);
    
    // Refresh snapshot
    PhysiologyEngine().triggerUpdate();

    setState(() {
      _log = updatedLog;
    });
  }

  Widget _buildMealCard(String title, String mealType) {
    final meals = _log?.meals.where((m) => m.mealType == mealType).toList() ?? [];
    
    return Card(
      color: AppColors.card,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                  onPressed: () {
                    context.push('/nutrition/log?mealType=$mealType').then((_) => _loadNutritionData());
                  },
                ),
              ],
            ),
            if (meals.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('No food logged yet', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              )
            else
              ...meals.map((meal) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(meal.foodName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
                              Text('${meal.servingSize.round()}${meal.servingUnit}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                            ],
                          ),
                        ),
                        Text('${meal.calories.round()} kcal', style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null || _targets == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.go('/onboarding'),
            child: const Text('COMPLETE ONBOARDING'),
          ),
        ),
      );
    }

    final targetCal = _targets!.calories;
    final targetProt = _targets!.proteinG;
    final targetCarb = _targets!.carbsG;
    final targetFat = _targets!.fatG;

    final consumedCal = _log?.totalCalories ?? 0.0;
    final consumedProt = _log?.totalProteinG ?? 0.0;
    final consumedCarb = _log?.totalCarbsG ?? 0.0;
    final consumedFat = _log?.totalFatG ?? 0.0;
    final consumedWater = _log?.waterMl ?? 0.0;

    // Build fl_chart donut data
    final chartSections = <PieChartSectionData>[
      if (consumedProt > 0)
        PieChartSectionData(
          value: consumedProt * 4,
          color: AppColors.success,
          radius: 18,
          title: 'Prot',
          titleStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
        ),
      if (consumedCarb > 0)
        PieChartSectionData(
          value: consumedCarb * 4,
          color: AppColors.warning,
          radius: 18,
          title: 'Carb',
          titleStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
        ),
      if (consumedFat > 0)
        PieChartSectionData(
          value: consumedFat * 9,
          color: AppColors.danger,
          radius: 18,
          title: 'Fat',
          titleStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),
        ),
      if (consumedCal == 0)
        PieChartSectionData(
          value: 1,
          color: Colors.white10,
          radius: 18,
          showTitle: false,
        ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Nutrition Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined, color: AppColors.primary),
            onPressed: () {
              context.push('/nutrition/dashboard');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(24.0),
                physics: const BouncingScrollPhysics(),
                children: [
                  // MACRO DONUT & LEGEND
                  Card(
                    color: AppColors.card,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 110,
                            width: 110,
                            child: PieChart(
                              PieChartData(
                                sections: chartSections,
                                centerSpaceRadius: 36,
                                sectionsSpace: 2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${consumedCal.round()} / ${targetCal.round()} kcal",
                                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                const SizedBox(height: 4),
                                const Text("Calories consumed today", style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                                const SizedBox(height: 12),
                                _buildMacroLegendRow('Protein', consumedProt, targetProt, AppColors.success),
                                _buildMacroLegendRow('Carbs', consumedCarb, targetCarb, AppColors.warning),
                                _buildMacroLegendRow('Fat', consumedFat, targetFat, AppColors.danger),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // WATER TRACKER
                  Card(
                    color: AppColors.card,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Water Tracker', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                              Text('${consumedWater.round()} / 3000 ml', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: LinearProgressIndicator(
                              value: (consumedWater / 3000.0).clamp(0.0, 1.0),
                              minHeight: 8,
                              backgroundColor: Colors.white10,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildWaterButton('+250ml', 250),
                              _buildWaterButton('+500ml', 500),
                              _buildWaterButton('+1L', 1000),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // MEALS CARDS
                  _buildMealCard('Breakfast', 'breakfast'),
                  _buildMealCard('Lunch', 'lunch'),
                  _buildMealCard('Dinner', 'dinner'),
                  _buildMealCard('Snacks', 'snack'),
                ],
              ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildMacroLegendRow(String label, double val, double target, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Container(height: 8, width: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          const Spacer(),
          Text("${val.round()}g / ${target.round()}g", style: const TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildWaterButton(String label, double val) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: OutlinedButton(
          onPressed: () => _addWater(val),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            foregroundColor: AppColors.textPrimary,
          ),
          child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
