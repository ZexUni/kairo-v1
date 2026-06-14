class FoodItem {
  final String name;

  final int calories;

  final int protein;

  final int carbs;

  final int fats;

  final bool vegetarian;

  final String category;

  const FoodItem({
    required this.name,

    required this.calories,

    required this.protein,

    required this.carbs,

    required this.fats,

    required this.vegetarian,

    required this.category,
  });
}

class FoodDatabase {
  static const List<FoodItem> foods = [
    // =========================
    // PROTEIN SOURCES
    // =========================
    FoodItem(
      name: 'Chicken Breast',
      calories: 165,
      protein: 31,
      carbs: 0,
      fats: 4,
      vegetarian: false,
      category: 'Protein',
    ),

    FoodItem(
      name: 'Eggs',
      calories: 155,
      protein: 13,
      carbs: 1,
      fats: 11,
      vegetarian: false,
      category: 'Protein',
    ),

    FoodItem(
      name: 'Paneer',
      calories: 265,
      protein: 18,
      carbs: 6,
      fats: 20,
      vegetarian: true,
      category: 'Protein',
    ),

    FoodItem(
      name: 'Tofu',
      calories: 145,
      protein: 15,
      carbs: 4,
      fats: 9,
      vegetarian: true,
      category: 'Protein',
    ),

    FoodItem(
      name: 'Greek Yogurt',
      calories: 120,
      protein: 17,
      carbs: 6,
      fats: 3,
      vegetarian: true,
      category: 'Protein',
    ),

    // =========================
    // CARBOHYDRATES
    // =========================
    FoodItem(
      name: 'White Rice',
      calories: 130,
      protein: 2,
      carbs: 28,
      fats: 0,
      vegetarian: true,
      category: 'Carbs',
    ),

    FoodItem(
      name: 'Brown Rice',
      calories: 112,
      protein: 2,
      carbs: 24,
      fats: 1,
      vegetarian: true,
      category: 'Carbs',
    ),

    FoodItem(
      name: 'Oats',
      calories: 389,
      protein: 17,
      carbs: 66,
      fats: 7,
      vegetarian: true,
      category: 'Carbs',
    ),

    FoodItem(
      name: 'Sweet Potato',
      calories: 86,
      protein: 2,
      carbs: 20,
      fats: 0,
      vegetarian: true,
      category: 'Carbs',
    ),

    FoodItem(
      name: 'Whole Wheat Bread',
      calories: 247,
      protein: 13,
      carbs: 41,
      fats: 4,
      vegetarian: true,
      category: 'Carbs',
    ),

    // =========================
    // FATS
    // =========================
    FoodItem(
      name: 'Almonds',
      calories: 579,
      protein: 21,
      carbs: 22,
      fats: 50,
      vegetarian: true,
      category: 'Fats',
    ),

    FoodItem(
      name: 'Peanut Butter',
      calories: 588,
      protein: 25,
      carbs: 20,
      fats: 50,
      vegetarian: true,
      category: 'Fats',
    ),

    FoodItem(
      name: 'Avocado',
      calories: 160,
      protein: 2,
      carbs: 9,
      fats: 15,
      vegetarian: true,
      category: 'Fats',
    ),

    FoodItem(
      name: 'Olive Oil',
      calories: 884,
      protein: 0,
      carbs: 0,
      fats: 100,
      vegetarian: true,
      category: 'Fats',
    ),

    // =========================
    // FRUITS
    // =========================
    FoodItem(
      name: 'Banana',
      calories: 89,
      protein: 1,
      carbs: 23,
      fats: 0,
      vegetarian: true,
      category: 'Fruit',
    ),

    FoodItem(
      name: 'Apple',
      calories: 52,
      protein: 0,
      carbs: 14,
      fats: 0,
      vegetarian: true,
      category: 'Fruit',
    ),

    FoodItem(
      name: 'Orange',
      calories: 47,
      protein: 1,
      carbs: 12,
      fats: 0,
      vegetarian: true,
      category: 'Fruit',
    ),

    FoodItem(
      name: 'Blueberries',
      calories: 57,
      protein: 1,
      carbs: 14,
      fats: 0,
      vegetarian: true,
      category: 'Fruit',
    ),

    // =========================
    // VEGETABLES
    // =========================
    FoodItem(
      name: 'Broccoli',
      calories: 34,
      protein: 3,
      carbs: 7,
      fats: 0,
      vegetarian: true,
      category: 'Vegetable',
    ),

    FoodItem(
      name: 'Spinach',
      calories: 23,
      protein: 3,
      carbs: 4,
      fats: 0,
      vegetarian: true,
      category: 'Vegetable',
    ),

    FoodItem(
      name: 'Carrots',
      calories: 41,
      protein: 1,
      carbs: 10,
      fats: 0,
      vegetarian: true,
      category: 'Vegetable',
    ),

    FoodItem(
      name: 'Bell Peppers',
      calories: 31,
      protein: 1,
      carbs: 6,
      fats: 0,
      vegetarian: true,
      category: 'Vegetable',
    ),
  ];
}
