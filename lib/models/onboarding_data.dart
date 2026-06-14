import 'package:kairo/models/nutrition_plan.dart';
import 'package:kairo/models/physiological_state.dart';
import 'package:kairo/models/recovery_input.dart';

class OnboardingData {
  // =========================
  // IDENTITY
  // =========================

  String name;

  int age;

  String gender;

  // =========================
  // BODY METRICS
  // =========================

  double height;

  double weight;

  double bmi;

  String bodyCategory;

  // =========================
  // GOALS
  // =========================

  String physiqueGoal;

  String trainingEnvironment;

  String experienceLevel;

  String dietPreference;

  // =========================
  // TRAINING SYSTEM
  // =========================

  List<String> generatedWorkout;

  String trainingSplit;

  List<String> weeklySchedule;

  List<String> progressionRecommendations;

  String recommendedProgram;

  // =========================
  // RECOVERY
  // =========================

  double readinessScore;

  String readinessState;

  PhysiologicalState physiologicalState;

  // =========================
  // HABITS
  // =========================

  int streakDays;

  int dailyCompletion;

  // =========================
  // NUTRITION
  // =========================

  NutritionPlan nutritionPlan;

  // =========================
  // AI SYSTEMS
  // =========================

  String adaptiveInsight;

  String personalizedMessage;

  String dailyDecision;

  // =========================
  // ADAPTIVE LIFECYCLE
  // =========================

  String userIdentity;

  bool onboardingCompleted;

  String lastAnalysisAt;

  RecoveryInput? latestRecovery;

  OnboardingData({
    this.name = '',

    this.age = 0,

    this.gender = '',

    this.height = 0,

    this.weight = 0,

    this.bmi = 0,

    this.bodyCategory = '',

    this.physiqueGoal = 'Balanced',

    this.trainingEnvironment = 'Full Gym',

    this.experienceLevel = 'Beginner',

    this.dietPreference = 'Non-Veg',

    this.generatedWorkout = const [],

    this.trainingSplit = '',

    this.weeklySchedule = const [],

    this.progressionRecommendations = const [],

    this.recommendedProgram = '',

    this.readinessScore = 0,

    this.readinessState = '',

    PhysiologicalState? physiologicalState,

    this.streakDays = 0,

    this.dailyCompletion = 0,

    NutritionPlan? nutritionPlan,

    this.adaptiveInsight = '',

    this.personalizedMessage = '',

    this.dailyDecision = '',

    this.userIdentity = '',

    this.onboardingCompleted = false,

    this.lastAnalysisAt = '',

    this.latestRecovery,
  }) : physiologicalState =
           physiologicalState ??
           PhysiologicalState(
             recovery: 0,

             fatigue: 0,

             readiness: 0,

             adaptation: 0,
           ),

       nutritionPlan =
           nutritionPlan ??
           NutritionPlan(
             calories: 0,

             protein: 0,

             carbs: 0,

             fats: 0,

             dietType: '',
           );

  // =========================
  // TO MAP
  // =========================

  Map<String, dynamic> toMap() {
    return {
      'name': name,

      'age': age,

      'gender': gender,

      'height': height,

      'weight': weight,

      'bmi': bmi,

      'bodyCategory': bodyCategory,

      'physiqueGoal': physiqueGoal,

      'trainingEnvironment': trainingEnvironment,

      'experienceLevel': experienceLevel,

      'dietPreference': dietPreference,

      'generatedWorkout': generatedWorkout,

      'trainingSplit': trainingSplit,

      'weeklySchedule': weeklySchedule,

      'progressionRecommendations': progressionRecommendations,

      'recommendedProgram': recommendedProgram,

      'readinessScore': readinessScore,

      'readinessState': readinessState,

      'physiologicalState': physiologicalState.toMap(),

      'streakDays': streakDays,

      'dailyCompletion': dailyCompletion,

      'nutritionPlan': nutritionPlan.toMap(),

      'adaptiveInsight': adaptiveInsight,

      'personalizedMessage': personalizedMessage,

      'dailyDecision': dailyDecision,

      'userIdentity': userIdentity,

      'onboardingCompleted': onboardingCompleted,

      'lastAnalysisAt': lastAnalysisAt,

      'latestRecovery': latestRecovery?.toMap(),
    };
  }

  // =========================
  // FROM MAP
  // =========================

