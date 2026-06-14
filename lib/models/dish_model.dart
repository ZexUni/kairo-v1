class Dish {
  final String name;

  final String category;

  final int calories;

  final int protein;

  final int carbs;

  final int fats;

  final bool vegetarian;

  final List<String> ingredients;

  final List<String> instructions;

  const Dish({
    required this.name,
    required this.category,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.vegetarian,
    this.ingredients = const [],
    this.instructions = const [],
  });
}
