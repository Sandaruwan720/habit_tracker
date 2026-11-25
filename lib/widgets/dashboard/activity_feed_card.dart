import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/habits/domain/entities/habit_entity.dart';
import '../../theme/app_colors.dart';

const _kActivityIconMap = <String, String>{
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

/// Recent activity feed — shows today's habits with their real completion status.
class ActivityFeedCard extends StatelessWidget {
  const ActivityFeedCard({
    super.key,
    required this.habits,
    required this.completedIds,
    required this.completionPercent,
  });

  final List<HabitEntity> habits;
  final Set<String> completedIds;
  final double completionPercent;

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
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recent Activity',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2)),

          const SizedBox(height: 14),

          if (habits.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No habits yet. Add one from the Today tab!',
                style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textMuted, fontSize: 12),
              ),
            )
          else
            ...habits.take(5).toList().asMap().entries.map((e) {
              final habit = e.value;
              final isCompleted = completedIds.contains(habit.id);
              return _ActivityTile(
                habit: habit,
                isCompleted: isCompleted,
                delay: (550 + e.key * 70).ms,
              );
            }),

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
                    Text("Today's Progress",
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary)),
                    ShaderMask(
                      shaderCallback: (b) =>
                          AppColors.progressGradient.createShader(b),
                      child: Text('${completionPercent.toInt()}%',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: completionPercent / 100,
                    minHeight: 6,
                    backgroundColor: AppColors.glassBorder,
                    valueColor: AlwaysStoppedAnimation(
                      completionPercent >= 100
                          ? const Color(0xFF22C55E)
                          : const Color(0xFF6366F1),
                    ),
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
  const _ActivityTile({
    required this.habit,
    required this.isCompleted,
    required this.delay,
  });
  final HabitEntity habit;
  final bool isCompleted;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final color = isCompleted
        ? const Color(0xFF22C55E)
        : const Color(0xFFF59E0B);
    final emoji = _kActivityIconMap[habit.icon] ?? '✅';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withValues(alpha: 0.2))),
              child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 17)))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(habit.name,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                Text(
                  habit.frequency,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6)),
            child: Text(
              isCompleted ? 'Done' : 'Pending',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: color),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms, delay: delay);
  }
}
