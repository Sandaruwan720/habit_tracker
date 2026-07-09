import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/habit_model.dart';
import '../../theme/app_colors.dart';
import 'habit_row.dart';

/// Section header + staggered list of [HabitRow] cards.
class HabitQuickList extends StatelessWidget {
  const HabitQuickList({
    super.key,
    required this.habits,
    required this.onToggle,
  });

  final List<HabitModel> habits;

  /// Called with the habit [id] when the user taps its toggle.
  final void Function(String id) onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ─────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Habits",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.progressGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      AppColors.progressGreen.withValues(alpha: 0.25),
                  width: 0.8,
                ),
              ),
              child: Text(
                '${habits.where((h) => h.isCompleted).length}/${habits.length} Done',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.progressGreen,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ── Habit cards (staggered) ─────────────────────────────────────────
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: habits.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final habit = habits[index];
            return HabitRow(
              habit: habit,
              onToggle: () => onToggle(habit.id),
            )
                .animate()
                .fadeIn(
                  duration: 400.ms,
                  delay: (400 + index * 80).ms,
                )
                .slideY(
                  begin: 0.3,
                  end: 0,
                  duration: 380.ms,
                  delay: (400 + index * 80).ms,
                  curve: Curves.easeOutCubic,
                );
          },
        ),
      ],
    );
  }
}
