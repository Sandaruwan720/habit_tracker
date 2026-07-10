import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

/// Manages the local SQLite database lifecycle and schema.
class DatabaseHelper {
  DatabaseHelper._();

  static const String _dbName = 'habit_flow.db';
  static const int _dbVersion = 1;

  static Database? _db;

  /// Returns the singleton database, initialising it on first call.
  static Future<Database> get database async {
    _db ??= await _init();
    return _db!;
  }

  // ---------------------------------------------------------------------------
  // Initialisation
  // ---------------------------------------------------------------------------

  static Future<Database> _init() async {
    // sqflite_common_ffi is required on Windows / Linux / macOS desktops.
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // ---------------------------------------------------------------------------
  // Schema
  // ---------------------------------------------------------------------------

  static Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    // habits ------------------------------------------------------------------
    batch.execute('''
      CREATE TABLE habits (
        id            TEXT PRIMARY KEY,
        user_id       TEXT NOT NULL,
        name          TEXT NOT NULL,
        description   TEXT,
        color         INTEGER DEFAULT 4284717203,
        icon          TEXT    DEFAULT 'check_circle',
        frequency     TEXT    DEFAULT 'daily',
        target_count  INTEGER DEFAULT 1,
        created_at    TEXT NOT NULL,
        updated_at    TEXT NOT NULL,
        is_deleted    INTEGER DEFAULT 0,
        sync_pending  INTEGER DEFAULT 1
      )
    ''');

    // habit_logs --------------------------------------------------------------
    batch.execute('''
      CREATE TABLE habit_logs (
        id            TEXT PRIMARY KEY,
        habit_id      TEXT NOT NULL,
        user_id       TEXT NOT NULL,
        completed_at  TEXT NOT NULL,
        note          TEXT,
        updated_at    TEXT NOT NULL,
        is_deleted    INTEGER DEFAULT 0,
        sync_pending  INTEGER DEFAULT 1,
        FOREIGN KEY (habit_id) REFERENCES habits(id)
      )
    ''');

    // Indices -----------------------------------------------------------------
    batch.execute(
        'CREATE INDEX idx_habits_user ON habits(user_id)');
    batch.execute(
        'CREATE INDEX idx_habits_sync ON habits(sync_pending)');
    batch.execute(
        'CREATE INDEX idx_logs_habit ON habit_logs(habit_id)');
    batch.execute(
        'CREATE INDEX idx_logs_sync ON habit_logs(sync_pending)');

    await batch.commit();
  }

  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    // Future migrations go here.
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Closes the database — call during app teardown if needed.
  static Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
