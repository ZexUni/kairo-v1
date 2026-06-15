import 'package:intl/intl.dart';
import 'package:kairo/services/database_service.dart';
import 'package:kairo/data/models/nutrition_log.dart';
import 'package:kairo/data/models/meal_entry.dart';

class NutritionRepository {
  final DatabaseService _db = DatabaseService();

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> saveLog(NutritionLog l) async {
    // 1. Insert log
    final Map<String, dynamic> logMap = l.toMap();
    // Use date string instead of full timestamp for key in DB
    final dateStr = _formatDate(l.logDate);
    logMap['id'] = "${l.userId}_$dateStr";
    logMap['logDate'] = dateStr;
    await _db.insert('nutrition_logs', logMap);

    // 2. Delete existing meals for this log to prevent duplicates
    await _db.delete(
      'meal_entries',
      where: 'nutritionLogId = ?',
      whereArgs: [logMap['id']],
    );

    // 3. Insert new meals
    for (var meal in l.meals) {
      final Map<String, dynamic> mealMap = meal.toMap();
      mealMap['userId'] = l.userId;
      await _db.insert('meal_entries', mealMap);
    }
  }

  Future<NutritionLog?> getLogForDate(String userId, DateTime date) async {
    final dateStr = _formatDate(date);
    final logId = "${userId}_$dateStr";

    final list = await _db.query(
      'nutrition_logs',
      where: 'id = ?',
      whereArgs: [logId],
    );

    if (list.isEmpty) return null;

    // Query meals
    final mealList = await _db.query(
      'meal_entries',
      where: 'nutritionLogId = ?',
      whereArgs: [logId],
      orderBy: 'loggedAt ASC',
    );

    final List<MealEntry> meals = mealList.map((row) => MealEntry.fromMap(row)).toList();
    return NutritionLog.fromMap(list.first, meals: meals);
  }
}
