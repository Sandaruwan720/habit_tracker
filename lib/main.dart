import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'pages/dashboard_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Allow all orientations — the analytics dashboard is optimised for landscape
  // on tablets/desktops and adapts gracefully to portrait on phones.
  SystemChrome.setPreferredOrientations(DeviceOrientation.values);

  // Transparent status bar so our header gradient bleeds through
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0A0E1A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const DashboardPage(),
    );
  }
}
