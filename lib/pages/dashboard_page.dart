import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/dashboard_analytics.dart';
import '../models/habit_model.dart';
import '../theme/app_colors.dart';
import '../widgets/dashboard/sidebar_nav.dart';
import '../widgets/dashboard/top_dashboard_header.dart';
import '../widgets/dashboard/stat_metric_card.dart';
import '../widgets/dashboard/completion_line_chart.dart';
import '../widgets/dashboard/category_donut_chart.dart';
import '../widgets/dashboard/monthly_bar_chart.dart';
import '../widgets/dashboard/adaptive_habits_layout.dart';
import '../widgets/dashboard/streak_achievements_card.dart';
import '../widgets/dashboard/activity_feed_card.dart';

/// Full professional analytics dashboard page with responsive architecture.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedNavIndex = 0;
  List<HabitModel> _habits = List.from(DashboardAnalytics.habits);

  void _toggleHabit(String id) {
    setState(() {
      _habits = _habits.map((h) {
        if (h.id == id) return h.copyWith(isCompleted: !h.isCompleted);
        return h;
      }).toList();
    });
  }

  int get _completedCount => _habits.where((h) => h.isCompleted).length;
  double get _todayCompletion =>
      _habits.isEmpty ? 0 : (_completedCount / _habits.length) * 100;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    final isTablet = screenWidth >= 800 && screenWidth < 1200;
    final isDesktop = screenWidth >= 1200;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      bottomNavigationBar: isMobile ? _buildBottomNav() : null,
      body: Row(
        children: [
          // ── Sidebar (Tablet & Desktop only) ────────────────────────────────
          if (!isMobile)
            SidebarNav(
              selectedIndex: _selectedNavIndex,
              onItemTap: (i) => setState(() => _selectedNavIndex = i),
            ),

          // ── Main Content ───────────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                const TopDashboardHeader(userName: 'Tharuka'),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. KPI Stats
                        _buildStatsSection(isMobile, isTablet, isDesktop),
                        const SizedBox(height: 24),

                        // 2. Charts
                        _buildChartsSection(isMobile, isTablet, isDesktop),
                        const SizedBox(height: 24),

                        // 3. Habits Table/Cards + Achievements + Activity
                        _buildHabitsSection(isMobile, isTablet, isDesktop),
                        const SizedBox(height: 24),

                        // 4. Bottom Summary
                        _buildBottomSummarySection(isMobile, isTablet, isDesktop),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Bottom Nav (Mobile Only)
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E1A),
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedNavIndex,
        onTap: (i) => setState(() => _selectedNavIndex = i),
        selectedItemColor: AppColors.progressGreen,
        unselectedItemColor: AppColors.textMuted,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.groups_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: ''),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 1. Stats Section
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildStatsSection(bool isMobile, bool isTablet, bool isDesktop) {
    final cards = [
      StatMetricCard(
        label: 'Current Streak',
        value: '${DashboardAnalytics.currentStreak}',
        unit: 'Days',
        change: DashboardAnalytics.streakChange,
        icon: Icons.local_fire_department_rounded,
        gradient: AppColors.streakGradient,
        glowColor: AppColors.orangeGlow,
        animationDelay: 50.ms,
      ),
      StatMetricCard(
        label: "Today's Progress",
        value: '${_todayCompletion.toInt()}',
        unit: '%',
        change: DashboardAnalytics.completionChange,
        icon: Icons.donut_large_rounded,
        gradient: AppColors.progressGradient,
        glowColor: AppColors.greenGlow,
        animationDelay: 120.ms,
      ),
      StatMetricCard(
        label: 'Habits Completed',
        value: '$_completedCount / ${_habits.length}',
        unit: '',
        change: DashboardAnalytics.completedChange,
        icon: Icons.check_circle_rounded,
        gradient: AppColors.progressGradient,
        glowColor: AppColors.greenGlow,
        animationDelay: 190.ms,
      ),
      StatMetricCard(
        label: 'Consistency',
        value: '${DashboardAnalytics.consistency.toInt()}',
        unit: '%',
        change: DashboardAnalytics.consistencyChange,
        icon: Icons.stars_rounded,
        gradient: AppColors.accentGradient,
        glowColor: AppColors.indigoGlow,
        animationDelay: 260.ms,
      ),
      StatMetricCard(
        label: 'Best Streak',
        value: '${DashboardAnalytics.bestStreak}',
        unit: 'Days',
        change: DashboardAnalytics.bestStreakChange,
        icon: Icons.emoji_events_rounded,
        gradient: const LinearGradient(
            colors: [Color(0xFFF59E0B), Color(0xFFEF4444)]),
        glowColor: AppColors.orangeGlow,
        animationDelay: 330.ms,
      ),
    ];

    if (isDesktop) {
      return Row(
        children: cards.map((c) => Expanded(child: Padding(
          padding: EdgeInsets.only(right: c == cards.last ? 0 : 16),
          child: c,
        ))).toList(),
      );
    } else if (isTablet) {
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: cards.map((c) => SizedBox(
          width: MediaQuery.of(context).size.width / 2 - (220/2) - 40, // rough 2 col calc
          child: c,
        )).toList(),
      );
    } else {
      // Mobile - Horizontal Scroll
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.none,
        child: Row(
          children: cards.map((c) => Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(width: 160, child: c),
          )).toList(),
        ),
      );
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 2. Charts Section
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildChartsSection(bool isMobile, bool isTablet, bool isDesktop) {
    if (isDesktop) {
      return const IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 5, child: CompletionLineChart()),
            SizedBox(width: 16),
            Expanded(flex: 3, child: CategoryDonutChart()),
            SizedBox(width: 16),
            Expanded(flex: 4, child: MonthlyBarChart()),
          ],
        ),
      );
    } else if (isTablet) {
      return const Column(
        children: [
          SizedBox(height: 300, child: CompletionLineChart()),
          SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 1, child: CategoryDonutChart()),
                SizedBox(width: 16),
                Expanded(flex: 1, child: MonthlyBarChart()),
              ],
            ),
          ),
        ],
      );
    } else {
      // Mobile - Stack Vertically
      return const Column(
        children: [
          SizedBox(height: 300, child: CompletionLineChart()),
          SizedBox(height: 16),
          SizedBox(height: 280, child: CategoryDonutChart()),
          SizedBox(height: 16),
          SizedBox(height: 280, child: MonthlyBarChart()),
        ],
      );
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 3. Habits Section (Adaptive layout) + Achievements + Activity
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildHabitsSection(bool isMobile, bool isTablet, bool isDesktop) {
    final habitsLayout = AdaptiveHabitsLayout(
      habits: _habits,
      onToggle: _toggleHabit,
    );

    if (isDesktop) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 5, child: habitsLayout),
            const SizedBox(width: 16),
            const Expanded(flex: 3, child: StreakAchievementsCard()),
            const SizedBox(width: 16),
            const Expanded(flex: 4, child: ActivityFeedCard()),
          ],
        ),
      );
    } else if (isTablet) {
      return Column(
        children: [
          habitsLayout,
          const SizedBox(height: 16),
          const IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 1, child: StreakAchievementsCard()),
                SizedBox(width: 16),
                Expanded(flex: 1, child: ActivityFeedCard()),
              ],
            ),
          ),
        ],
      );
    } else {
      // Mobile - Stack Vertically
      return Column(
        children: [
          habitsLayout,
          const SizedBox(height: 16),
          const StreakAchievementsCard(),
          const SizedBox(height: 16),
          const ActivityFeedCard(),
        ],
      );
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 4. Bottom Summary
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildBottomSummarySection(bool isMobile, bool isTablet, bool isDesktop) {
    final cards = [
      _SummaryCard(
        emoji: '👥', label: 'Total Habits', value: '${_habits.length}',
        change: '+ 0%', isPositive: true, delay: 700.ms,
      ),
      _SummaryCard(
        emoji: '🏃', label: 'Active Streaks', value: '${_habits.where((h) => h.streakDays > 7).length}',
        change: '+ 10.4%', isPositive: true, delay: 780.ms,
      ),
      _SummaryCard(
        emoji: '🔄', label: 'Repeat Rate', value: '${DashboardAnalytics.consistency.toInt()}%',
        change: '+ 7.3%', isPositive: true, delay: 860.ms,
      ),
    ];

    if (isDesktop) {
      return Row(
        children: cards.map((c) => Expanded(child: Padding(
          padding: EdgeInsets.only(right: c == cards.last ? 0 : 16),
          child: c,
        ))).toList(),
      );
    } else {
      // Tablet & Mobile - Stack vertically
      return Column(
        children: cards.map((c) => Padding(
          padding: EdgeInsets.only(bottom: c == cards.last ? 0 : 16),
          child: c,
        )).toList(),
      );
    }
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Summary card (bottom row)
// ──────────────────────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.emoji, required this.label, required this.value,
    required this.change, required this.isPositive, required this.delay,
  });
  final String emoji;
  final String label;
  final String value;
  final String change;
  final bool isPositive;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? const Color(0xFF22C55E) : const Color(0xFFEF4444);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: AppColors.glassSurface,
              borderRadius: BorderRadius.circular(14)),
            child: Center(child: Text(emoji,
              style: const TextStyle(fontSize: 24)))),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(value,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 26, fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary, letterSpacing: -0.8)),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(isPositive
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                          size: 10, color: color),
                        Text(' $change',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10, fontWeight: FontWeight.w700,
                            color: color)),
                      ]),
                    ),
                  ],
                ),
                Text('vs last month',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: delay)
        .slideY(begin: 0.2, end: 0, duration: 380.ms,
          delay: delay, curve: Curves.easeOutCubic);
  }
}
