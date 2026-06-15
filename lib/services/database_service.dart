import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final pathString = join(dbPath, 'kairo_database.db');

    return await openDatabase(
      pathString,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. user_profiles
    await db.execute('''
      CREATE TABLE user_profiles (
        id TEXT PRIMARY KEY,
        userId TEXT,
        name TEXT,
        age INTEGER,
        gender TEXT,
        heightCm REAL,
        weightKg REAL,
        createdAt TEXT,
        updatedAt TEXT,
        equipmentMode TEXT,
        primaryGoal TEXT
      )
    ''');

    // 2. body_measurements
    await db.execute('''
      CREATE TABLE body_measurements (
        id TEXT PRIMARY KEY,
        userId TEXT,
        measuredAt TEXT,
        neckCm REAL,
        shouldersCm REAL,
        chestCm REAL,
        backWidthCm REAL,
        bicepsCm REAL,
        forearmsCm REAL,
        waistCm REAL,
        glutesCm REAL,
        thighsCm REAL,
        calvesCm REAL
      )
    ''');

    // 3. lifestyle_assessments
    await db.execute('''
      CREATE TABLE lifestyle_assessments (
        id TEXT PRIMARY KEY,
        userId TEXT,
        assessedAt TEXT,
        proteinScore REAL,
        mealFrequencyScore REAL,
        processedFoodScore REAL,
        hydrationScore REAL,
        vegetableScore REAL,
        sleepDurationScore REAL,
        sleepConsistencyScore REAL,
        sleepQualityScore REAL,
        dailyMovementScore REAL,
        cardioScore REAL,
        sedentaryScore REAL,
        workStressScore REAL,
        emotionalStressScore REAL,
        recoveryHabitsScore REAL
      )
    ''');

    // 4. performance_assessments
    await db.execute('''
      CREATE TABLE performance_assessments (
        id TEXT PRIMARY KEY,
        userId TEXT,
        assessedAt TEXT,
        maxPushups INTEGER,
        maxPullups INTEGER,
        maxSquats INTEGER,
        plankSeconds INTEGER
      )
    ''');

    // 5. physiology_snapshots
    await db.execute('''
      CREATE TABLE physiology_snapshots (
        id TEXT PRIMARY KEY,
        userId TEXT,
        snapshotAt TEXT,
        bodyFatPercent REAL,
        leanBodyMassKg REAL,
        fatMassKg REAL,
        anabolicScore REAL,
        metabolicScore REAL,
        stressScore REAL,
        recoveryScore REAL,
        archetype TEXT,
        physiqueCompletionPercent REAL
      )
    ''');

    // 6. workout_sessions
    await db.execute('''
      CREATE TABLE workout_sessions (
        id TEXT PRIMARY KEY,
        userId TEXT,
        startedAt TEXT,
        completedAt TEXT,
        totalVolumeKg REAL,
        totalSets INTEGER,
        totalReps INTEGER,
        durationMinutes INTEGER,
        notes TEXT
      )
    ''');

    // 7. exercise_logs
    await db.execute('''
      CREATE TABLE exercise_logs (
        id TEXT PRIMARY KEY,
        sessionId TEXT,
        userId TEXT,
        exerciseName TEXT,
        muscleGroup TEXT,
        notes TEXT
      )
    ''');

    // 8. set_logs
    await db.execute('''
      CREATE TABLE set_logs (
        id TEXT PRIMARY KEY,
        exerciseLogId TEXT,
        userId TEXT,
        setNumber INTEGER,
        reps INTEGER,
        weightKg REAL,
        rpe REAL,
        isCompleted INTEGER,
        completedAt TEXT
      )
    ''');

    // 9. nutrition_logs
    await db.execute('''
      CREATE TABLE nutrition_logs (
        id TEXT PRIMARY KEY,
        userId TEXT,
        logDate TEXT,
        totalCalories REAL,
        totalProteinG REAL,
        totalCarbsG REAL,
        totalFatG REAL,
        totalFiberG REAL,
        waterMl REAL,
        targetCalories REAL,
        targetProteinG REAL,
        targetCarbsG REAL,
        targetFatG REAL
      )
    ''');

    // 10. meal_entries
    await db.execute('''
      CREATE TABLE meal_entries (
        id TEXT PRIMARY KEY,
        nutritionLogId TEXT,
        userId TEXT,
        mealType TEXT,
        foodName TEXT,
        servingSize REAL,
        servingUnit TEXT,
        calories REAL,
        proteinG REAL,
        carbsG REAL,
        fatG REAL,
        fiberG REAL,
        loggedAt TEXT
      )
    ''');

    // 11. recovery_checkins
    await db.execute('''
      CREATE TABLE recovery_checkins (
        id TEXT PRIMARY KEY,
        userId TEXT,
        checkinAt TEXT,
        sleepHours REAL,
        sleepQuality REAL,
        energyLevel REAL,
        stressLevel REAL,
        hydrationLevel REAL,
        sorenessLevel REAL,
        notes TEXT,
        recommendation TEXT
      )
    ''');
  }

  // General CRUD helper functions
  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(table, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    final db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  Future<int> update(
    String table,
    Map<String, dynamic> row, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    return await db.update(table, row, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
    String table, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }
}
