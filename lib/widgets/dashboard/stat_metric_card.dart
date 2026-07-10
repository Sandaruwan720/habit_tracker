import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

/// Professional KPI metric card — shows value, label, percentage change,
/// an icon, and a mini sparkline bar.
class StatMetricCard extends StatelessWidget {
  const StatMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.change,
    required this.icon,
    required this.gradient,
    required this.glowColor,
    required this.animationDelay,
  });

  final String label;
  final String value;
  final String unit;
  final double change;   // positive = up, negative = down
  final IconData icon;
  final LinearGradient gradient;
  final Color glowColor;
  final Duration animationDelay;

  bool get _isPositive => change >= 0;

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
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: glowColor.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: icon + change badge ────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              _ChangeBadge(change: change, isPositive: _isPositive),
            ],
          ),

          const SizedBox(height: 16),

          // ── Value + unit ─────────────────────────────────────────────────
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -1,
                    height: 1,
                  ),
                ),
                if (unit.isNotEmpty)
                  TextSpan(
                    text: ' $unit',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 14),

          // ── Mini sparkline bars ──────────────────────────────────────────
          _MiniSparkline(gradient: gradient),

          const SizedBox(height: 6),

          Text(
            'vs last week',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: animationDelay)
        .slideY(
          begin: 0.25,
          end: 0,
          duration: 400.ms,
          delay: animationDelay,
          curve: Curves.easeOutCubic,
        );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Change badge
// ──────────────────────────────────────────────────────────────────────────────

class _ChangeBadge extends StatelessWidget {
  const _ChangeBadge({required this.change, required this.isPositive});

  final double change;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    final color = isPositive
        ? const Color(0xFF22C55E)
        : const Color(0xFFEF4444);
    final bg = isPositive
        ? const Color(0xFF22C55E).withValues(alpha: 0.12)
        : const Color(0xFFEF4444).withValues(alpha: 0.12);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            size: 11,
            color: color,
          ),
          const SizedBox(width: 2),
          Text(
            '${change.abs().toStringAsFixed(1)}%',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Mini sparkline
// ──────────────────────────────────────────────────────────────────────────────

class _MiniSparkline extends StatelessWidget {
  const _MiniSparkline({required this.gradient});

  final LinearGradient gradient;

  static const _heights = [0.5, 0.6, 0.45, 0.7, 0.65, 0.8, 0.9, 0.75, 0.85, 0.95, 0.9, 1.0];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: _heights.map((h) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: Container(
                height: 28 * h,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
