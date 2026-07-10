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
import '../widgets/dashboard/habits_data_table.dart';
import '../widgets/dashboard/streak_achievements_card.dart';
import '../widgets/dashboard/activity_feed_card.dart';

/// Full professional analytics dashboard page.
///
/// Layout:
///   [SidebarNav 220px] | [TopDashboardHeader + ScrollableContent]
///
/// Content rows:
///   1. 5 KPI stat cards
///   2. Line chart + Donut chart + Bar chart
///   3. Habits table + Achievements + Activity feed
///   4. Bottom 3-stat summary row
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
  double get _todayCompletion => _habits.isEmpty
      ? 0
      : (_completedCount / _habits.length) * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Row(
        children: [
          // ── Sidebar ──────────────────────────────────────────────────────
          SidebarNav(
            selectedIndex: _selectedNavIndex,
            onItemTap: (i) => setState(() => _selectedNavIndex = i),
          ),

          // ── Main content ─────────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                // Top header
                const TopDashboardHeader(userName: 'Tharuka'),

                // Scrollable body
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Row 1: KPI stat cards ──────────────────────────
                        _buildStatsRow(),

                        const SizedBox(height: 24),

                        // ── Row 2: Charts ──────────────────────────────────
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Line chart — 5 parts
                              const Expanded(
                                flex: 5,
                                child: CompletionLineChart(),
                              ),
                              const SizedBox(width: 16),
                              // Donut chart — 3 parts
                              const Expanded(
                                flex: 3,
                                child: CategoryDonutChart(),
                              ),
                              const SizedBox(width: 16),
                              // Bar chart — 4 parts
                              const Expanded(
                                flex: 4,
                                child: MonthlyBarChart(),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Row 3: Table + Cards ───────────────────────────
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Habits data table — 5 parts
                              Expanded(
                                flex: 5,
                                child: HabitsDataTable(
                                  habits: _habits,
                                  onToggle: _toggleHabit,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Achievements — 3 parts
                              const Expanded(
                                flex: 3,
                                child: StreakAchievementsCard(),
                              ),
                              const SizedBox(width: 16),
                              // Activity feed — 4 parts
                              const Expanded(
                                flex: 4,
                                child: ActivityFeedCard(),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Row 4: Bottom summary ──────────────────────────
                        _buildBottomSummaryRow(),

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
  // Stats row — 5 KPI cards
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: StatMetricCard(
            label: 'Current Streak',
            value: '${DashboardAnalytics.currentStreak}',
            unit: 'Days',
            change: DashboardAnalytics.streakChange,
            icon: Icons.local_fire_department_rounded,
            gradient: AppColors.streakGradient,
            glowColor: AppColors.orangeGlow,
            animationDelay: 50.ms,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatMetricCard(
            label: "Today's Progress",
            value: '${_todayCompletion.toInt()}',
            unit: '%',
            change: DashboardAnalytics.completionChange,
            icon: Icons.donut_large_rounded,
            gradient: AppColors.progressGradient,
            glowColor: AppColors.greenGlow,
            animationDelay: 120.ms,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatMetricCard(
            label: 'Habits Completed',
            value: '$_completedCount / ${_habits.length}',
            unit: '',
            change: DashboardAnalytics.completedChange,
            icon: Icons.check_circle_rounded,
            gradient: AppColors.progressGradient,
            glowColor: AppColors.greenGlow,
            animationDelay: 190.ms,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatMetricCard(
            label: 'Consistency',
            value: '${DashboardAnalytics.consistency.toInt()}',
            unit: '%',
            change: DashboardAnalytics.consistencyChange,
            icon: Icons.stars_rounded,
            gradient: AppColors.accentGradient,
            glowColor: AppColors.indigoGlow,
            animationDelay: 260.ms,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatMetricCard(
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
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Bottom summary — 3 wide info cards
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildBottomSummaryRow() {
    return Row(
      children: [
        Expanded(child: _SummaryCard(
          emoji: '👥',
          label: 'Total Habits',
          value: '${_habits.length}',
          change: '+ 0%',
          isPositive: true,
          delay: 700.ms,
        )),
        const SizedBox(width: 16),
        Expanded(child: _SummaryCard(
          emoji: '🏃',
          label: 'Active Streaks',
          value: '${_habits.where((h) => h.streakDays > 7).length}',
          change: '+ 10.4%',
          isPositive: true,
          delay: 780.ms,
        )),
        const SizedBox(width: 16),
        Expanded(child: _SummaryCard(
          emoji: '🔄',
          label: 'Repeat Rate',
          value: '${DashboardAnalytics.consistency.toInt()}%',
          change: '+ 7.3%',
          isPositive: true,
          delay: 860.ms,
        )),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Summary card (bottom row)
// ──────────────────────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.emoji,
    required this.label,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.delay,
  });
  final String emoji;
  final String label;
  final String value;
  final String change;
  final bool isPositive;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final color = isPositive
        ? const Color(0xFF22C55E) : const Color(0xFFEF4444);

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
