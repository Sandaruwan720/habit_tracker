import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// Animated logo + welcome text displayed at the top of the auth panel.
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Logo ─────────────────────────────────────────────────────────────
        Row(
          children: [
            _LogoMark(),
            const SizedBox(width: 10),
            Text(
              'HabitFlow',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: -0.2, end: 0),

        const SizedBox(height: 36),

        // ── Welcome heading ───────────────────────────────────────────────────
        Text(
          'Welcome Back 👋',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            height: 1.1,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 150.ms)
            .slideX(begin: -0.1, end: 0),

        const SizedBox(height: 10),

        // ── Subtitle ──────────────────────────────────────────────────────────
        Text(
          'Continue building your daily consistency.',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF94A3B8),
            fontSize: 15,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 250.ms)
            .slideX(begin: -0.1, end: 0),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Logo mark — animated green ring with check icon
// ─────────────────────────────────────────────────────────────────────────────

class _LogoMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF22C55E), Color(0xFF10B981)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF22C55E).withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.check_rounded,
        color: Colors.white,
        size: 22,
      ),
    ).animate().scale(
          begin: const Offset(0.5, 0.5),
          end: const Offset(1, 1),
          duration: 600.ms,
          curve: Curves.elasticOut,
        );
  }
}
