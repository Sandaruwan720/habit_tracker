import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

/// Dynamic motivational panel whose message and color shift based on [fraction].
///
/// Fraction ranges:
///   0.00–0.24 → "Let's build momentum today."
///   0.25–0.49 → "Great start. Keep going."
///   0.50–0.74 → "Halfway there. Stay focused."
///   0.75–0.99 → "You're almost done. Finish strong."
///   1.00       → "Perfect day! Outstanding consistency."
class MotivationBanner extends StatelessWidget {
  const MotivationBanner({super.key, required this.fraction});

  final double fraction;

  _MotivationContent get _content {
    if (fraction >= 1.0) {
      return const _MotivationContent(
        emoji: '🏆',
        headline: 'Perfect Day!',
        body: "Outstanding consistency. Celebrate today's achievement.",
        accentColor: Color(0xFFF59E0B),
        bgColor: Color(0xFF1A1500),
        borderColor: Color(0x33F59E0B),
      );
    } else if (fraction >= 0.75) {
      return const _MotivationContent(
        emoji: '💪',
        headline: "You're Almost Done!",
        body: 'Finish strong. One more habit to go.',
        accentColor: Color(0xFF22C55E),
        bgColor: Color(0xFF0C1A10),
        borderColor: Color(0x3322C55E),
      );
    } else if (fraction >= 0.50) {
      return const _MotivationContent(
        emoji: '🎯',
        headline: 'Halfway There!',
        body: 'Stay focused. You are in the zone.',
        accentColor: Color(0xFF6366F1),
        bgColor: Color(0xFF0E0F2B),
        borderColor: Color(0x336366F1),
      );
    } else if (fraction >= 0.25) {
      return const _MotivationContent(
        emoji: '🚀',
        headline: 'Great Start!',
        body: 'Keep the momentum going. You got this.',
        accentColor: Color(0xFF06B6D4),
        bgColor: Color(0xFF091620),
        borderColor: Color(0x3306B6D4),
      );
    } else {
      return const _MotivationContent(
        emoji: '✨',
        headline: "Let's Build Momentum!",
        body: 'Start strong. Every habit counts today.',
        accentColor: Color(0xFF94A3B8),
        bgColor: Color(0xFF111827),
        borderColor: Color(0x1AFFFFFF),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _content;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: c.bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.borderColor),
        boxShadow: [
          BoxShadow(
            color: c.accentColor.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Emoji glow bubble
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: c.accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: c.accentColor.withValues(alpha: 0.3),
                width: 0.8,
              ),
            ),
            child: Center(
              child: Text(
                c.emoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.headline,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: c.accentColor,
                    letterSpacing: -0.2,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  c.body,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // Progress fraction indicator
          _FractionPill(fraction: fraction, accentColor: c.accentColor),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Fraction pill — shows e.g. "75%"
// ──────────────────────────────────────────────────────────────────────────────

class _FractionPill extends StatelessWidget {
  const _FractionPill({
    required this.fraction,
    required this.accentColor,
  });

  final double fraction;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.25),
          width: 0.8,
        ),
      ),
      child: Text(
        '${(fraction * 100).round()}%',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: accentColor,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Data holder
// ──────────────────────────────────────────────────────────────────────────────

class _MotivationContent {
  const _MotivationContent({
    required this.emoji,
    required this.headline,
    required this.body,
    required this.accentColor,
    required this.bgColor,
    required this.borderColor,
  });

  final String emoji;
  final String headline;
  final String body;
  final Color accentColor;
  final Color bgColor;
  final Color borderColor;
}
