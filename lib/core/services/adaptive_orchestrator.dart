import 'package:kairo/core/repositories/user_profile_repository.dart';
import 'package:kairo/core/services/adaptive_engine.dart';
import 'package:kairo/core/services/decision_engine.dart';
import 'package:kairo/core/services/nutrition_engine.dart';
import 'package:kairo/core/services/personalization_engine.dart';
import 'package:kairo/core/services/physiology_engine.dart';
import 'package:kairo/core/services/progression_engine.dart';
import 'package:kairo/core/services/recovery_engine.dart';
import 'package:kairo/core/services/split_engine.dart';
import 'package:kairo/core/services/workout_generator.dart';
import 'package:kairo/models/onboarding_data.dart';
import 'package:kairo/models/recovery_input.dart';

/// Central decision pipeline: transforms onboarding inputs + recovery state
/// into prescriptions across all adaptive engines.
class AdaptiveOrchestrator {
  static final RecoveryInput _baselineRecovery = RecoveryInput(
    sleepHours: 7,
    soreness: 3,
    stress: 3,
  );

  /// Runs the full physiological analysis and prescription pipeline.
  static OnboardingData analyze(
    OnboardingData data, {
    RecoveryInput? recoveryInput,
  }) {
    final recovery = recoveryInput ?? data.latestRecovery ?? _baselineRecovery;

    final heightMeters = data.height / 100;
    final bmi = data.weight / (heightMeters * heightMeters);

    data.bmi = bmi;
    data.bodyCategory = _bodyCategoryFromBmi(bmi);
    data.recommendedProgram = _recommendedProgram(data.physiqueGoal);

    data.generatedWorkout = WorkoutGenerator.generateWorkout(data);

    data.trainingSplit = SplitEngine.generateSplit(data.experienceLevel);
    data.weeklySchedule = SplitEngine.generateSchedule(data.trainingSplit);
    data.progressionRecommendations = ProgressionEngine.generateRecommendations(
      data.experienceLevel,
    );

    data.readinessScore = RecoveryEngine.calculateReadiness(
      sleepHours: recovery.sleepHours,
      soreness: recovery.soreness,
      stress: recovery.stress,
    );
    data.readinessState = RecoveryEngine.readinessState(data.readinessScore);
    data.physiologicalState = PhysiologyEngine.generateState(
      readiness: data.readinessScore,
    );

    data.nutritionPlan = NutritionEngine.generatePlan(
      weight: data.weight,
      goal: data.physiqueGoal,
      dietType: data.dietPreference,
    );

    data.userIdentity = PersonalizationEngine.userIdentity(data);
    data.adaptiveInsight = AdaptiveEngine.generateAdaptiveInsight(data);
    data.personalizedMessage = PersonalizationEngine.generateMessage(
      streak: data.streakDays,
      readiness: data.readinessScore,
    );
    data.dailyDecision = DecisionEngine.generateDailyDecision(data);

    data.latestRecovery = recovery;
    data.onboardingCompleted = true;
    data.lastAnalysisAt = DateTime.now().toIso8601String();

    return data;
  }

  /// Re-runs analysis and persists the updated profile.
  static Future<OnboardingData> analyzeAndPersist(
    OnboardingData data, {
    RecoveryInput? recoveryInput,
  }) async {
    final updated = analyze(data, recoveryInput: recoveryInput);

    await UserProfileRepository.save(updated);

    return updated;
  }

  static String _bodyCategoryFromBmi(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    }

    if (bmi < 25) {
      return 'Normal';
    }

    if (bmi < 30) {
      return 'Overweight';
    }

    return 'Obese';
  }

  static String _recommendedProgram(String physiqueGoal) {
    if (physiqueGoal == 'Bulk') {
      return 'Hypertrophy Focus';
    }

    if (physiqueGoal == 'Slim') {
      return 'Fat Loss Focus';
    }

    return 'Balanced Athletic';
  }
}
