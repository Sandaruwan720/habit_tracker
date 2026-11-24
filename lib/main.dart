import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/app_config.dart';
import 'core/database/database_helper.dart';
import 'core/database/sync_manager.dart';
import 'core/network/connectivity_service.dart';
import 'core/providers/habits_provider.dart';
import 'features/habits/data/datasources/habits_local_datasource.dart';
import 'features/habits/data/datasources/habits_remote_datasource.dart';
import 'theme/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'pages/app_shell.dart';

// Lazy singleton references – accessible app-wide
late final ConnectivityService connectivityService;
late final SyncManager syncManager;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Supabase ────────────────────────────────────────────────────────────────
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    // ignore: deprecated_member_use
    anonKey: AppConfig.supabaseAnonKey,
  );

  // ── Warm up the local database ──────────────────────────────────────────────
  await DatabaseHelper.database;

  // ── Connectivity + Sync ─────────────────────────────────────────────────────
  connectivityService = ConnectivityService()..initialize();

  syncManager = SyncManager(
    local: HabitsLocalDatasource(),
    remote: HabitsRemoteDatasource(),
    connectivity: connectivityService,
  )..initialize();

  // ── System UI ───────────────────────────────────────────────────────────────
  SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0B0F17),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HabitsProvider(),
      child: MaterialApp(
        title: 'HabitFlow',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        routes: {
          '/': (_) => Supabase.instance.client.auth.currentUser == null
              ? const LoginScreen()
              : const AppShell(),
          '/home': (_) => const AppShell(),
        },
      ),
    );
  }
}
