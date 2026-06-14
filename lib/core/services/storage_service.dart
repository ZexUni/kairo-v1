import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // =========================
  // SAVE STRING
  // =========================

  static Future<void> saveString({
    required String key,

    required String value,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(key, value);
  }

  // =========================
  // GET STRING
  // =========================

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(key);
  }

  // =========================
  // SAVE DOUBLE
  // =========================

  static Future<void> saveDouble({
    required String key,

    required double value,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(key, value);
  }

  // =========================
  // GET DOUBLE
  // =========================

  static Future<double?> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getDouble(key);
  }

  // =========================
  // SAVE INT
  // =========================

  static Future<void> saveInt({required String key, required int value}) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(key, value);
  }

  // =========================
  // GET INT
  // =========================

  static Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(key);
  }

  // =========================
  // SAVE BOOL
  // =========================

  static Future<void> saveBool({
    required String key,

    required bool value,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(key, value);
  }

  // =========================
  // GET BOOL
  // =========================

  static Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(key);
  }

  // =========================
  // SAVE STRING LIST
  // =========================

  static Future<void> saveStringList({
    required String key,

    required List<String> value,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(key, value);
  }

  // =========================
  // GET STRING LIST
  // =========================

  static Future<List<String>?> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(key);
  }

  // =========================
  // SAVE MAP
  // =========================

  static Future<void> saveMap({
    required String key,

    required Map<String, dynamic> value,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(value);

    await prefs.setString(key, encoded);
  }

  // =========================
  // GET MAP
  // =========================

  static Future<Map<String, dynamic>?> getMap(String key) async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(key);

    if (data == null) {
      return null;
    }

    return jsonDecode(data);
  }

  // =========================
  // REMOVE KEY
  // =========================

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(key);
  }

  // =========================
  // CLEAR STORAGE
  // =========================

  static Future<void> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }
}
