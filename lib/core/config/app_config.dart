/// ─────────────────────────────────────────────────────────────────────────────
/// AppConfig — centralised configuration for the HabitFlow app.
///
/// ⚠️  Replace [supabaseUrl] and [supabaseAnonKey] with your real project
///     values from:  Supabase Dashboard → Settings → API
/// ─────────────────────────────────────────────────────────────────────────────
class AppConfig {
  AppConfig._();

  // ---------------------------------------------------------------------------
  // Supabase
  // ---------------------------------------------------------------------------

  /// Your Supabase project URL, e.g. https://xxxxxxxxxxxx.supabase.co
  static const String supabaseUrl = 'YOUR_SUPABASE_PROJECT_URL';

  /// Your Supabase anon/public key
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // ---------------------------------------------------------------------------
  // Sync
  // ---------------------------------------------------------------------------

  /// How often the background sync timer fires when online
  static const Duration syncInterval = Duration(seconds: 60);

  /// SharedPreferences key storing the last successful sync cursor (ISO-8601)
  static const String syncCursorKey = 'habitflow_sync_cursor';
}
