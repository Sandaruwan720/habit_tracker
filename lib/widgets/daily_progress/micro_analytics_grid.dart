import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/daily_progress_data.dart';
import '../../theme/app_colors.dart';

/// Four-column analytics strip — each card counts up independently.
///
///  Completed | Remaining | Longest Streak | Consistency
class MicroAnalyticsGrid extends StatelessWidget {
  const MicroAnalyticsGrid({super.key, required this.data});

  final DailyProgressData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analytics',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _AnalyticsCard(
                label: 'Completed',
                value: '${data.completedCount}',
                icon: Icons.check_circle_rounded,
                gradient: AppColors.progressGradient,
                glowColor: AppColors.greenGlow,
                delay: 600.ms,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _AnalyticsCard(
                label: 'Remaining',
                value: '${data.remainingCount}',
                icon: Icons.radio_button_unchecked_rounded,
                gradient: const LinearGradient(
                  colors: [Color(0xFF475569), Color(0xFF334155)],
                ),
                glowColor: Colors.transparent,
                delay: 680.ms,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _AnalyticsCard(
                label: 'Longest',
                value: '${data.longestStreakDays}d',
                icon: Icons.local_fire_department_rounded,
                gradient: AppColors.streakGradient,
                glowColor: AppColors.orangeGlow,
                delay: 760.ms,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _AnalyticsCard(
                label: 'Consistency',
                value: '${data.consistencyPercent.toInt()}%',
                icon: Icons.stars_rounded,
                gradient: AppColors.accentGradient,
                glowColor: AppColors.indigoGlow,
                delay: 840.ms,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Individual analytics card
// ──────────────────────────────────────────────────────────────────────────────

class _AnalyticsCard extends StatelessWidget {
  const _AnalyticsCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradient,
    required this.glowColor,
    required this.delay,
  });

  final String label;
  final String value;
  final IconData icon;
  final LinearGradient gradient;
  final Color glowColor;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: glowColor,
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Gradient icon
          ShaderMask(
            shaderCallback: (b) => gradient.createShader(b),
            child: Icon(icon, size: 20, color: Colors.white),
          ),

          const SizedBox(height: 8),

          // Value
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
              height: 1,
            ),
          ),

          const SizedBox(height: 3),

          // Label
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
              height: 1.3,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: delay)
        .slideY(
          begin: 0.4,
          end: 0,
          duration: 380.ms,
          delay: delay,
          curve: Curves.easeOutCubic,
        )
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          duration: 380.ms,
          delay: delay,
          curve: Curves.easeOutBack,
        );
  }
}
