import 'package:kairo/models/dish_model.dart';

class DishDatabase {
  static const List<Dish> dishes = [
    // =========================
    // BREAKFAST
    // =========================
    Dish(
      name: 'Oats with Banana',
      category: 'Breakfast',
      calories: 350,
      protein: 12,
      carbs: 58,
      fats: 7,
      vegetarian: true,
      ingredients: ['Rolled oats', 'Banana', 'Milk or water', 'Honey (optional)'],
      instructions: [
        'Cook oats with milk or water until creamy.',
        'Slice banana on top and sweeten if desired.',
      ],
    ),

    Dish(
      name: 'Egg Omelette',
      category: 'Breakfast',
      calories: 280,
      protein: 22,
      carbs: 4,
      fats: 18,
      vegetarian: false,
      ingredients: ['Eggs', 'Olive oil', 'Salt', 'Pepper', 'Vegetables (optional)'],
      instructions: [
        'Whisk eggs with salt and pepper.',
        'Cook in a non-stick pan, fold when set.',
      ],
    ),

    Dish(
      name: 'Greek Yogurt Bowl',
      category: 'Breakfast',
      calories: 320,
      protein: 24,
      carbs: 28,
      fats: 10,
      vegetarian: true,
      ingredients: ['Greek yogurt', 'Berries', 'Granola', 'Honey'],
      instructions: [
        'Add yogurt to a bowl.',
        'Top with berries, granola, and a drizzle of honey.',
      ],
    ),

    // =========================
    // LUNCH
    // =========================
    Dish(
      name: 'Chicken Rice Bowl',
      category: 'Lunch',
      calories: 620,
      protein: 45,
      carbs: 70,
      fats: 15,
      vegetarian: false,
      ingredients: ['Chicken breast', 'Rice', 'Vegetables', 'Olive oil', 'Seasoning'],
      instructions: [
        'Grill or pan-cook seasoned chicken.',
        'Serve over rice with steamed vegetables.',
      ],
    ),

    Dish(
      name: 'Paneer Rice Bowl',
      category: 'Lunch',
      calories: 580,
      protein: 30,
      carbs: 68,
      fats: 20,
      vegetarian: true,
      ingredients: ['Paneer', 'Rice', 'Bell peppers', 'Spices', 'Oil'],
      instructions: [
        'Sauté paneer and vegetables with spices.',
        'Plate with cooked rice.',
      ],
    ),

    Dish(
      name: 'Grilled Fish Meal',
      category: 'Lunch',
      calories: 540,
      protein: 42,
      carbs: 48,
      fats: 16,
      vegetarian: false,
      ingredients: ['White fish fillet', 'Lemon', 'Herbs', 'Rice or potatoes'],
      instructions: [
        'Season fish and grill until flaky.',
        'Serve with lemon and a side of rice or potatoes.',
      ],
    ),

    // =========================
    // DINNER
    // =========================
    Dish(
      name: 'Steak and Potatoes',
      category: 'Dinner',
      calories: 700,
      protein: 52,
      carbs: 55,
      fats: 28,
      vegetarian: false,
      ingredients: ['Beef steak', 'Potatoes', 'Butter', 'Garlic', 'Herbs'],
      instructions: [
        'Pan-sear or grill steak to preferred doneness.',
        'Roast or boil potatoes with garlic and herbs.',
      ],
    ),

    Dish(
      name: 'Tofu Stir Fry',
      category: 'Dinner',
      calories: 480,
      protein: 26,
      carbs: 40,
      fats: 18,
      vegetarian: true,
      ingredients: ['Firm tofu', 'Mixed vegetables', 'Soy sauce', 'Ginger', 'Oil'],
      instructions: [
        'Press and cube tofu, then pan-fry until golden.',
        'Stir-fry vegetables, add tofu and sauce to combine.',
      ],
    ),

    Dish(
      name: 'Chicken Pasta',
      category: 'Dinner',
      calories: 650,
      protein: 44,
      carbs: 72,
      fats: 17,
      vegetarian: false,
      ingredients: ['Chicken', 'Pasta', 'Tomato sauce', 'Garlic', 'Olive oil'],
      instructions: [
        'Cook pasta until al dente.',
        'Sauté chicken, add sauce, and toss with pasta.',
      ],
    ),

    // =========================
    // SNACKS
    // =========================
    Dish(
      name: 'Protein Shake',
      category: 'Snack',
      calories: 220,
      protein: 30,
      carbs: 12,
      fats: 5,
      vegetarian: true,
      ingredients: ['Protein powder', 'Milk or water', 'Ice'],
      instructions: [
        'Add protein powder and liquid to a shaker or blender.',
        'Blend until smooth and serve chilled.',
      ],
    ),

    Dish(
      name: 'Mixed Nuts',
      category: 'Snack',
      calories: 260,
      protein: 8,
      carbs: 10,
      fats: 22,
      vegetarian: true,
      ingredients: ['Almonds', 'Walnuts', 'Cashews'],
      instructions: [
        'Portion a small handful of mixed nuts.',
        'Store in an airtight container for easy snacking.',
      ],
    ),

    Dish(
      name: 'Peanut Butter Toast',
      category: 'Snack',
      calories: 340,
      protein: 14,
      carbs: 32,
      fats: 16,
      vegetarian: true,
      ingredients: ['Whole-grain bread', 'Peanut butter', 'Banana (optional)'],
      instructions: [
        'Toast bread until crisp.',
        'Spread peanut butter and add banana slices if desired.',
      ],
    ),
  ];
}
