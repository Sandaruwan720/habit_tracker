import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/providers/habits_provider.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import 'daily_progress_screen.dart';
import 'dashboard_page.dart';

/// Settings & Profile screen — sign out, account info.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F17),
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Profile card ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      (user?.email?.substring(0, 1).toUpperCase()) ?? 'U',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.email ?? 'Not signed in',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Signed in with Supabase',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF64748B),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── About section ─────────────────────────────────────────────────
          _sectionHeader('About'),
          _settingTile(
            icon: Icons.info_outline_rounded,
            label: 'App Version',
            trailing: Text('1.0.0',
                style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF64748B), fontSize: 14)),
          ),
          _settingTile(
            icon: Icons.track_changes_rounded,
            label: 'HabitFlow',
            trailing: Text('Build better habits',
                style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF64748B), fontSize: 14)),
          ),

          const SizedBox(height: 24),

          // ── Danger zone ───────────────────────────────────────────────────
          _sectionHeader('Account'),
          _settingTile(
            icon: Icons.logout_rounded,
            label: 'Sign Out',
            iconColor: const Color(0xFFEF4444),
            labelColor: const Color(0xFFEF4444),
            onTap: () => _signOut(context),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text('Sign Out',
            style: GoogleFonts.plusJakartaSans(
                color: Colors.white, fontWeight: FontWeight.w700)),
        content: Text(
          'Are you sure you want to sign out?',
          style: GoogleFonts.plusJakartaSans(color: const Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel',
                style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF94A3B8))),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Sign Out',
                style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFEF4444),
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await AuthRemoteDatasource().signOut();
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
      }
    }
  }

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title.toUpperCase(),
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF64748B),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      );

  Widget _settingTile({
    required IconData icon,
    required String label,
    Widget? trailing,
    Color iconColor = const Color(0xFF94A3B8),
    Color labelColor = const Color(0xFFE2E8F0),
    VoidCallback? onTap,
  }) =>
      Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: ListTile(
          leading: Icon(icon, color: iconColor, size: 22),
          title: Text(label,
              style: GoogleFonts.plusJakartaSans(
                  color: labelColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500)),
          trailing: trailing ??
              const Icon(Icons.chevron_right_rounded,
                  color: Color(0xFF475569)),
          onTap: onTap,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
}

// ── Main App Shell with bottom navigation ─────────────────────────────────────

/// Full app shell shown after login — tabs: Dashboard, Today, Settings.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final _screens = const [
    DashboardPage(),
    DailyProgressScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load habits on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitsProvider>().loadHabits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    const items = [
      BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
      BottomNavigationBarItem(
          icon: Icon(Icons.today_rounded), label: 'Today'),
      BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined), label: 'Settings'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: const Color(0xFF6366F1),
        unselectedItemColor: const Color(0xFF475569),
        selectedLabelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            GoogleFonts.plusJakartaSans(fontSize: 11),
        items: items,
      ),
    );
  }
}
