import 'dart:convert';
import 'package:kairo/data/models/meal_entry.dart';

class NutritionLog {
  final String id;
  final String userId;
  final DateTime logDate;
  final List<MealEntry> meals;
  final double totalCalories;
  final double totalProteinG;
  final double totalCarbsG;
  final double totalFatG;
  final double totalFiberG;
  final double waterMl;
  final double targetCalories;
  final double targetProteinG;
  final double targetCarbsG;
  final double targetFatG;

  const NutritionLog({
    required this.id,
    required this.userId,
    required this.logDate,
    required this.meals,
    required this.totalCalories,
    required this.totalProteinG,
    required this.totalCarbsG,
    required this.totalFatG,
    required this.totalFiberG,
    required this.waterMl,
    required this.targetCalories,
    required this.targetProteinG,
    required this.targetCarbsG,
    required this.targetFatG,
  });

  NutritionLog copyWith({
    String? id,
    String? userId,
    DateTime? logDate,
    List<MealEntry>? meals,
    double? totalCalories,
    double? totalProteinG,
    double? totalCarbsG,
    double? totalFatG,
    double? totalFiberG,
    double? waterMl,
    double? targetCalories,
    double? targetProteinG,
    double? targetCarbsG,
    double? targetFatG,
  }) {
    return NutritionLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      logDate: logDate ?? this.logDate,
      meals: meals ?? this.meals,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProteinG: totalProteinG ?? this.totalProteinG,
      totalCarbsG: totalCarbsG ?? this.totalCarbsG,
      totalFatG: totalFatG ?? this.totalFatG,
      totalFiberG: totalFiberG ?? this.totalFiberG,
      waterMl: waterMl ?? this.waterMl,
      targetCalories: targetCalories ?? this.targetCalories,
      targetProteinG: targetProteinG ?? this.targetProteinG,
      targetCarbsG: targetCarbsG ?? this.targetCarbsG,
      targetFatG: targetFatG ?? this.targetFatG,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'logDate': logDate.toIso8601String(),
      'totalCalories': totalCalories,
      'totalProteinG': totalProteinG,
      'totalCarbsG': totalCarbsG,
      'totalFatG': totalFatG,
      'totalFiberG': totalFiberG,
      'waterMl': waterMl,
      'targetCalories': targetCalories,
      'targetProteinG': targetProteinG,
      'targetCarbsG': targetCarbsG,
      'targetFatG': targetFatG,
    };
  }

  factory NutritionLog.fromMap(Map<String, dynamic> map,
      {List<MealEntry>? meals}) {
    return NutritionLog(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      logDate: map['logDate'] != null
          ? DateTime.parse(map['logDate'])
          : DateTime.now(),
      meals: meals ?? [],
      totalCalories: (map['totalCalories'] ?? 0.0).toDouble(),
      totalProteinG: (map['totalProteinG'] ?? 0.0).toDouble(),
      totalCarbsG: (map['totalCarbsG'] ?? 0.0).toDouble(),
      totalFatG: (map['totalFatG'] ?? 0.0).toDouble(),
      totalFiberG: (map['totalFiberG'] ?? 0.0).toDouble(),
      waterMl: (map['waterMl'] ?? 0.0).toDouble(),
      targetCalories: (map['targetCalories'] ?? 0.0).toDouble(),
      targetProteinG: (map['targetProteinG'] ?? 0.0).toDouble(),
      targetCarbsG: (map['targetCarbsG'] ?? 0.0).toDouble(),
      targetFatG: (map['targetFatG'] ?? 0.0).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory NutritionLog.fromJson(String source) =>
      NutritionLog.fromMap(json.decode(source));
}
