import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

/// Top header bar — welcome message, search bar, notifications, profile.
class TopDashboardHeader extends StatelessWidget {
  const TopDashboardHeader({super.key, required this.userName});

  final String userName;

  static const List<String> _dayNames = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];
  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr =
        '${_dayNames[now.weekday - 1]}, ${_monthNames[now.month - 1]} ${now.day}, ${now.year}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E1A),
        border: Border(
          bottom: BorderSide(color: AppColors.glassBorder),
        ),
      ),
      child: Row(
        children: [
          // ── Welcome text ─────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Welcome back, ',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      TextSpan(
                        text: '$userName! ',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.progressGreen,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const TextSpan(text: '👋', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Here's your habit progress for $dateStr.",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms).slideX(
                  begin: -0.1, end: 0, duration: 400.ms, curve: Curves.easeOutCubic),
          ),

          const SizedBox(width: 24),

          // ── Search bar ───────────────────────────────────────────────────
          Container(
            width: 220,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.glassSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(Icons.search_rounded, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Text(
                  'Search anything...',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

          const SizedBox(width: 16),

          // ── Notification bell ────────────────────────────────────────────
          Stack(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.glassSurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Icon(Icons.notifications_rounded,
                  size: 18, color: AppColors.textSecondary),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

          const SizedBox(width: 12),

          // ── Profile chip ─────────────────────────────────────────────────
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.glassSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    gradient: AppColors.accentGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('T',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      )),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  userName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down_rounded,
                  size: 16, color: AppColors.textMuted),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
        ],
      ),
    );
  }
}
