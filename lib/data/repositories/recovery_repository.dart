import 'package:kairo/services/database_service.dart';
import 'package:kairo/data/models/recovery_checkin.dart';

class RecoveryRepository {
  final DatabaseService _db = DatabaseService();

  Future<void> saveCheckin(RecoveryCheckin c) async {
    final Map<String, dynamic> map = c.toMap();
    // Use unique id based on userId and date to allow daily checkin update
    final dateStr = c.checkinAt.toIso8601String().substring(0, 10); // YYYY-MM-DD
    map['id'] = "${c.userId}_$dateStr";
    await _db.insert('recovery_checkins', map);
  }

  Future<RecoveryCheckin?> getLatestCheckin(String userId) async {
    final list = await _db.query(
      'recovery_checkins',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'checkinAt DESC',
      limit: 1,
    );

    if (list.isEmpty) return null;
    return RecoveryCheckin.fromMap(list.first);
  }
}