  factory OnboardingData.fromMap(Map<String, dynamic> map) {
    return OnboardingData(
      name: map['name'] ?? '',

      age: map['age'] ?? 0,

      gender: map['gender'] ?? '',

      height: (map['height'] ?? 0).toDouble(),

      weight: (map['weight'] ?? 0).toDouble(),

      bmi: (map['bmi'] ?? 0).toDouble(),

      bodyCategory: map['bodyCategory'] ?? '',

      physiqueGoal: map['physiqueGoal'] ?? 'Balanced',

      trainingEnvironment: map['trainingEnvironment'] ?? 'Full Gym',

      experienceLevel: map['experienceLevel'] ?? 'Beginner',

      dietPreference: map['dietPreference'] ?? 'Non-Veg',

      generatedWorkout: List<String>.from(map['generatedWorkout'] ?? []),

      trainingSplit: map['trainingSplit'] ?? '',

      weeklySchedule: List<String>.from(map['weeklySchedule'] ?? []),

      progressionRecommendations: List<String>.from(
        map['progressionRecommendations'] ?? [],
      ),

      recommendedProgram: map['recommendedProgram'] ?? '',

      readinessScore: (map['readinessScore'] ?? 0).toDouble(),

      readinessState: map['readinessState'] ?? '',

      physiologicalState: PhysiologicalState.fromMap(
        map['physiologicalState'] ?? {},
      ),

      streakDays: map['streakDays'] ?? 0,

      dailyCompletion: map['dailyCompletion'] ?? 0,

      nutritionPlan: NutritionPlan.fromMap(map['nutritionPlan'] ?? {}),

      adaptiveInsight: map['adaptiveInsight'] ?? '',

      personalizedMessage: map['personalizedMessage'] ?? '',

      dailyDecision: map['dailyDecision'] ?? '',

      userIdentity: map['userIdentity'] ?? '',

      onboardingCompleted: map['onboardingCompleted'] ?? false,

      lastAnalysisAt: map['lastAnalysisAt'] ?? '',

      latestRecovery: map['latestRecovery'] != null
          ? RecoveryInput.fromMap(
              Map<String, dynamic>.from(map['latestRecovery']),
            )
          : null,
    );
  }

  // =========================
  // COPY WITH
  // =========================

  OnboardingData copyWith({
    String? name,

    int? age,

    String? gender,

    double? height,

    double? weight,

    double? bmi,

    String? bodyCategory,

    String? physiqueGoal,

    String? trainingEnvironment,

    String? experienceLevel,

    String? dietPreference,

    List<String>? generatedWorkout,

    String? trainingSplit,

    List<String>? weeklySchedule,

    List<String>? progressionRecommendations,

    String? recommendedProgram,

    double? readinessScore,

    String? readinessState,

    PhysiologicalState? physiologicalState,

    int? streakDays,

    int? dailyCompletion,

    NutritionPlan? nutritionPlan,

    String? adaptiveInsight,

    String? personalizedMessage,

    String? dailyDecision,

    String? userIdentity,

    bool? onboardingCompleted,

    String? lastAnalysisAt,

    RecoveryInput? latestRecovery,
  }) {
    return OnboardingData(
      name: name ?? this.name,

      age: age ?? this.age,

      gender: gender ?? this.gender,

      height: height ?? this.height,

      weight: weight ?? this.weight,

      bmi: bmi ?? this.bmi,

      bodyCategory: bodyCategory ?? this.bodyCategory,

      physiqueGoal: physiqueGoal ?? this.physiqueGoal,

      trainingEnvironment: trainingEnvironment ?? this.trainingEnvironment,

      experienceLevel: experienceLevel ?? this.experienceLevel,

      dietPreference: dietPreference ?? this.dietPreference,

      generatedWorkout: generatedWorkout ?? this.generatedWorkout,

      trainingSplit: trainingSplit ?? this.trainingSplit,

      weeklySchedule: weeklySchedule ?? this.weeklySchedule,

      progressionRecommendations:
          progressionRecommendations ?? this.progressionRecommendations,

      recommendedProgram: recommendedProgram ?? this.recommendedProgram,

      readinessScore: readinessScore ?? this.readinessScore,

      readinessState: readinessState ?? this.readinessState,

      physiologicalState: physiologicalState ?? this.physiologicalState,

      streakDays: streakDays ?? this.streakDays,

      dailyCompletion: dailyCompletion ?? this.dailyCompletion,

      nutritionPlan: nutritionPlan ?? this.nutritionPlan,

      adaptiveInsight: adaptiveInsight ?? this.adaptiveInsight,

      personalizedMessage: personalizedMessage ?? this.personalizedMessage,

      dailyDecision: dailyDecision ?? this.dailyDecision,

      userIdentity: userIdentity ?? this.userIdentity,

      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,

      lastAnalysisAt: lastAnalysisAt ?? this.lastAnalysisAt,

      latestRecovery: latestRecovery ?? this.latestRecovery,
    );
  }
}
