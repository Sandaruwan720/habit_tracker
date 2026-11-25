import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/habits/domain/entities/habit_entity.dart';
import '../../theme/app_colors.dart';

// Icon → emoji map for dashboard cards
const _kDashIconMap = <String, String>{
  'check_circle': '✅',
  'fitness': '🏋️',
  'book': '📚',
  'water': '💧',
  'bed': '😴',
  'run': '🏃',
  'meditate': '🧘',
  'food': '🍎',
  'code': '💻',
  'music': '🎵',
};

/// A compact, responsive card layout for a single habit.
/// Used on Mobile and Tablet layouts inside the Dashboard.
class HabitMobileCard extends StatelessWidget {
  const HabitMobileCard({
    super.key,
    required this.habit,
    required this.isCompleted,
    required this.index,
    required this.onToggle,
  });

  final HabitEntity habit;
  final bool isCompleted;
  final int index;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final color = Color(habit.color);
    final emoji = _kDashIconMap[habit.icon] ?? '✅';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? color.withValues(alpha: 0.35)
              : AppColors.glassBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Emoji Icon ──────────────────────────────────────────────────────
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 20)),
            ),
          ),

          const SizedBox(width: 14),

          // ── Details ─────────────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isCompleted
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                    decoration:
                        isCompleted ? TextDecoration.lineThrough : null,
                    decorationColor: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    // Frequency Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        habit.frequency,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                    if (habit.description != null &&
                        habit.description!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          habit.description!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ── Toggle Button ────────────────────────────────────────────────────
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? color : Colors.transparent,
                border: Border.all(
                  color: isCompleted
                      ? Colors.transparent
                      : AppColors.textMuted.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check_rounded,
                        size: 18, color: Colors.white)
                    : null,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: (index * 60).ms)
        .slideX(
          begin: 0.05,
          end: 0,
          duration: 300.ms,
          delay: (index * 60).ms,
          curve: Curves.easeOutCubic,
        );
  }
}
