class NutritionPlan {
  final int calories;

  final int protein;

  final int carbs;

  final int fats;

  final String dietType;

  NutritionPlan({
    required this.calories,

    required this.protein,

    required this.carbs,

    required this.fats,

    required this.dietType,
  });

  Map<String, dynamic> toMap() {
    return {
      'calories': calories,

      'protein': protein,

      'carbs': carbs,

      'fats': fats,

      'dietType': dietType,
    };
  }

  factory NutritionPlan.fromMap(Map<String, dynamic> map) {
    return NutritionPlan(
      calories: map['calories'] ?? 0,

      protein: map['protein'] ?? 0,

      carbs: map['carbs'] ?? 0,

      fats: map['fats'] ?? 0,

      dietType: map['dietType'] ?? '',
    );
  }

  NutritionPlan copyWith({
    int? calories,

    int? protein,

    int? carbs,

    int? fats,

    String? dietType,
  }) {
    return NutritionPlan(
      calories: calories ?? this.calories,

      protein: protein ?? this.protein,

      carbs: carbs ?? this.carbs,

      fats: fats ?? this.fats,

      dietType: dietType ?? this.dietType,
    );
  }
}
