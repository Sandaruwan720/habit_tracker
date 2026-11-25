import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/providers/habits_provider.dart';
import '../features/habits/domain/entities/habit_entity.dart';
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

/// Full professional analytics dashboard page — connected to real HabitsProvider.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedNavIndex = 0;

  // Derive username from Supabase email (part before @)
  String get _displayName {
    final email =
        Supabase.instance.client.auth.currentUser?.email ?? '';
    if (email.contains('@')) {
      final name = email.split('@').first;
      return name[0].toUpperCase() + name.substring(1);
    }
    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    final isTablet = screenWidth >= 800 && screenWidth < 1200;
    final isDesktop = screenWidth >= 1200;

    return Consumer<HabitsProvider>(
      builder: (context, provider, _) {
        final habits = provider.habits.toList();
        final completedIds = {
          for (final h in habits)
            if (provider.isCompletedToday(h.id)) h.id,
        };
        final completedCount = completedIds.length;
        final totalCount = habits.length;
        final completionPercent = provider.todayCompletionPercent;

        return Scaffold(
          backgroundColor: const Color(0xFF0A0E1A),
          // No bottom nav here — AppShell provides it
          body: Row(
            children: [
              // ── Sidebar (Tablet & Desktop only) ──────────────────────────
              if (!isMobile)
                SidebarNav(
                  selectedIndex: _selectedNavIndex,
                  onItemTap: (i) => setState(() => _selectedNavIndex = i),
                ),

              // ── Main Content ──────────────────────────────────────────────
              Expanded(
                child: Column(
                  children: [
                    TopDashboardHeader(userName: _displayName),
                    Expanded(
                      child: provider.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Color(0xFF6366F1)))
                          : provider.errorMessage != null
                              ? _ErrorView(
                                  message: provider.errorMessage!,
                                  onRetry: () => provider.loadHabits(),
                                )
                              : SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 1. KPI Stats
                                      _buildStatsSection(
                                          isMobile,
                                          isTablet,
                                          isDesktop,
                                          completedCount,
                                          totalCount,
                                          completionPercent),
                                      const SizedBox(height: 24),

                                      // 2. Charts
                                      _buildChartsSection(
                                          isMobile, isTablet, isDesktop),
                                      const SizedBox(height: 24),

                                      // 3. Habits + Achievements + Activity
                                      _buildHabitsSection(
                                          isMobile,
                                          isTablet,
                                          isDesktop,
                                          habits,
                                          completedIds,
                                          completedCount,
                                          totalCount,
                                          completionPercent,
                                          provider),
                                      const SizedBox(height: 24),

                                      // 4. Bottom Summary
                                      _buildBottomSummarySection(
                                          isMobile,
                                          isTablet,
                                          isDesktop,
                                          completedCount,
                                          totalCount,
                                          completionPercent),
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
      },
    );
  }

  // ── 1. Stats Section ──────────────────────────────────────────────────────

  Widget _buildStatsSection(
    bool isMobile,
    bool isTablet,
    bool isDesktop,
    int completedCount,
    int totalCount,
    double completionPercent,
  ) {
    final cards = [
      StatMetricCard(
        label: "Today's Progress",
        value: '${completionPercent.toInt()}',
        unit: '%',
        change: 0,
        icon: Icons.donut_large_rounded,
        gradient: AppColors.progressGradient,
        glowColor: AppColors.greenGlow,
        animationDelay: 50.ms,
      ),
      StatMetricCard(
        label: 'Habits Completed',
        value: '$completedCount / $totalCount',
        unit: '',
        change: 0,
        icon: Icons.check_circle_rounded,
        gradient: AppColors.progressGradient,
        glowColor: AppColors.greenGlow,
        animationDelay: 120.ms,
      ),
      StatMetricCard(
        label: 'Total Habits',
        value: '$totalCount',
        unit: '',
        change: 0,
        icon: Icons.list_alt_rounded,
        gradient: AppColors.accentGradient,
        glowColor: AppColors.indigoGlow,
        animationDelay: 190.ms,
      ),
      StatMetricCard(
        label: 'Remaining Today',
        value: '${totalCount - completedCount}',
        unit: '',
        change: 0,
        icon: Icons.pending_actions_rounded,
        gradient: AppColors.streakGradient,
        glowColor: AppColors.orangeGlow,
        animationDelay: 260.ms,
      ),
    ];

    if (isDesktop) {
      return Row(
        children: cards
            .map((c) => Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.only(right: c == cards.last ? 0 : 16),
                    child: c,
                  ),
                ))
            .toList(),
      );
    } else if (isTablet) {
      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: cards
            .map((c) => SizedBox(
                  width: MediaQuery.of(context).size.width / 2 -
                      (220 / 2) -
                      40,
                  child: c,
                ))
            .toList(),
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.none,
        child: Row(
          children: cards
              .map((c) => Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SizedBox(width: 160, child: c),
                  ))
              .toList(),
        ),
      );
    }
  }

  // ── 2. Charts Section ─────────────────────────────────────────────────────

  Widget _buildChartsSection(
      bool isMobile, bool isTablet, bool isDesktop) {
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

  // ── 3. Habits Section ─────────────────────────────────────────────────────

  Widget _buildHabitsSection(
    bool isMobile,
    bool isTablet,
    bool isDesktop,
    List<HabitEntity> habits,
    Set<String> completedIds,
    int completedCount,
    int totalCount,
    double completionPercent,
    HabitsProvider provider,
  ) {
    final habitsLayout = AdaptiveHabitsLayout(
      habits: habits,
      completedIds: completedIds,
      onToggle: (id) => provider.toggleTodayCompletion(id),
    );

    final achievementsCard = StreakAchievementsCard(
      completedCount: completedCount,
      totalCount: totalCount,
      completionPercent: completionPercent,
    );

    final activityCard = ActivityFeedCard(
      habits: habits,
      completedIds: completedIds,
      completionPercent: completionPercent,
    );

    if (isDesktop) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 5, child: habitsLayout),
            const SizedBox(width: 16),
            Expanded(flex: 3, child: achievementsCard),
            const SizedBox(width: 16),
            Expanded(flex: 4, child: activityCard),
          ],
        ),
      );
    } else if (isTablet) {
      return Column(
        children: [
          habitsLayout,
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 1, child: achievementsCard),
                const SizedBox(width: 16),
                Expanded(flex: 1, child: activityCard),
              ],
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          habitsLayout,
          const SizedBox(height: 16),
          achievementsCard,
          const SizedBox(height: 16),
          activityCard,
        ],
      );
    }
  }

  // ── 4. Bottom Summary ─────────────────────────────────────────────────────

  Widget _buildBottomSummarySection(
    bool isMobile,
    bool isTablet,
    bool isDesktop,
    int completedCount,
    int totalCount,
    double completionPercent,
  ) {
    final cards = [
      _SummaryCard(
        emoji: '👥',
        label: 'Total Habits',
        value: '$totalCount',
        sub: 'active habits',
        delay: 700.ms,
      ),
      _SummaryCard(
        emoji: '✅',
        label: 'Done Today',
        value: '$completedCount',
        sub: 'of $totalCount completed',
        delay: 780.ms,
      ),
      _SummaryCard(
        emoji: '📊',
        label: 'Progress',
        value: '${completionPercent.toInt()}%',
        sub: 'today\'s completion',
        delay: 860.ms,
      ),
    ];

    if (isDesktop) {
      return Row(
        children: cards
            .map((c) => Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.only(right: c == cards.last ? 0 : 16),
                    child: c,
                  ),
                ))
            .toList(),
      );
    } else {
      return Column(
        children: cards
            .map((c) => Padding(
                  padding:
                      EdgeInsets.only(bottom: c == cards.last ? 0 : 16),
                  child: c,
                ))
            .toList(),
      );
    }
  }
}

// ── Error View ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded,
              color: Color(0xFF64748B), size: 48),
          const SizedBox(height: 12),
          Text(message,
              style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF64748B)),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onRetry,
            child: Text('Retry',
                style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF6366F1))),
          ),
        ],
      ),
    );
  }
}

// ── Summary card (bottom row) ─────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.emoji,
    required this.label,
    required this.value,
    required this.sub,
    required this.delay,
  });
  final String emoji;
  final String label;
  final String value;
  final String sub;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                  color: AppColors.glassSurface,
                  borderRadius: BorderRadius.circular(14)),
              child: Center(
                  child: Text(emoji,
                      style: const TextStyle(fontSize: 24)))),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(value,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.8)),
                Text(sub,
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
        .slideY(
            begin: 0.2,
            end: 0,
            duration: 380.ms,
            delay: delay,
            curve: Curves.easeOutCubic);
  }
}
