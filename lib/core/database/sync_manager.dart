import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/habits/data/datasources/habits_local_datasource.dart';
import '../../features/habits/data/datasources/habits_remote_datasource.dart';
import '../config/app_config.dart';
import '../network/connectivity_service.dart';

/// Orchestrates background synchronisation between SQLite and Supabase.
///
/// Flow:
///  1. On connectivity restore → push pending + pull delta
///  2. Every [AppConfig.syncInterval] while online → same
///  3. Updated_at cursor stored in SharedPreferences → delta pulls only
class SyncManager {
  SyncManager({
    required this.local,
    required this.remote,
    required this.connectivity,
  });

  final HabitsLocalDatasource local;
  final HabitsRemoteDatasource remote;
  final ConnectivityService connectivity;

  Timer? _timer;
  StreamSubscription<bool>? _connSub;
  bool _isSyncing = false;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  void initialize() {
    // React to connectivity changes
    _connSub = connectivity.onConnectivityChanged.listen((isOnline) {
      if (isOnline) _runSync();
    });

    // Periodic background sync
    _timer = Timer.periodic(AppConfig.syncInterval, (_) async {
      if (await connectivity.isConnected()) {
        _runSync();
      }
    });
  }

  void dispose() {
    _timer?.cancel();
    _connSub?.cancel();
  }

  // ---------------------------------------------------------------------------
  // Core sync logic
  // ---------------------------------------------------------------------------

  Future<void> _runSync() async {
    if (_isSyncing) return;
    _isSyncing = true;
    try {
      await _push();
      await _pull();
      await _updateCursor();
    } catch (e) {
      // Swallow — will retry on next tick or connectivity change.
      // ignore: avoid_print
      print('[SyncManager] Sync error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  // ── Push (local → remote) ──────────────────────────────────────────────────

  Future<void> _push() async {
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

  // ── Pull (remote → local, delta only) ──────────────────────────────────────

  Future<void> _pull() async {
    final prefs = await SharedPreferences.getInstance();
    final cursor = prefs.getString(AppConfig.syncCursorKey);

    final remoteHabits = await remote.getHabitsSince(cursor);
    for (final h in remoteHabits) {
      await local.insertOrReplaceHabit(h);
    }

    final remoteLogs = await remote.getLogsSince(cursor);
    for (final l in remoteLogs) {
      await local.insertOrReplaceLog(l);
    }
  }

  Future<void> _updateCursor() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        AppConfig.syncCursorKey, DateTime.now().toUtc().toIso8601String());
  }

  /// Manually trigger a sync (e.g. from a settings screen).
  Future<void> syncNow() => _runSync();
}
