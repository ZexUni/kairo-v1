import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:kairo/core/constants/archetype_constants.dart';
import 'package:kairo/services/auth_service.dart';
import 'package:kairo/services/physiology_engine.dart';
import 'package:kairo/services/workout_engine.dart';
import 'package:kairo/services/nutrition_engine.dart';
import 'package:kairo/data/repositories/user_repository.dart';
import 'package:kairo/data/repositories/recovery_repository.dart';
import 'package:kairo/data/repositories/nutrition_repository.dart';
import 'package:kairo/data/models/user_profile.dart';
import 'package:kairo/data/models/body_measurements.dart';
import 'package:kairo/data/models/lifestyle_assessment.dart';
import 'package:kairo/data/models/performance_assessment.dart';
import 'package:kairo/data/models/recovery_checkin.dart';
import 'package:kairo/data/models/physiology_snapshot.dart';
import 'package:kairo/data/models/nutrition_log.dart';
import 'package:kairo/core/constants/app_colors.dart';
import 'package:kairo/widgets/physiology_state_card.dart';
import 'package:kairo/widgets/macro_progress_bar.dart';
import 'package:kairo/widgets/bottom_nav_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _loading = true;
  UserProfile? _profile;
  BodyMeasurements? _measurements;
  LifestyleAssessment? _lifestyle;
  PerformanceAssessment? _performance;
  RecoveryCheckin? _latestCheckin;
  NutritionLog? _nutritionLog;
  PhysiologySnapshot? _snapshot;
  WorkoutPlan? _workoutPlan;
  NutritionTargets? _nutritionTargets;
  bool _checkedInToday = false;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _loading = true);
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final userId = authService.currentUser?.uid ?? 'local_user';

      final userRepo = UserRepository();
      final recoveryRepo = RecoveryRepository();
      final nutritionRepo = NutritionRepository();

      _profile = await userRepo.getProfile(userId);
      _measurements = await userRepo.getLatestMeasurements(userId);
      _lifestyle = await userRepo.getLatestLifestyle(userId);
      _performance = await userRepo.getLatestPerformance(userId);
      _latestCheckin = await recoveryRepo.getLatestCheckin(userId);
      _nutritionLog = await nutritionRepo.getLogForDate(userId, DateTime.now());

      if (_profile != null && _measurements != null && _lifestyle != null && _performance != null) {
        final physiologyEngine = PhysiologyEngine();
        _snapshot = physiologyEngine.computeSnapshot(
          profile: _profile!,
          measurements: _measurements!,
          lifestyle: _lifestyle!,
          performance: _performance!,
          latestCheckin: _latestCheckin,
        );

        final workoutEngine = WorkoutEngine();
        _workoutPlan = workoutEngine.generatePlan(_snapshot!, _profile!, _measurements!);

        final nutritionEngine = NutritionEngine();
        _nutritionTargets = nutritionEngine.calculateTargets(_snapshot!, _profile!, _lifestyle!);
      }

      if (_latestCheckin != null) {
        final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final checkinStr = DateFormat('yyyy-MM-dd').format(_latestCheckin!.checkinAt);
        _checkedInToday = (todayStr == checkinStr);
      } else {
        _checkedInToday = false;
      }
    } catch (e) {
      debugPrint("Error loading dashboard: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_profile == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'No Profile Found',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'You need to complete onboarding to initialize your physiological settings.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/onboarding'),
                child: const Text('START ONBOARDING'),
              ),
            ],
          ),
        ),
      );
    }

    // Calculations
    final recoveryVal = _snapshot?.recoveryScore ?? 0.5;
    final stressVal = _snapshot?.stressScore ?? 0.3;
    final readinessScore = ((recoveryVal - (stressVal * 0.5)) * 100.0).clamp(0.0, 100.0).round();

    Color readinessColor = AppColors.danger;
    if (readinessScore > 70) {
      readinessColor = AppColors.success;
    } else if (readinessScore >= 40) {
      readinessColor = AppColors.warning;
    }

    final archetypeText = _snapshot != null
        ? _snapshot!.archetype.name.replaceAll(RegExp(r'(?=[A-Z])'), ' ').trim().toUpperCase()
        : 'CLASSIC BODYBUILDER';

    final recommendationText = PhysiologyEngine.getTrainingStateRecommendation(
      _snapshot?.anabolicScore ?? 0.5,
      _snapshot?.recoveryScore ?? 0.5,
      _snapshot?.metabolicScore ?? 0.5,
      _snapshot?.bodyFatPercent ?? 15.0,
    );

    // Nutrition targets vs consumed
    final targetCal = _nutritionTargets?.calories ?? 2000.0;
    final targetProt = _nutritionTargets?.proteinG ?? 150.0;
    final targetCarb = _nutritionTargets?.carbsG ?? 250.0;
    final targetFat = _nutritionTargets?.fatG ?? 70.0;

    final consumedCal = _nutritionLog?.totalCalories ?? 0.0;
    final consumedProt = _nutritionLog?.totalProteinG ?? 0.0;
    final consumedCarb = _nutritionLog?.totalCarbsG ?? 0.0;
    final consumedFat = _nutritionLog?.totalFatG ?? 0.0;
    final consumedWater = _nutritionLog?.waterMl ?? 0.0;

    // Underdeveloped muscles gaps computation
    final List<Map<String, dynamic>> muscleGaps = [];
    if (_measurements != null) {
      final isMale = !_profile!.gender.toLowerCase().startsWith('f');
      final Map<String, double> targets = {
        'Chest': isMale ? ArchetypeConstants.maleChestTarget : ArchetypeConstants.femaleChestTarget,
        'Shoulders': isMale ? ArchetypeConstants.maleShouldersTarget : ArchetypeConstants.femaleShouldersTarget,
        'Biceps': isMale ? ArchetypeConstants.maleBicepsTarget : ArchetypeConstants.femaleBicepsTarget,
        'Waist': isMale ? ArchetypeConstants.maleWaistTarget : ArchetypeConstants.femaleWaistTarget,
        'Thighs': isMale ? ArchetypeConstants.maleThighsTarget : ArchetypeConstants.femaleThighsTarget,
        'Calves': isMale ? ArchetypeConstants.maleCalvesTarget : ArchetypeConstants.femaleCalvesTarget,
      };
      
      targets.forEach((key, tarValue) {
        double currentVal = 0.0;
        if (key == 'Chest') currentVal = _measurements!.chestCm;
        if (key == 'Shoulders') currentVal = _measurements!.shouldersCm;
        if (key == 'Biceps') currentVal = _measurements!.bicepsCm;
        if (key == 'Waist') currentVal = _measurements!.waistCm;
        if (key == 'Thighs') currentVal = _measurements!.thighsCm;
        if (key == 'Calves') currentVal = _measurements!.calvesCm;

        final gap = key == 'Waist' ? max(0.0, currentVal - tarValue) : max(0.0, tarValue - currentVal);
        if (gap > 0) {
          muscleGaps.add({'muscle': key, 'gap': gap});
        }
      });
      // Sort gaps descending
      muscleGaps.sort((a, b) => (b['gap'] as double).compareTo(a['gap'] as double));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          color: AppColors.primary,
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_getGreeting()}, ${_profile!.name}",
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEEE, MMMM d').format(DateTime.now()),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      archetypeText,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // DAILY CHECK-IN ALERT
              if (!_checkedInToday) ...[
                GestureDetector(
                  onTap: () => context.push('/recovery').then((_) => _loadDashboardData()),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7B61FF), Color(0xFF4B8BFF)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.health_and_safety, color: Colors.black, size: 30),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "RECOVERY CHECK-IN",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Submit your check-in to analyze readiness.",
                                style: TextStyle(color: Colors.black87, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // PHYSIOLOGY STATE ROW (horizontal circular indicators)
              const Text(
                'PHYSIOLOGICAL SNAPSHOT',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    PhysiologyStateCard(
                      label: 'ANABOLIC',
                      score: _snapshot?.anabolicScore ?? 0.5,
                      color: AppColors.primary,
                    ),
                    PhysiologyStateCard(
                      label: 'METABOLIC',
                      score: _snapshot?.metabolicScore ?? 0.5,
                      color: AppColors.success,
                    ),
                    PhysiologyStateCard(
                      label: 'RECOVERY',
                      score: _snapshot?.recoveryScore ?? 0.5,
                      color: AppColors.secondary,
                    ),
                    PhysiologyStateCard(
                      label: 'STRESS',
                      score: _snapshot?.stressScore ?? 0.3,
                      color: AppColors.danger,
                      invert: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // READINESS CARD
              Card(
                color: AppColors.card,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Readiness Score",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: readinessColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "$readinessScore / 100",
                              style: TextStyle(
                                color: readinessColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        recommendationText,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // PHYSIQUE CARD
              Card(
                color: AppColors.card,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Physique Completion",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            archetypeText,
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            "${(_snapshot?.physiqueCompletionPercent ?? 0.0).round()}% complete",
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (_snapshot?.physiqueCompletionPercent ?? 0.0) / 100.0,
                          minHeight: 10,
                          backgroundColor: Colors.white12,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // DAILY NUTRITION SUMMARY
              Card(
                color: AppColors.card,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Daily Nutrition Summary",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward, color: AppColors.primary),
                            onPressed: () => context.go('/nutrition'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      MacroProgressBar(
                        label: 'Calories',
                        consumed: consumedCal,
                        target: targetCal,
                        unit: 'kcal',
                        color: AppColors.primary,
                      ),
                      MacroProgressBar(
                        label: 'Protein',
                        consumed: consumedProt,
                        target: targetProt,
                        unit: 'g',
                        color: AppColors.success,
                      ),
                      MacroProgressBar(
                        label: 'Carbs',
                        consumed: consumedCarb,
                        target: targetCarb,
                        unit: 'g',
                        color: AppColors.warning,
                      ),
                      MacroProgressBar(
                        label: 'Fat',
                        consumed: consumedFat,
                        target: targetFat,
                        unit: 'g',
                        color: AppColors.danger,
                      ),
                      MacroProgressBar(
                        label: 'Water Intake',
                        consumed: consumedWater,
                        target: 3000.0, // default target
                        unit: 'ml',
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // TODAY'S WORKOUT CARD
              if (_workoutPlan != null) ...[
                Card(
                  color: AppColors.card,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Today's Plan",
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _workoutPlan!.splitName,
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Recommended exercises targeting your priority muscle groups.",
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        ..._workoutPlan!.days.take(1).map((day) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  day.dayName,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...day.exercises.take(3).map((e) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 16),
                                          const SizedBox(width: 8),
                                          Text(
                                            e.name,
                                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    )),
                                if (day.exercises.length > 3)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      "+ ${day.exercises.length - 3} more exercises",
                                      style: const TextStyle(color: AppColors.primary, fontSize: 12),
                                    ),
                                  ),
                              ],
                            )),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () => context.go('/workout'),
                            child: const Text('START TRAINING'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // MUSCLE PRIORITY ALERTS
              if (muscleGaps.isNotEmpty) ...[
                const Text(
                  'MUSCLE PRIORITY ALERTS',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                ...muscleGaps.take(3).map((gapMap) {
                  final double gapVal = gapMap['gap'];
                  final String muscleName = gapMap['muscle'];
                  String priorityText = "LOW PRIORITY";
                  Color badgeColor = AppColors.success;
                  if (gapVal > 5.0) {
                    priorityText = "HIGH PRIORITY";
                    badgeColor = AppColors.danger;
                  } else if (gapVal >= 2.0) {
                    priorityText = "MODERATE PRIORITY";
                    badgeColor = AppColors.warning;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$muscleName — ${gapVal.toStringAsFixed(1)}cm gap",
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: badgeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            priorityText,
                            style: TextStyle(
                              color: badgeColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 40),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}