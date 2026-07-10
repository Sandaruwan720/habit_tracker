import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/habit_model.dart';
import '../../theme/app_colors.dart';

/// A compact, responsive card layout for a single habit.
/// Used on Mobile and Tablet layouts.
class HabitMobileCard extends StatefulWidget {
  const HabitMobileCard({
    super.key,
    required this.habit,
    required this.index,
    required this.onToggle,
  });

  final HabitModel habit;
  final int index;
  final VoidCallback onToggle;

  @override
  State<HabitMobileCard> createState() => _HabitMobileCardState();
}

class _HabitMobileCardState extends State<HabitMobileCard> {
  static const _categoryColors = {
    'Health': Color(0xFF22C55E),
    'Fitness': Color(0xFF6366F1),
    'Learning': Color(0xFFF59E0B),
    'Mindfulness': Color(0xFF06B6D4),
  };

  @override
  Widget build(BuildContext context) {
    final habit = widget.habit;
    final catColor = _categoryColors[habit.category] ?? AppColors.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
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
          // ── Emoji Icon ────────────────────────────────────────────────────
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: catColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(habit.emoji, style: const TextStyle(fontSize: 20)),
            ),
          ),
          
          const SizedBox(width: 14),
          
          // ── Details ───────────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: habit.isCompleted
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                    decoration: habit.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        habit.category,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: catColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Streak Badge
                    Row(
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 10)),
                        const SizedBox(width: 4),
                        Text(
                          '${habit.streakDays}d',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.streakOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // ── Toggle Button ─────────────────────────────────────────────────
          GestureDetector(
            onTap: widget.onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: habit.isCompleted ? AppColors.progressGradient : null,
                border: Border.all(
                  color: habit.isCompleted
                      ? Colors.transparent
                      : AppColors.textMuted.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: habit.isCompleted
                    ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
                    : null,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: (widget.index * 60).ms)
        .slideX(
          begin: 0.05,
          end: 0,
          duration: 300.ms,
          delay: (widget.index * 60).ms,
          curve: Curves.easeOutCubic,
        );
  }
}
