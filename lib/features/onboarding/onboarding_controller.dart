import 'package:flutter/material.dart';
import 'package:kairo/data/models/user_profile.dart';
import 'package:kairo/data/models/body_measurements.dart';
import 'package:kairo/data/models/lifestyle_assessment.dart';
import 'package:kairo/data/models/performance_assessment.dart';
import 'package:kairo/data/models/physiology_snapshot.dart';
import 'package:kairo/data/repositories/user_repository.dart';
import 'package:kairo/services/auth_service.dart';
import 'package:kairo/services/physiology_engine.dart';

class OnboardingController extends ChangeNotifier {
  int currentStep = 0; // 0 to 7 (translates to step 1 to 8)

  // Demographics
  String name = '';
  int age = 25;
  String gender = 'Male';
  double heightCm = 175.0;
  double weightKg = 70.0;

  // Measurements
  double neckCm = 38.0;
  double shouldersCm = 115.0;
  double chestCm = 100.0;
  double backWidthCm = 45.0;
  double bicepsCm = 35.0;
  double forearmsCm = 28.0;
  double waistCm = 80.0;
  double glutesCm = 90.0;
  double thighsCm = 55.0;
  double calvesCm = 36.0;

  // QNAs (1-5 sliders, 10 questions each)
  List<double> nutritionAnswers = List.filled(10, 3.0);
  List<double> sleepAnswers = List.filled(10, 3.0);
  List<double> activityAnswers = List.filled(10, 3.0);
  List<double> stressAnswers = List.filled(10, 3.0);

  // Equipment
  EquipmentMode equipmentMode = EquipmentMode.fullGym;

  // Exercise test
  int maxPushups = 20;
  int maxPullups = 5;
  int maxSquats = 30;
  int plankSeconds = 60;

  void nextStep() {
    if (currentStep < 7) {
      currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  Future<void> completeOnboarding(BuildContext context) async {
    final userId = AuthService().currentUser?.uid ?? 'local_user';

    // 1. Create and Save User Profile
    // goal based on some simple questions, default to recomp or select in UI later
    // Let's deduce primaryGoal:
    // If they score low on nutrition / high stress, recomp, or simple logic:
    // If weight is high, cut. If weight is low, bulk. Else recomp.
    final bmi = weightKg / ((heightCm / 100.0) * (heightCm / 100.0));
    PrimaryGoal goal = PrimaryGoal.recomp;
    if (bmi > 25.0) {
      goal = PrimaryGoal.cut;
    } else if (bmi < 19.0) {
      goal = PrimaryGoal.bulk;
    }

    final profile = UserProfile(
      id: userId,
      name: name,
      age: age,
      gender: gender,
      heightCm: heightCm,
      weightKg: weightKg,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      equipmentMode: equipmentMode,
      primaryGoal: goal,
    );

    // 2. Create and Save Body Measurements
    final measurements = BodyMeasurements(
      userId: userId,
      measuredAt: DateTime.now(),
      neckCm: neckCm,
      shouldersCm: shouldersCm,
      chestCm: chestCm,
      backWidthCm: backWidthCm,
      bicepsCm: bicepsCm,
      forearmsCm: forearmsCm,
      waistCm: waistCm,
      glutesCm: glutesCm,
      thighsCm: thighsCm,
      calvesCm: calvesCm,
    );

    // 3. Create and Save Lifestyle Assessment
    // Calculate category scores (0-100 or 1-5)
    // Lifestyle assessment takes proteinScore (0-100), others
    // We average our QNA lists
    final proteinScoreVal = nutritionAnswers[0] * 20.0; // Q1: protein frequency -> 0-100
    final mealFrequencyVal = nutritionAnswers[1];
    final processedVal = nutritionAnswers[2];
    final hydrationVal = nutritionAnswers[3];
    final vegetableVal = nutritionAnswers[4];

    final sleepDur = sleepAnswers[0];
    final sleepCons = sleepAnswers[1];
    final sleepQual = sleepAnswers[9];

    final movement = activityAnswers[0];
    final cardio = activityAnswers[1];
    final sedentary = activityAnswers[2];

    final workStress = stressAnswers[0];
    final emotionalStress = stressAnswers[1];
    final recoveryHabits = stressAnswers[9];

    final lifestyle = LifestyleAssessment(
      userId: userId,
      assessedAt: DateTime.now(),
      proteinScore: proteinScoreVal,
      mealFrequencyScore: mealFrequencyVal,
      processedFoodScore: processedVal,
      hydrationScore: hydrationVal,
      vegetableScore: vegetableVal,
      sleepDurationScore: sleepDur,
      sleepConsistencyScore: sleepCons,
      sleepQualityScore: sleepQual,
      dailyMovementScore: movement,
      cardioScore: cardio,
      sedentaryScore: sedentary,
      workStressScore: workStress,
      emotionalStressScore: emotionalStress,
      recoveryHabitsScore: recoveryHabits,
    );

    // 4. Create and Save Performance Assessment
    final performance = PerformanceAssessment(
      userId: userId,
      assessedAt: DateTime.now(),
      maxPushups: maxPushups,
      maxPullups: maxPullups,
      maxSquats: maxSquats,
      plankSeconds: plankSeconds,
    );

    // 5. Save all to database
    final userRepo = UserRepository();
    await userRepo.saveProfile(profile);
    await userRepo.saveMeasurements(measurements);
    await userRepo.saveLifestyle(lifestyle);
    await userRepo.savePerformance(performance);

    // 6. Compute initial PhysiologySnapshot
    final physiologyEngine = PhysiologyEngine();
    final snapshot = physiologyEngine.computeSnapshot(
      profile: profile,
      measurements: measurements,
      lifestyle: lifestyle,
      performance: performance,
      latestCheckin: null,
    );
    await userRepo.saveSnapshot(snapshot);

    // 7. Sync profile to firestore
    final authService = AuthService();
    await authService.syncProfileToFirestore(userId, profile.toMap());

    // Notify listeners
    physiologyEngine.triggerUpdate();
  }
}
