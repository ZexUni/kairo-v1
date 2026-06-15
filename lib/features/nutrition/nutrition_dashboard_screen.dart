import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:kairo/services/auth_service.dart';
import 'package:kairo/data/repositories/nutrition_repository.dart';
import 'package:kairo/data/models/nutrition_log.dart';
import 'package:kairo/core/constants/app_colors.dart';

class NutritionDashboardScreen extends StatefulWidget {
  const NutritionDashboardScreen({super.key});

  @override
  State<NutritionDashboardScreen> createState() => _NutritionDashboardScreenState();
}

class _NutritionDashboardScreenState extends State<NutritionDashboardScreen> {
  bool _loading = true;
  List<NutritionLog> _logs = [];

  double _calorieAdherence = 0.0;
  double _proteinAdherence = 0.0;
  int _streakDays = 0;

  @override
  void initState() {
    super.initState();
    _loadHistoricalNutrition();
  }

  Future<void> _loadHistoricalNutrition() async {
    setState(() => _loading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final userId = auth.currentUser?.uid ?? 'local_user';

      final nutritionRepo = NutritionRepository();

      // Get last 30 days logs
      final now = DateTime.now();
      List<NutritionLog> fetchedLogs = [];

      for (int i = 0; i < 30; i++) {
        final date = now.subtract(Duration(days: i));
        final log = await nutritionRepo.getLogForDate(userId, date);
        if (log != null && (log.totalCalories > 0 || log.waterMl > 0)) {
          fetchedLogs.add(log);
        }
      }

      _logs = fetchedLogs;

      _calculateMetrics();
    } catch (e) {
      debugPrint("Error loading nutrition analytics: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _calculateMetrics() {
    if (_logs.isEmpty) {
      _calorieAdherence = 0.0;
      _proteinAdherence = 0.0;
      _streakDays = 0;
      return;
    }

    int calorieMatch = 0;
    int proteinMatch = 0;

    for (var log in _logs) {
      // Calorie Adherence: within ±150 kcal of target
      final diff = (log.totalCalories - log.targetCalories).abs();
      if (diff <= 150) calorieMatch++;

      // Protein Adherence: >= 90% of protein target
      if (log.totalProteinG >= log.targetProteinG * 0.9) proteinMatch++;
    }

    _calorieAdherence = (calorieMatch / _logs.length) * 100.0;
    _proteinAdherence = (proteinMatch / _logs.length) * 100.0;

    // Consistency Streak (consecutive days where food or water logged)
    int streak = 0;
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');

    for (int i = 0; i < 30; i++) {
      final checkDateStr = formatter.format(now.subtract(Duration(days: i)));
      final hasLog = _logs.any((l) => formatter.format(l.logDate) == checkDateStr);
      if (hasLog) {
        streak++;
      } else {
        if (i > 0) break; // if yesterday not logged, streak breaks
      }
    }
    _streakDays = streak;
  }

  @override
  Widget build(BuildContext context) {
    // 7 Days Calorie Chart
    final List<BarChartGroupData> calorieBarGroups = [];
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final labelFormatter = DateFormat('E');

    double maxCal = 2200.0;

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = formatter.format(date);
      final log = _logs.firstWhere((l) => formatter.format(l.logDate) == dateStr, orElse: () {
        return NutritionLog(
          id: '', userId: '', logDate: date, meals: [],
          totalCalories: 0.0, totalProteinG: 0.0, totalCarbsG: 0.0, totalFatG: 0.0, totalFiberG: 0.0, waterMl: 0.0,
          targetCalories: 2000.0, targetProteinG: 150.0, targetCarbsG: 250.0, targetFatG: 70.0
        );
      });

      if (log.totalCalories > maxCal) maxCal = log.totalCalories;
      if (log.targetCalories > maxCal) maxCal = log.targetCalories;

      calorieBarGroups.add(
        BarChartGroupData(
          x: 6 - i,
          barRods: [
            BarChartRodData(
              toY: log.totalCalories,
              color: AppColors.primary,
              width: 12,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(3), topRight: Radius.circular(3)),
            ),
            BarChartRodData(
              toY: log.targetCalories,
              color: Colors.white24,
              width: 6,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Nutrition Analytics'),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(24.0),
                physics: const BouncingScrollPhysics(),
                children: [
                  // ADHERENCE GAUGES CARD
                  Card(
                    color: AppColors.card,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Nutrition Adherence (Last 30 Days)',
                              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildAdherenceRing('Calories', _calorieAdherence, AppColors.primary),
                              _buildAdherenceRing('Protein', _proteinAdherence, AppColors.success),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // STREAK CARD
                  Card(
                    color: AppColors.card,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          const Icon(Icons.local_fire_department, color: AppColors.warning, size: 40),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$_streakDays Days Consistency Streak',
                                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              const Text('Log meals or water consecutively to grow your streak.',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // CALORIE CHART
                  Card(
                    color: AppColors.card,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Calorie intake vs Target (Last 7 Days)',
                              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 24),
                          AspectRatio(
                            aspectRatio: 1.5,
                            child: BarChart(
                              BarChartData(
                                barGroups: calorieBarGroups,
                                gridData: const FlGridData(show: false),
                                borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(
                                  show: true,
                                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        final idx = value.toInt();
                                        if (idx >= 0 && idx < 7) {
                                          final date = now.subtract(Duration(days: 6 - idx));
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(labelFormatter.format(date),
                                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                                          );
                                        }
                                        return const Text('');
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAdherenceRing(String label, double val, Color color) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          width: 80,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(value: val, color: color, radius: 10, showTitle: false),
                PieChartSectionData(value: 100 - val, color: Colors.white10, radius: 10, showTitle: false),
              ],
              centerSpaceRadius: 28,
              sectionsSpace: 0,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text("${val.round()}%", style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }
}
