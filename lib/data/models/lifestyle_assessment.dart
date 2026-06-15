import 'dart:convert';

class LifestyleAssessment {
  final String userId;
  final DateTime assessedAt;
  final double proteinScore;
  final double mealFrequencyScore;
  final double processedFoodScore;
  final double hydrationScore;
  final double vegetableScore;
  final double sleepDurationScore;
  final double sleepConsistencyScore;
  final double sleepQualityScore;
  final double dailyMovementScore;
  final double cardioScore;
  final double sedentaryScore;
  final double workStressScore;
  final double emotionalStressScore;
  final double recoveryHabitsScore;

  const LifestyleAssessment({
    required this.userId,
    required this.assessedAt,
    required this.proteinScore,
    required this.mealFrequencyScore,
    required this.processedFoodScore,
    required this.hydrationScore,
    required this.vegetableScore,
    required this.sleepDurationScore,
    required this.sleepConsistencyScore,
    required this.sleepQualityScore,
    required this.dailyMovementScore,
    required this.cardioScore,
    required this.sedentaryScore,
    required this.workStressScore,
    required this.emotionalStressScore,
    required this.recoveryHabitsScore,
  });

  LifestyleAssessment copyWith({
    String? userId,
    DateTime? assessedAt,
    double? proteinScore,
    double? mealFrequencyScore,
    double? processedFoodScore,
    double? hydrationScore,
    double? vegetableScore,
    double? sleepDurationScore,
    double? sleepConsistencyScore,
    double? sleepQualityScore,
    double? dailyMovementScore,
    double? cardioScore,
    double? sedentaryScore,
    double? workStressScore,
    double? emotionalStressScore,
    double? recoveryHabitsScore,
  }) {
    return LifestyleAssessment(
      userId: userId ?? this.userId,
      assessedAt: assessedAt ?? this.assessedAt,
      proteinScore: proteinScore ?? this.proteinScore,
      mealFrequencyScore: mealFrequencyScore ?? this.mealFrequencyScore,
      processedFoodScore: processedFoodScore ?? this.processedFoodScore,
      hydrationScore: hydrationScore ?? this.hydrationScore,
      vegetableScore: vegetableScore ?? this.vegetableScore,
      sleepDurationScore: sleepDurationScore ?? this.sleepDurationScore,
      sleepConsistencyScore: sleepConsistencyScore ?? this.sleepConsistencyScore,
      sleepQualityScore: sleepQualityScore ?? this.sleepQualityScore,
      dailyMovementScore: dailyMovementScore ?? this.dailyMovementScore,
      cardioScore: cardioScore ?? this.cardioScore,
      sedentaryScore: sedentaryScore ?? this.sedentaryScore,
      workStressScore: workStressScore ?? this.workStressScore,
      emotionalStressScore: emotionalStressScore ?? this.emotionalStressScore,
      recoveryHabitsScore: recoveryHabitsScore ?? this.recoveryHabitsScore,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'assessedAt': assessedAt.toIso8601String(),
      'proteinScore': proteinScore,
      'mealFrequencyScore': mealFrequencyScore,
      'processedFoodScore': processedFoodScore,
      'hydrationScore': hydrationScore,
      'vegetableScore': vegetableScore,
      'sleepDurationScore': sleepDurationScore,
      'sleepConsistencyScore': sleepConsistencyScore,
      'sleepQualityScore': sleepQualityScore,
      'dailyMovementScore': dailyMovementScore,
      'cardioScore': cardioScore,
      'sedentaryScore': sedentaryScore,
      'workStressScore': workStressScore,
      'emotionalStressScore': emotionalStressScore,
      'recoveryHabitsScore': recoveryHabitsScore,
    };
  }

  factory LifestyleAssessment.fromMap(Map<String, dynamic> map) {
    return LifestyleAssessment(
      userId: map['userId'] ?? '',
      assessedAt: map['assessedAt'] != null
          ? DateTime.parse(map['assessedAt'])
          : DateTime.now(),
      proteinScore: (map['proteinScore'] ?? 0.0).toDouble(),
      mealFrequencyScore: (map['mealFrequencyScore'] ?? 0.0).toDouble(),
      processedFoodScore: (map['processedFoodScore'] ?? 0.0).toDouble(),
      hydrationScore: (map['hydrationScore'] ?? 0.0).toDouble(),
      vegetableScore: (map['vegetableScore'] ?? 0.0).toDouble(),
      sleepDurationScore: (map['sleepDurationScore'] ?? 0.0).toDouble(),
      sleepConsistencyScore: (map['sleepConsistencyScore'] ?? 0.0).toDouble(),
      sleepQualityScore: (map['sleepQualityScore'] ?? 0.0).toDouble(),
      dailyMovementScore: (map['dailyMovementScore'] ?? 0.0).toDouble(),
      cardioScore: (map['cardioScore'] ?? 0.0).toDouble(),
      sedentaryScore: (map['sedentaryScore'] ?? 0.0).toDouble(),
      workStressScore: (map['workStressScore'] ?? 0.0).toDouble(),
      emotionalStressScore: (map['emotionalStressScore'] ?? 0.0).toDouble(),
      recoveryHabitsScore: (map['recoveryHabitsScore'] ?? 0.0).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory LifestyleAssessment.fromJson(String source) =>
      LifestyleAssessment.fromMap(json.decode(source));
}
