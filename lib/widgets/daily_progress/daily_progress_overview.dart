import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/daily_progress_data.dart';
import '../../theme/app_colors.dart';
import 'header_section.dart';
import 'progress_ring_widget.dart';
import 'daily_stats_grid.dart';
import 'motivation_banner.dart';
import 'habit_quick_list.dart';
import 'monthly_progress_card.dart';
import 'micro_analytics_grid.dart';

/// Root orchestrator for the Daily Progress dashboard section.
///
/// Holds the mutable [_data] state and dispatches habit toggle events
/// downward to [HabitQuickList] → [HabitRow].
///
/// Layout (top to bottom, inside a scrollable column):
///  1. HeaderSection          — title, subtitle, date
///  2. ProgressRingWidget     — hero circular ring
///  3. DailyStatsGrid         — streak / consistency / goal mini cards
///  4. MotivationBanner       — dynamic motivational message
///  5. HabitQuickList         — today's habit cards
///  6. MonthlyProgressCard    — horizontal progress bar
///  7. MicroAnalyticsGrid     — 4-stat analytics strip
class DailyProgressOverview extends StatefulWidget {
  const DailyProgressOverview({super.key});

  @override
  State<DailyProgressOverview> createState() => _DailyProgressOverviewState();
}

class _DailyProgressOverviewState extends State<DailyProgressOverview> {
  DailyProgressData _data = DailyProgressData.sample;

  void _toggleHabit(String habitId) {
    setState(() {
      final updated = _data.habits.map((h) {
        if (h.id == habitId) return h.copyWith(isCompleted: !h.isCompleted);
        return h;
      }).toList();
      _data = _data.copyWithHabits(updated);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Column(
        children: [
          // ── Main premium card ────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // ── 1. Card wrapper (header + ring + stats + banner) ───────
                  _GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        const HeaderSection()
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 50.ms)
                            .slideY(
                              begin: 0.2,
                              end: 0,
                              duration: 380.ms,
                              delay: 50.ms,
                              curve: Curves.easeOutCubic,
                            ),

                        const SizedBox(height: 28),

                        // Hero progress ring
                        ProgressRingWidget(
                          completionFraction: _data.completionFraction,
                          completedCount: _data.completedCount,
                          totalCount: _data.totalHabits,
                        )
                            .animate()
                            .fadeIn(duration: 500.ms, delay: 150.ms)
                            .scale(
                              begin: const Offset(0.85, 0.85),
                              end: const Offset(1, 1),
                              duration: 600.ms,
                              delay: 150.ms,
                              curve: Curves.easeOutBack,
                            ),

                        const SizedBox(height: 28),

                        // Section label
                        _SectionLabel(label: 'Daily Performance'),

                        const SizedBox(height: 12),

                        // Stats grid
                        DailyStatsGrid(data: _data)
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 250.ms)
                            .slideY(
                              begin: 0.3,
                              end: 0,
                              duration: 380.ms,
                              delay: 250.ms,
                              curve: Curves.easeOutCubic,
                            ),

                        const SizedBox(height: 16),

                        // Motivation banner
                        MotivationBanner(
                          fraction: _data.completionFraction,
                        )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 330.ms)
                            .slideY(
                              begin: 0.3,
                              end: 0,
                              duration: 380.ms,
                              delay: 330.ms,
                              curve: Curves.easeOutCubic,
                            ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── 2. Today's Habits ──────────────────────────────────────
                  HabitQuickList(
                    habits: _data.habits,
                    onToggle: _toggleHabit,
                  ),

                  const SizedBox(height: 20),

                  // ── 3. Monthly progress ────────────────────────────────────
                  MonthlyProgressCard(
                    monthlyPercent: _data.monthlyPercent,
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 550.ms)
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        duration: 380.ms,
                        delay: 550.ms,
                        curve: Curves.easeOutCubic,
                      ),

                  const SizedBox(height: 20),

                  // ── 4. Micro analytics ─────────────────────────────────────
                  MicroAnalyticsGrid(data: _data),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Reusable glass card wrapper
// ──────────────────────────────────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.greenGlow.withValues(alpha: 0.4),
            blurRadius: 40,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Section label helper
// ──────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            gradient: AppColors.progressGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
