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
  static const String supabaseUrl = 'https://omhxptrgxkfrqpmbharb.supabase.co';

  /// Your Supabase anon/public key
  static const String supabaseAnonKey = 'sb_publishable_Nfo09ie_RUfuKpzqFMoQ5g_tA0_skoN';

  // ---------------------------------------------------------------------------
  // Sync
  // ---------------------------------------------------------------------------

  /// How often the background sync timer fires when online
  static const Duration syncInterval = Duration(seconds: 60);

  /// SharedPreferences key storing the last successful sync cursor (ISO-8601)
  static const String syncCursorKey = 'habitflow_sync_cursor';
}
