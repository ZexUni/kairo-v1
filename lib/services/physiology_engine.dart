import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kairo/data/models/user_profile.dart';
import 'package:kairo/data/models/body_measurements.dart';
import 'package:kairo/data/models/lifestyle_assessment.dart';
import 'package:kairo/data/models/performance_assessment.dart';
import 'package:kairo/data/models/recovery_checkin.dart';
import 'package:kairo/data/models/physiology_snapshot.dart';
import 'package:kairo/core/utils/physiology_formulas.dart';
import 'package:kairo/core/constants/archetype_constants.dart';

class PhysiologyEngine extends ChangeNotifier {
  // Singleton pattern
  static final PhysiologyEngine _instance = PhysiologyEngine._internal();
  factory PhysiologyEngine() => _instance;
  PhysiologyEngine._internal();

  /// Computes the physiology snapshot based on all available metrics
  PhysiologySnapshot computeSnapshot({
    required UserProfile profile,
    required BodyMeasurements measurements,
    required LifestyleAssessment lifestyle,
    required PerformanceAssessment performance,
    required RecoveryCheckin? latestCheckin,
  }) {
    final isMale = !profile.gender.toLowerCase().startsWith('f');

    // 1. Calculate Body Fat
    double bodyFatPercent;
    if (isMale) {
      bodyFatPercent = PhysiologyFormulas.calculateMaleBodyFat(
        waistCm: measurements.waistCm,
        neckCm: measurements.neckCm,
        heightCm: profile.heightCm,
      );
    } else {
      bodyFatPercent = PhysiologyFormulas.calculateFemaleBodyFat(
        waistCm: measurements.waistCm,
        hipCm: measurements.glutesCm, // use glutesCm as hipCm fallback
        neckCm: measurements.neckCm,
        heightCm: profile.heightCm,
      );
    }
    bodyFatPercent = bodyFatPercent.clamp(3.0, 50.0);

    // 2. Calculate LBM and FM
    final leanBodyMassKg = PhysiologyFormulas.calculateLBM(profile.weightKg, bodyFatPercent);
    final fatMassKg = profile.weightKg - leanBodyMassKg;

    // 3. Performance Score
    final perfScore = performance.overallScore; // 0.0 - 1.0

    // Sub-components scoring
    final sleepScore = latestCheckin != null
        ? ((latestCheckin.sleepHours.clamp(4.0, 10.0) - 4.0) / 6.0 * 0.4 + (latestCheckin.sleepQuality / 5.0) * 0.6)
        : ((lifestyle.sleepDurationScore / 5.0 * 0.5) + (lifestyle.sleepQualityScore / 5.0 * 0.5));

    final fatigueScore = latestCheckin != null
        ? ((latestCheckin.sorenessLevel / 5.0 * 0.6) + (latestCheckin.stressLevel / 5.0 * 0.4))
        : ((lifestyle.workStressScore / 5.0 * 0.5) + (lifestyle.emotionalStressScore / 5.0 * 0.5));

    final hydrationScore = latestCheckin != null
        ? (latestCheckin.hydrationLevel / 5.0)
        : (lifestyle.hydrationScore / 5.0);

    // Diet Score: protein contribution + processed foods (lower processed = higher score) + vegetable intake
    final dietScore = (lifestyle.proteinScore / 100.0 * 0.4 +
        (1.0 - (lifestyle.processedFoodScore / 5.0)) * 0.3 +
        (lifestyle.vegetableScore / 5.0) * 0.3).clamp(0.0, 1.0);

    final bodyFatScore = isMale
        ? (bodyFatPercent < 15 ? 1.0 : (1.0 - (bodyFatPercent - 15) / 25.0))
        : (bodyFatPercent < 22 ? 1.0 : (1.0 - (bodyFatPercent - 22) / 25.0));
    final bodyScore = bodyFatScore.clamp(0.0, 1.0);

    // 4. Calculate Physiological State Scores
    // RS = (sleepScore * 0.30) + ((1 - fatigueScore) * 0.15) + (hydrationScore * 0.10) + (dietScore * 0.15) + (bodyScore * 0.10) + (perfScore * 0.20)
    final recoveryScore = (sleepScore * 0.30) +
        ((1.0 - fatigueScore).clamp(0.0, 1.0) * 0.15) +
        (hydrationScore * 0.10) +
        (dietScore * 0.15) +
        (bodyScore * 0.10) +
        (perfScore * 0.20);

    // SS = (stressInput * 0.40) + ((1 - sleepScore) * 0.20) + (bodyFatScore * 0.15) + ((1 - dietScore) * 0.15) + ((1 - perfScore) * 0.10)
    final stressInput = latestCheckin != null
        ? (latestCheckin.stressLevel / 5.0)
        : ((lifestyle.workStressScore + lifestyle.emotionalStressScore) / 10.0);

    final stressScore = (stressInput * 0.40) +
        ((1.0 - sleepScore).clamp(0.0, 1.0) * 0.20) +
        (bodyFatScore * 0.15) +
        ((1.0 - dietScore).clamp(0.0, 1.0) * 0.15) +
        ((1.0 - perfScore).clamp(0.0, 1.0) * 0.10);

    // AS = (proteinScore * 0.30) + (calorieScore * 0.20) + (RS * 0.15) + (muscleScore * 0.10) + (perfScore * 0.10) + (ageScore * 0.10) + (genderBonus * 0.05)
    final proteinScore = lifestyle.proteinScore / 100.0;
    final calorieScore = profile.primaryGoal == PrimaryGoal.bulk
        ? 1.0
        : (profile.primaryGoal == PrimaryGoal.cut ? 0.3 : 0.7);
    final muscleScore = bodyScore;
    final ageScore = profile.age < 30 ? 1.0 : (profile.age < 50 ? 0.8 : 0.5);
    final genderBonus = isMale ? 0.05 : 0.0; // male slight hormonal recovery rate weight bias

    final anabolicScore = (proteinScore * 0.30) +
        (calorieScore * 0.20) +
        (recoveryScore * 0.15) +
        (muscleScore * 0.10) +
        (perfScore * 0.10) +
        (ageScore * 0.10) +
        genderBonus;

    // MS = (activityScore * 0.30) + ((1 - bodyFatScore) * 0.20) + (dietScore * 0.15) + (hydrationScore * 0.10) + (perfScore * 0.15) + (energyScore * 0.10)
    final activityScore = (lifestyle.dailyMovementScore / 5.0 * 0.5 + lifestyle.cardioScore / 5.0 * 0.5);
    final energyScore = latestCheckin != null
        ? (latestCheckin.energyLevel / 5.0)
        : (1.0 - lifestyle.sedentaryScore / 5.0);

    final metabolicScore = (activityScore * 0.30) +
        ((1.0 - bodyFatScore).clamp(0.0, 1.0) * 0.20) +
        (dietScore * 0.15) +
        (hydrationScore * 0.10) +
        (perfScore * 0.15) +
        (energyScore * 0.10);

    // 5. Archetype Detection
    final swr = measurements.shoulderWaistRatio;
    final ffmi = PhysiologyFormulas.calculateFFMI(lbmKg: leanBodyMassKg, heightCm: profile.heightCm);

    PhysiqueArchetype archetype = PhysiqueArchetype.classicBodybuilder;
    if (ffmi > 25.0) {
      archetype = PhysiqueArchetype.massMonster;
    } else if (swr > 1.6) {
      archetype = PhysiqueArchetype.vTaper;
    } else if (perfScore > 0.75 && measurements.chestWaistRatio > 1.25) {
      archetype = PhysiqueArchetype.powerAthlete;
    } else if ((isMale && bodyFatPercent < 12.0) || (!isMale && bodyFatPercent < 20.0)) {
      archetype = PhysiqueArchetype.leanWarrior;
    } else if (swr >= 1.4 && swr <= 1.6) {
      archetype = PhysiqueArchetype.classicBodybuilder;
    }

    // 6. Physique Completion %
    final physiqueCompletion = _calculatePhysiqueCompletion(measurements, isMale);

    return PhysiologySnapshot(
      userId: profile.id,
      snapshotAt: DateTime.now(),
      bodyFatPercent: bodyFatPercent,
      leanBodyMassKg: leanBodyMassKg,
      fatMassKg: fatMassKg,
      anabolicScore: anabolicScore.clamp(0.0, 1.0),
      metabolicScore: metabolicScore.clamp(0.0, 1.0),
      stressScore: stressScore.clamp(0.0, 1.0),
      recoveryScore: recoveryScore.clamp(0.0, 1.0),
      archetype: archetype,
      physiqueCompletionPercent: physiqueCompletion,
    );
  }

