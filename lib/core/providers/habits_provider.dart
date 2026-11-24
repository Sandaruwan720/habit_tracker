import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/habits/data/datasources/habits_local_datasource.dart';
import '../../features/habits/data/datasources/habits_remote_datasource.dart';
import '../../features/habits/data/repositories/habits_repository_impl.dart';
import '../../features/habits/domain/entities/habit_entity.dart';

enum HabitsStatus { idle, loading, loaded, error }

/// Central state management for all habit + log data.
/// Provided at the top of the widget tree via [ChangeNotifierProvider].
class HabitsProvider extends ChangeNotifier {
  HabitsProvider() {
    _repo = HabitsRepositoryImpl(
      local: HabitsLocalDatasource(),
      remote: HabitsRemoteDatasource(),
    );
  }

  late final HabitsRepositoryImpl _repo;

  // ── State ───────────────────────────────────────────────────────────────────

  HabitsStatus _status = HabitsStatus.idle;
  List<HabitEntity> _habits = [];
  /// habitId → list of today's completion logs
  Map<String, List<HabitLogEntity>> _todayLogs = {};
  String? _errorMessage;

  // ── Getters ─────────────────────────────────────────────────────────────────

  HabitsStatus get status => _status;
  List<HabitEntity> get habits => List.unmodifiable(_habits);
  String? get errorMessage => _errorMessage;

  bool get isLoading => _status == HabitsStatus.loading;

  /// How many habits are completed today.
  int get completedTodayCount =>
      _habits.where((h) => isCompletedToday(h.id)).length;

  /// Today's completion percentage (0–100).
  double get todayCompletionPercent => _habits.isEmpty
      ? 0
      : (completedTodayCount / _habits.length) * 100;

  /// Whether a habit has been completed today.
  bool isCompletedToday(String habitId) {
    final logs = _todayLogs[habitId];
    return logs != null && logs.isNotEmpty;
  }

  // ── Current user ID ─────────────────────────────────────────────────────────

  String get _userId {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw StateError('Not authenticated');
    return user.id;
  }

  // ── Load ────────────────────────────────────────────────────────────────────

  Future<void> loadHabits() async {
    _setLoading();
    try {
      final userId = _userId;
      _habits = await _repo.getHabits(userId);
      await _loadTodayLogs();
      _setLoaded();
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> _loadTodayLogs() async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));
    _todayLogs = {};
    for (final habit in _habits) {
      _todayLogs[habit.id] =
          await _repo.getLogs(habit.id, from: start, to: end);
    }
  }

  // ── Create ──────────────────────────────────────────────────────────────────

  Future<void> addHabit({
    required String name,
    String? description,
    int color = 0xFF22C55E,
    String icon = 'check_circle',
    String frequency = 'daily',
    int targetCount = 1,
  }) async {
    final userId = _userId;
    final now = DateTime.now();
    final entity = HabitEntity(
      id: '', // repo will generate
      userId: userId,
      name: name,
      description: description,
      color: color,
      icon: icon,
      frequency: frequency,
      targetCount: targetCount,
      createdAt: now,
      updatedAt: now,
    );
    final created = await _repo.createHabit(entity);
    _habits = [..._habits, created];
    notifyListeners();
  }

  // ── Update ──────────────────────────────────────────────────────────────────

  Future<void> updateHabit(HabitEntity habit) async {
    final updated = await _repo.updateHabit(habit);
    _habits = _habits.map((h) => h.id == updated.id ? updated : h).toList();
    notifyListeners();
  }

  // ── Delete ──────────────────────────────────────────────────────────────────

  Future<void> deleteHabit(String habitId) async {
    await _repo.deleteHabit(habitId);
    _habits = _habits.where((h) => h.id != habitId).toList();
    _todayLogs.remove(habitId);
    notifyListeners();
  }

  // ── Toggle completion (today) ───────────────────────────────────────────────

  Future<void> toggleTodayCompletion(String habitId) async {
    final userId = _userId;
    if (isCompletedToday(habitId)) {
      // Undo — soft-delete the most recent log
      final logs = _todayLogs[habitId]!;
      if (logs.isNotEmpty) {
        await _repo.deleteLog(logs.last.id);
        _todayLogs[habitId] = logs.sublist(0, logs.length - 1);
      }
    } else {
      // Log completion
      final log = HabitLogEntity(
        id: '',
        habitId: habitId,
        userId: userId,
        completedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final created = await _repo.logCompletion(log);
      _todayLogs[habitId] = [...(_todayLogs[habitId] ?? []), created];
    }
    notifyListeners();
  }

  // ── State helpers ────────────────────────────────────────────────────────────

  void _setLoading() {
    _status = HabitsStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoaded() {
    _status = HabitsStatus.loaded;
    notifyListeners();
  }

  void _setError(String msg) {
    _status = HabitsStatus.error;
    _errorMessage = msg;
    notifyListeners();
  }
}
