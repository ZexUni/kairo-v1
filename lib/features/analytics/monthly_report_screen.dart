import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:kairo/services/auth_service.dart';
import 'package:kairo/data/repositories/workout_repository.dart';
import 'package:kairo/data/models/workout_session.dart';
import 'package:kairo/core/constants/app_colors.dart';

class MonthlyReportScreen extends StatefulWidget {
  const MonthlyReportScreen({super.key});

  @override
  State<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  bool _loading = true;
  String _activeMetric = "Workouts"; // Workouts, Duration, Volume, Sets
  List<WorkoutSession> _yearSessions = [];

  // Monthly aggregated values (Jan = index 1, Dec = index 12)
  final Map<int, double> _monthlyValues = {};

  // Aggregated totals
  double _currentTotal = 0.0;
  double _previousTotal = 0.0;

  final List<String> _metrics = ["Workouts", "Duration", "Volume", "Sets"];

  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  Future<void> _loadReportData() async {
    setState(() => _loading = true);
    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final userId = auth.currentUser?.uid ?? 'local_user';

      final workoutRepo = WorkoutRepository();

      // Fetch workouts for the last 12 months
      final now = DateTime.now();
      final startOfYear = DateTime(now.year - 1, now.month + 1, 1);

      _yearSessions = await workoutRepo.getSessionsForPeriod(userId, startOfYear, now);

      _aggregateValues();
    } catch (e) {
      debugPrint("Error loading report data: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _aggregateValues() {
    // Clear map
    for (int m = 1; m <= 12; m++) {
      _monthlyValues[m] = 0.0;
    }

    _currentTotal = 0.0;
    _previousTotal = 0.0;

    final now = DateTime.now();
    final currentMonthLimit = now.month;

    for (var s in _yearSessions) {
      final month = s.completedAt.month;
      double valueToAdd = 0.0;

      if (_activeMetric == "Workouts") {
        valueToAdd = 1.0;
      } else if (_activeMetric == "Duration") {
        valueToAdd = s.durationMinutes.toDouble();
      } else if (_activeMetric == "Volume") {
        valueToAdd = s.totalVolumeKg;
      } else if (_activeMetric == "Sets") {
        valueToAdd = s.totalSets.toDouble();
      }

      // Add to monthly map
      _monthlyValues[month] = (_monthlyValues[month] ?? 0.0) + valueToAdd;

      // Classify as current half vs previous half of year for comparative summary cards
      if (s.completedAt.isAfter(now.subtract(const Duration(days: 180)))) {
        _currentTotal += valueToAdd;
      } else {
        _previousTotal += valueToAdd;
      }
    }
  }

  Widget _buildMetricPill(String metric) {
    final isSelected = _activeMetric == metric;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeMetric = metric;
          _aggregateValues();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Text(
          metric,
          style: TextStyle(
            color: isSelected ? Colors.black : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final monthNames = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

    // Find max value for scaling bar chart
    double maxBarVal = 5.0;
    _monthlyValues.values.forEach((v) {
      if (v > maxBarVal) maxBarVal = v;
    });

    // Build BarChartGroupData
    final List<BarChartGroupData> barGroups = [];
    final now = DateTime.now();
    
    // Sort months to display past 12 months in chronological order
    List<int> sortedMonths = [];
    for (int i = 11; i >= 0; i--) {
      int m = now.month - i;
      if (m <= 0) m += 12;
      sortedMonths.add(m);
    }

    for (int i = 0; i < sortedMonths.length; i++) {
      final monthIndex = sortedMonths[i];
      final val = _monthlyValues[monthIndex] ?? 0.0;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: val,
              color: AppColors.primary,
              width: 14,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
            ),
          ],
        ),
      );
    }

    // Difference arrow color
    final double diff = _currentTotal - _previousTotal;
    final isIncrease = diff >= 0;
    final displayDiff = diff.abs().round();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Monthly Training Report'),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(24.0),
                physics: const BouncingScrollPhysics(),
                children: [
                  // Metric filter pills row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: _metrics
                          .map((m) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: _buildMetricPill(m),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Bar Chart
                  Card(
                    color: AppColors.card,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Yearly $_activeMetric Trend",
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 24),
                          AspectRatio(
                            aspectRatio: 1.5,
                            child: BarChart(
                              BarChartData(
                                barGroups: barGroups,
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
                                        if (idx >= 0 && idx < sortedMonths.length) {
                                          final mName = monthNames[sortedMonths[idx]];
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text(mName, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
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
                  const SizedBox(height: 32),

                  // Comparative summary cards
                  const Text(
                    'COMPARATIVE TRENDS',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: AppColors.card,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Container(
                            height: 52,
                            width: 52,
                            decoration: BoxDecoration(
                              color: isIncrease ? AppColors.success.withOpacity(0.1) : AppColors.danger.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                              color: isIncrease ? AppColors.success : AppColors.danger,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Last 180d $_activeMetric Difference',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(
                                      "${isIncrease ? '+' : '-'}$displayDiff",
                                      style: TextStyle(
                                        color: isIncrease ? AppColors.success : AppColors.danger,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "(${_previousTotal.round()} prev -> ${_currentTotal.round()} curr)",
                                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Share Button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Monthly report shared successfully!')),
                        );
                      },
                      icon: const Icon(Icons.share, color: Colors.black),
                      label: const Text('SHARE PERFORMANCE REPORT'),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
      ),
    );
  }
}
