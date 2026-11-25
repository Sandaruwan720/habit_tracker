import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

/// Achievements & streak milestone card — driven by real data passed in.
class StreakAchievementsCard extends StatelessWidget {
  const StreakAchievementsCard({
    super.key,
    required this.completedCount,
    required this.totalCount,
    required this.completionPercent,
  });

  final int completedCount;
  final int totalCount;
  final double completionPercent;

  @override
  Widget build(BuildContext context) {
    final achievements = [
      _AchievementData(
        title: "Today's Goal",
        subtitle: '$completedCount of $totalCount habits done',
        icon: '✅',
      ),
      _AchievementData(
        title: completionPercent >= 100 ? 'All Done! 🎉' : 'Keep Going!',
        subtitle: completionPercent >= 100
            ? 'Amazing — full day streak!'
            : '${completionPercent.toInt()}% complete today',
        icon: completionPercent >= 100 ? '🏆' : '🔥',
      ),
      _AchievementData(
        title: 'Total Habits',
        subtitle: '$totalCount active habits tracked',
        icon: '📋',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Achievements',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2)),

          const SizedBox(height: 14),

          ...achievements.asMap().entries.map((e) => _AchievementTile(
                data: e.value,
                delay: (500 + e.key * 80).ms,
              )),

          const SizedBox(height: 16),

          // ── Today's progress ring ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.progressGreen.withValues(alpha: 0.08),
                  AppColors.accentPurple.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 52,
                  height: 52,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: totalCount == 0
                            ? 0
                            : completionPercent / 100,
                        strokeWidth: 5,
                        backgroundColor: AppColors.glassBorder,
                        valueColor: AlwaysStoppedAnimation(
                          completionPercent >= 100
                              ? const Color(0xFF22C55E)
                              : const Color(0xFF6366F1),
                        ),
                      ),
                      Text(
                        '${completionPercent.toInt()}%',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.progressGreen),
                      ),
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
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 3),
                      Text('$completedCount of $totalCount habits done',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppColors.textSecondary)),
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

class _AchievementData {
  const _AchievementData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
  final String title;
  final String subtitle;
  final String icon;
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({required this.data, required this.delay});
  final _AchievementData data;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: AppColors.glassSurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.glassBorder)),
              child: Center(
                  child:
                      Text(data.icon, style: const TextStyle(fontSize: 17)))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.title,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                Text(data.subtitle,
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
