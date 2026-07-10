import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/dashboard_analytics.dart';
import '../../theme/app_colors.dart';

/// Recent activity feed — shows today's habit completions / pending items.
class ActivityFeedCard extends StatelessWidget {
  const ActivityFeedCard({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = DashboardAnalytics.recentActivity;

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
              Text('Recent Activity',
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

          ...activities.asMap().entries.map((e) => _ActivityTile(
            entry: e.value,
            delay: (550 + e.key * 70).ms,
          )),

          const SizedBox(height: 14),

          // ── Consistency bar ───────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.glassSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.glassBorder)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Monthly Consistency',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11, fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary)),
                    ShaderMask(
                      shaderCallback: (b) =>
                        AppColors.progressGradient.createShader(b),
                      child: Text('92%',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13, fontWeight: FontWeight.w700,
                          color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: 0.92,
                    minHeight: 6,
                    backgroundColor: AppColors.glassBorder,
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF22C55E)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 500.ms);
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.entry, required this.delay});
  final ActivityEntry entry;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final color = entry.isCompleted
        ? const Color(0xFF22C55E)
        : const Color(0xFFF59E0B);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.2))),
            child: Center(
              child: Text(entry.emoji,
                style: const TextStyle(fontSize: 17)))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.habitName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12, fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
                Text(entry.time,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10, color: AppColors.textMuted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6)),
            child: Text(entry.action,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10, fontWeight: FontWeight.w600,
                color: color)),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms, delay: delay);
  }
}