  /// Calculates percentage completion toward targets
  double _calculatePhysiqueCompletion(BodyMeasurements m, bool isMale) {
    double neckTar = isMale ? ArchetypeConstants.maleNeckTarget : ArchetypeConstants.femaleNeckTarget;
    double shouldersTar = isMale ? ArchetypeConstants.maleShouldersTarget : ArchetypeConstants.femaleShouldersTarget;
    double chestTar = isMale ? ArchetypeConstants.maleChestTarget : ArchetypeConstants.femaleChestTarget;
    double bicepsTar = isMale ? ArchetypeConstants.maleBicepsTarget : ArchetypeConstants.femaleBicepsTarget;
    double waistTar = isMale ? ArchetypeConstants.maleWaistTarget : ArchetypeConstants.femaleWaistTarget;
    double thighsTar = isMale ? ArchetypeConstants.maleThighsTarget : ArchetypeConstants.femaleThighsTarget;
    double calvesTar = isMale ? ArchetypeConstants.maleCalvesTarget : ArchetypeConstants.femaleCalvesTarget;

    // Gaps (smaller waist is better, larger others are better)
    double neckGap = max(0.0, neckTar - m.neckCm);
    double shouldersGap = max(0.0, shouldersTar - m.shouldersCm);
    double chestGap = max(0.0, chestTar - m.chestCm);
    double bicepsGap = max(0.0, bicepsTar - m.bicepsCm);
    double waistGap = max(0.0, m.waistCm - waistTar);
    double thighsGap = max(0.0, thighsTar - m.thighsCm);
    double calvesGap = max(0.0, calvesTar - m.calvesCm);

    double neckComp = (1.0 - (neckGap / neckTar)).clamp(0.0, 1.0);
    double shouldersComp = (1.0 - (shouldersGap / shouldersTar)).clamp(0.0, 1.0);
    double chestComp = (1.0 - (chestGap / chestTar)).clamp(0.0, 1.0);
    double bicepsComp = (1.0 - (bicepsGap / bicepsTar)).clamp(0.0, 1.0);
    double waistComp = (1.0 - (waistGap / m.waistCm)).clamp(0.0, 1.0);
    double thighsComp = (1.0 - (thighsGap / thighsTar)).clamp(0.0, 1.0);
    double calvesComp = (1.0 - (calvesGap / calvesTar)).clamp(0.0, 1.0);

    return (neckComp + shouldersComp + chestComp + bicepsComp + waistComp + thighsComp + calvesComp) / 7.0 * 100.0;
  }

  /// Exposes current recommendation text derived from physiological state scores
  static String getTrainingStateRecommendation(double anabolicScore, double recoveryScore, double metabolicScore, double bodyFatPercent) {
    if (anabolicScore > 0.80 && recoveryScore > 0.75) {
      return "HyperAnabolic - You're primed. 20-30 weekly sets, heavy compounds, calorie surplus.";
    } else if (anabolicScore >= 0.60 && recoveryScore >= 0.60) {
      return "Balanced - Moderate hypertrophy focus. 15-20 weekly sets, standard hypertrophy.";
    } else if (metabolicScore > 0.75 && bodyFatPercent > 20.0) {
      return "Metabolic - Conditioning focus. Higher reps, circuit style, fat loss priority.";
    } else if (recoveryScore < 0.50) {
      return "Recovery Priority - Fatigued state. Reduce volume by 50%, focus on mobility & active rest.";
    }
    return "Balanced - Stick to the baseline hypertrophic schedule.";
  }

  void triggerUpdate() {
    notifyListeners();
  }
}
