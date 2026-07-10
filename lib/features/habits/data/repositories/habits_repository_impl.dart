import 'package:uuid/uuid.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/habits_repository.dart';
import '../datasources/habits_local_datasource.dart';
import '../datasources/habits_remote_datasource.dart';
import '../models/habit_model.dart';

/// Offline-first implementation of [HabitsRepository].
///
/// Write path:  local SQLite (immediate) → mark sync_pending → return
/// Read path:   local SQLite always
/// Sync path:   push pending local rows → pull remote delta → merge
class HabitsRepositoryImpl implements HabitsRepository {
  HabitsRepositoryImpl({
    required this.local,
    required this.remote,
  });

  final HabitsLocalDatasource local;
  final HabitsRemoteDatasource remote;

  static const _uuid = Uuid();

  // ── Habits ─────────────────────────────────────────────────────────────────

  @override
  Future<List<HabitEntity>> getHabits(String userId) async {
    final models = await local.getHabits(userId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<HabitEntity> createHabit(HabitEntity habit) async {
    final now = DateTime.now();
    final withId = habit.copyWith(
      id: _uuid.v4(),
      createdAt: now,
      updatedAt: now,
    );
    final model = HabitModel.fromEntity(withId, syncPending: true);
    await local.insertOrReplaceHabit(model);
    return withId;
  }

  @override
  Future<HabitEntity> updateHabit(HabitEntity habit) async {
    final updated = habit.copyWith(updatedAt: DateTime.now());
    final model = HabitModel.fromEntity(updated, syncPending: true);
    await local.insertOrReplaceHabit(model);
    return updated;
  }

  @override
  Future<void> deleteHabit(String habitId) async {
    await local.softDeleteHabit(habitId);
  }

  // ── Logs ───────────────────────────────────────────────────────────────────

  @override
  Future<List<HabitLogEntity>> getLogs(
    String habitId, {
    DateTime? from,
    DateTime? to,
  }) async {
    final models = await local.getLogs(habitId, from: from, to: to);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<HabitLogEntity> logCompletion(HabitLogEntity log) async {
    final now = DateTime.now();
    final withId = HabitLogEntity(
      id: _uuid.v4(),
      habitId: log.habitId,
      userId: log.userId,
      completedAt: log.completedAt,
      note: log.note,
      updatedAt: now,
    );
    await local.insertOrReplaceLog(
        HabitLogModel.fromEntity(withId, syncPending: true));
    return withId;
  }

  @override
  Future<void> deleteLog(String logId) async {
    await local.softDeleteLog(logId);
  }

  // ── Sync ───────────────────────────────────────────────────────────────────

  @override
  Future<void> syncAll() async {
    await _pushPending();
    await _pullDelta();
  }

  Future<void> _pushPending() async {
    final habits = await local.getPendingHabits();
    for (final h in habits) {
      await remote.upsertHabit(h);
      await local.markHabitSynced(h.id);
    }

    final logs = await local.getPendingLogs();
    for (final l in logs) {
      await remote.upsertLog(l);
      await local.markLogSynced(l.id);
    }
  }

  Future<void> _pullDelta() async {
    // Pull without a cursor for simplicity — the SyncManager handles cursors.
    final remoteHabits = await remote.getHabitsSince(null);
    for (final h in remoteHabits) {
      await local.insertOrReplaceHabit(h);
    }

    final remoteLogs = await remote.getLogsSince(null);
    for (final l in remoteLogs) {
      await local.insertOrReplaceLog(l);
    }
  }
}
