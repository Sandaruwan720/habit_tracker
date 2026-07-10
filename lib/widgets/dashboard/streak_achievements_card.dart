import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/dashboard_analytics.dart';
import '../../theme/app_colors.dart';

/// Achievements & streak milestone card.
class StreakAchievementsCard extends StatelessWidget {
  const StreakAchievementsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = DashboardAnalytics.achievements;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Achievements',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary, letterSpacing: -0.2)),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text('View all',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11, fontWeight: FontWeight.w600,
                    color: AppColors.progressGreen)),
              ),
            ],
          ),

          const SizedBox(height: 14),

          ...achievements.asMap().entries.map((e) =>
            _AchievementTile(
              entry: e.value,
              delay: (500 + e.key * 80).ms,
            )),

          const SizedBox(height: 16),

          // ── Weekly streak ring progress ────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.progressGreen.withValues(alpha: 0.08),
                  AppColors.accentPurple.withValues(alpha: 0.08),
                ]),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.glassBorder)),
            child: Row(
              children: [
                SizedBox(
                  width: 52, height: 52,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: 0.75,
                        strokeWidth: 5,
                        backgroundColor: AppColors.glassBorder,
                        valueColor: const AlwaysStoppedAnimation(Color(0xFF22C55E)),
                      ),
                      Text('75%',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10, fontWeight: FontWeight.w700,
                          color: AppColors.progressGreen)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Today's Goal",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12, fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                      const SizedBox(height: 3),
                      Text('3 of 4 habits done',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 450.ms);
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({required this.entry, required this.delay});
  final AchievementEntry entry;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: AppColors.glassSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.glassBorder)),
            child: Center(
              child: Text(entry.icon, style: const TextStyle(fontSize: 17)))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
                Text(entry.subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
            size: 16, color: AppColors.textMuted),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms, delay: delay);
  }
}
