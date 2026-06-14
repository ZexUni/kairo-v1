class FoodModel {
  final String name;

  final int calories;

  final int protein;

  final int carbs;

  final int fats;

  final String mealType;

  final bool vegetarian;

  FoodModel({
    required this.name,

    required this.calories,

    required this.protein,

    required this.carbs,

    required this.fats,

    required this.mealType,

    required this.vegetarian,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,

      'calories': calories,

      'protein': protein,

      'carbs': carbs,

      'fats': fats,

      'mealType': mealType,

      'vegetarian': vegetarian,
    };
  }

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      name: map['name'] ?? '',

      calories: map['calories'] ?? 0,

      protein: map['protein'] ?? 0,

      carbs: map['carbs'] ?? 0,

      fats: map['fats'] ?? 0,

      mealType: map['mealType'] ?? '',

      vegetarian: map['vegetarian'] ?? false,
    );
  }

  FoodModel copyWith({
    String? name,

    int? calories,

    int? protein,

    int? carbs,

    int? fats,

    String? mealType,

    bool? vegetarian,
  }) {
    return FoodModel(
      name: name ?? this.name,

      calories: calories ?? this.calories,

      protein: protein ?? this.protein,

      carbs: carbs ?? this.carbs,

      fats: fats ?? this.fats,

      mealType: mealType ?? this.mealType,

      vegetarian: vegetarian ?? this.vegetarian,
    );
  }
}
