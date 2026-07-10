import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../models/habit_model.dart';

/// CRUD operations against the local SQLite database.
class HabitsLocalDatasource {
  Future<Database> get _db => DatabaseHelper.database;

  // ── Habits ─────────────────────────────────────────────────────────────────

  Future<List<HabitModel>> getHabits(String userId) async {
    final db = await _db;
    final rows = await db.query(
      'habits',
      where: 'user_id = ? AND is_deleted = 0',
      whereArgs: [userId],
      orderBy: 'created_at ASC',
    );
    return rows.map(HabitModel.fromMap).toList();
  }

  Future<void> insertOrReplaceHabit(HabitModel habit) async {
    final db = await _db;
    await db.insert(
      'habits',
      habit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> softDeleteHabit(String id) async {
    final db = await _db;
    await db.update(
      'habits',
      {
        'is_deleted': 1,
        'sync_pending': 1,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> markHabitSynced(String id) async {
    final db = await _db;
    await db.update(
      'habits',
      {'sync_pending': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<HabitModel>> getPendingHabits() async {
    final db = await _db;
    final rows = await db.query(
      'habits',
      where: 'sync_pending = 1',
    );
    return rows.map(HabitModel.fromMap).toList();
  }

  // ── Habit Logs ─────────────────────────────────────────────────────────────

  Future<List<HabitLogModel>> getLogs(
    String habitId, {
    DateTime? from,
    DateTime? to,
  }) async {
    final db = await _db;
    String where = 'habit_id = ? AND is_deleted = 0';
    final args = <dynamic>[habitId];
    if (from != null) {
      where += ' AND completed_at >= ?';
      args.add(from.toIso8601String());
    }
    if (to != null) {
      where += ' AND completed_at <= ?';
      args.add(to.toIso8601String());
    }
    final rows = await db.query(
      'habit_logs',
      where: where,
      whereArgs: args,
      orderBy: 'completed_at DESC',
    );
    return rows.map(HabitLogModel.fromMap).toList();
  }

  Future<void> insertOrReplaceLog(HabitLogModel log) async {
    final db = await _db;
    await db.insert(
      'habit_logs',
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> softDeleteLog(String id) async {
    final db = await _db;
    await db.update(
      'habit_logs',
      {
        'is_deleted': 1,
        'sync_pending': 1,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> markLogSynced(String id) async {
    final db = await _db;
    await db.update(
      'habit_logs',
      {'sync_pending': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<HabitLogModel>> getPendingLogs() async {
    final db = await _db;
    final rows = await db.query(
      'habit_logs',
      where: 'sync_pending = 1',
    );
    return rows.map(HabitLogModel.fromMap).toList();
  }
}
