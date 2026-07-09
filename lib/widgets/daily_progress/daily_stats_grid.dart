import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../models/daily_progress_data.dart';

/// 2-row grid of premium mini stat glass cards.
///
/// Row 1: 🔥 Streak  |  ⭐ Consistency  |  🎯 Daily Goal
/// Row 2: ✅ Completed  |  ○ Remaining
class DailyStatsGrid extends StatelessWidget {
  const DailyStatsGrid({super.key, required this.data});

  final DailyProgressData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1 — 3 equal cards
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _StatCard(
                  emoji: '🔥',
                  label: 'Current Streak',
                  value: '${data.streakDays}',
                  unit: 'Days',
                  gradient: AppColors.streakGradient,
                  glowColor: AppColors.orangeGlow,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  emoji: '⭐',
                  label: 'Consistency',
                  value: '${data.consistencyPercent.toInt()}',
                  unit: '%',
                  gradient: AppColors.accentGradient,
                  glowColor: AppColors.indigoGlow,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  emoji: '🎯',
                  label: 'Daily Goal',
                  value: '${data.totalHabits}',
                  unit: 'Habits',
                  gradient: AppColors.progressGradient,
                  glowColor: AppColors.greenGlow,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Row 2 — 2 wide cards
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _StatCard(
                  emoji: '✅',
                  label: 'Completed',
                  value: '${data.completedCount}',
                  unit: 'Today',
                  gradient: AppColors.progressGradient,
                  glowColor: AppColors.greenGlow,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  emoji: '○',
                  label: 'Remaining',
                  value: '${data.remainingCount}',
                  unit: 'Habits',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF64748B), Color(0xFF475569)],
                  ),
                  glowColor: Colors.transparent,
                  isSubdued: data.remainingCount == 0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Individual stat card
// ──────────────────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.emoji,
    required this.label,
    required this.value,
    required this.unit,
    required this.gradient,
    required this.glowColor,
    this.isSubdued = false,
  });

  final String emoji;
  final String label;
  final String value;
  final String unit;
  final LinearGradient gradient;
  final Color glowColor;
  final bool isSubdued;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          if (!isSubdued)
            BoxShadow(
              color: glowColor,
              blurRadius: 20,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emoji icon in gradient container
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: isSubdued ? null : gradient,
              color: isSubdued
                  ? const Color(0xFF1E293B)
                  : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Value + unit
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: isSubdued
                        ? AppColors.textMuted
                        : AppColors.textPrimary,
                    letterSpacing: -0.5,
                    height: 1,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 2),

          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
