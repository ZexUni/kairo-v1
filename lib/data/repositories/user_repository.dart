import 'package:uuid/uuid.dart';
import 'package:kairo/services/database_service.dart';
import 'package:kairo/data/models/user_profile.dart';
import 'package:kairo/data/models/body_measurements.dart';
import 'package:kairo/data/models/lifestyle_assessment.dart';
import 'package:kairo/data/models/performance_assessment.dart';
import 'package:kairo/data/models/physiology_snapshot.dart';

class UserRepository {
  final DatabaseService _db = DatabaseService();
  final _uuid = const Uuid();

  Future<void> saveProfile(UserProfile p) async {
    await _db.insert('user_profiles', p.toMap());
  }

  Future<UserProfile?> getProfile(String userId) async {
    final list = await _db.query('user_profiles', where: 'id = ?', whereArgs: [userId]);
    if (list.isEmpty) return null;
    return UserProfile.fromMap(list.first);
  }

  Future<void> saveMeasurements(BodyMeasurements m) async {
    final Map<String, dynamic> map = m.toMap();
    // composite key or standard id
    map['id'] = "${m.userId}_${m.measuredAt.millisecondsSinceEpoch}";
    await _db.insert('body_measurements', map);
  }

  Future<BodyMeasurements?> getLatestMeasurements(String userId) async {
    final list = await _db.query(
      'body_measurements',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'measuredAt DESC',
      limit: 1,
    );
    if (list.isEmpty) return null;
    return BodyMeasurements.fromMap(list.first);
  }

  Future<void> saveLifestyle(LifestyleAssessment l) async {
    final Map<String, dynamic> map = l.toMap();
    map['id'] = "${l.userId}_${l.assessedAt.millisecondsSinceEpoch}";
    await _db.insert('lifestyle_assessments', map);
  }

  Future<LifestyleAssessment?> getLatestLifestyle(String userId) async {
    final list = await _db.query(
      'lifestyle_assessments',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'assessedAt DESC',
      limit: 1,
    );
    if (list.isEmpty) return null;
    return LifestyleAssessment.fromMap(list.first);
  }

  Future<void> savePerformance(PerformanceAssessment p) async {
    final Map<String, dynamic> map = p.toMap();
    map['id'] = "${p.userId}_${p.assessedAt.millisecondsSinceEpoch}";
    await _db.insert('performance_assessments', map);
  }

  Future<PerformanceAssessment?> getLatestPerformance(String userId) async {
    final list = await _db.query(
      'performance_assessments',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'assessedAt DESC',
      limit: 1,
    );
    if (list.isEmpty) return null;
    return PerformanceAssessment.fromMap(list.first);
  }

  Future<void> saveSnapshot(PhysiologySnapshot s) async {
    final Map<String, dynamic> map = s.toMap();
    map['id'] = "${s.userId}_${s.snapshotAt.millisecondsSinceEpoch}";
    await _db.insert('physiology_snapshots', map);
  }

  Future<PhysiologySnapshot?> getLatestSnapshot(String userId) async {
    final list = await _db.query(
      'physiology_snapshots',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'snapshotAt DESC',
      limit: 1,
    );
    if (list.isEmpty) return null;
    return PhysiologySnapshot.fromMap(list.first);
  }
}
