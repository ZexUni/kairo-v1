import 'dart:convert';

class MealEntry {
  final String id;
  final String nutritionLogId;
  final String mealType; // breakfast/lunch/dinner/snack
  final String foodName;
  final double servingSize;
  final String servingUnit;
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fiberG;
  final DateTime loggedAt;

  const MealEntry({
    required this.id,
    required this.nutritionLogId,
    required this.mealType,
    required this.foodName,
    required this.servingSize,
    required this.servingUnit,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fiberG,
    required this.loggedAt,
  });

  MealEntry copyWith({
    String? id,
    String? nutritionLogId,
    String? mealType,
    String? foodName,
    double? servingSize,
    String? servingUnit,
    double? calories,
    double? proteinG,
    double? carbsG,
    double? fatG,
    double? fiberG,
    DateTime? loggedAt,
  }) {
    return MealEntry(
      id: id ?? this.id,
      nutritionLogId: nutritionLogId ?? this.nutritionLogId,
      mealType: mealType ?? this.mealType,
      foodName: foodName ?? this.foodName,
      servingSize: servingSize ?? this.servingSize,
      servingUnit: servingUnit ?? this.servingUnit,
      calories: calories ?? this.calories,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
      fiberG: fiberG ?? this.fiberG,
      loggedAt: loggedAt ?? this.loggedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nutritionLogId': nutritionLogId,
      'mealType': mealType,
      'foodName': foodName,
      'servingSize': servingSize,
      'servingUnit': servingUnit,
      'calories': calories,
      'proteinG': proteinG,
      'carbsG': carbsG,
      'fatG': fatG,
      'fiberG': fiberG,
      'loggedAt': loggedAt.toIso8601String(),
    };
  }

  factory MealEntry.fromMap(Map<String, dynamic> map) {
    return MealEntry(
      id: map['id'] ?? '',
      nutritionLogId: map['nutritionLogId'] ?? '',
      mealType: map['mealType'] ?? 'breakfast',
      foodName: map['foodName'] ?? '',
      servingSize: (map['servingSize'] ?? 0.0).toDouble(),
      servingUnit: map['servingUnit'] ?? 'g',
      calories: (map['calories'] ?? 0.0).toDouble(),
      proteinG: (map['proteinG'] ?? 0.0).toDouble(),
      carbsG: (map['carbsG'] ?? 0.0).toDouble(),
      fatG: (map['fatG'] ?? 0.0).toDouble(),
      fiberG: (map['fiberG'] ?? 0.0).toDouble(),
      loggedAt: map['loggedAt'] != null
          ? DateTime.parse(map['loggedAt'])
          : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MealEntry.fromJson(String source) =>
      MealEntry.fromMap(json.decode(source));
}
