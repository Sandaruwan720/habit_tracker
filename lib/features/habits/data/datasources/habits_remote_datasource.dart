import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/habit_model.dart';

/// CRUD operations against the remote Supabase database.
class HabitsRemoteDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  // ── Habits ─────────────────────────────────────────────────────────────────

  Future<void> upsertHabit(HabitModel habit) async {
    await _client.from('habits').upsert(habit.toSupabaseMap());
  }

  /// Returns all habits modified after [since] (ISO-8601).
  Future<List<HabitModel>> getHabitsSince(String? since) async {
    var query = _client
        .from('habits')
        .select()
        .eq('user_id', _currentUserId);

    if (since != null) {
      query = query.gt('updated_at', since);
    }

    final rows = await query;
    return (rows as List)
        .map((r) => HabitModel.fromSupabase(r as Map<String, dynamic>))
        .toList();
  }

  // ── Habit Logs ─────────────────────────────────────────────────────────────

  Future<void> upsertLog(HabitLogModel log) async {
    await _client.from('habit_logs').upsert(log.toSupabaseMap());
  }

  Future<List<HabitLogModel>> getLogsSince(String? since) async {
    var query = _client
        .from('habit_logs')
        .select()
        .eq('user_id', _currentUserId);

    if (since != null) {
      query = query.gt('updated_at', since);
    }

    final rows = await query;
    return (rows as List)
        .map((r) => HabitLogModel.fromSupabase(r as Map<String, dynamic>))
        .toList();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String get _currentUserId {
    final user = _client.auth.currentUser;
    if (user == null) throw StateError('Not authenticated');
    return user.id;
  }
}
