import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/habit_model.dart';
import '../../theme/app_colors.dart';

/// Professional data table for today's habits.
class HabitsDataTable extends StatefulWidget {
  const HabitsDataTable({
    super.key,
    required this.habits,
    required this.onToggle,
  });

  final List<HabitModel> habits;
  final void Function(String id) onToggle;

  @override
  State<HabitsDataTable> createState() => _HabitsDataTableState();
}

class _HabitsDataTableState extends State<HabitsDataTable> {
  int? _hoveredRow;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // ── Header ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Today's Habits",
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
          ),

          const SizedBox(height: 12),

          // ── Column headers ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                _HeaderCell(label: 'HABIT', flex: 3),
                _HeaderCell(label: 'CATEGORY', flex: 2),
                _HeaderCell(label: 'STREAK', flex: 2),
                _HeaderCell(label: 'STATUS', flex: 2),
                _HeaderCell(label: 'ACTION', flex: 1),
              ],
            ),
          ),

          Container(height: 1, color: AppColors.glassBorder),

          // ── Data rows ─────────────────────────────────────────────────────
          ...widget.habits.asMap().entries.map((entry) {
            final idx = entry.key;
            final habit = entry.value;
            return _HabitTableRow(
              habit: habit,
              index: idx,
              isHovered: _hoveredRow == idx,
              onHover: (v) => setState(() => _hoveredRow = v ? idx : null),
              onToggle: () => widget.onToggle(habit.id),
            );
          }),

          // ── Add habit row ─────────────────────────────────────────────────
          Container(height: 1, color: AppColors.glassBorder),
          Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.progressGreen.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.progressGreen.withValues(alpha: 0.25))),
                    child: Row(children: [
                      Icon(Icons.add_rounded,
                        size: 14, color: AppColors.progressGreen),
                      const SizedBox(width: 6),
                      Text('Add New Habit',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12, fontWeight: FontWeight.w600,
                          color: AppColors.progressGreen)),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 400.ms);
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Header cell
// ──────────────────────────────────────────────────────────────────────────────

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.label, required this.flex});
  final String label;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10, fontWeight: FontWeight.w600,
          color: AppColors.textMuted, letterSpacing: 0.8)),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Individual data row
// ──────────────────────────────────────────────────────────────────────────────

class _HabitTableRow extends StatelessWidget {
  const _HabitTableRow({
    required this.habit,
    required this.index,
    required this.isHovered,
    required this.onHover,
    required this.onToggle,
  });
  final HabitModel habit;
  final int index;
  final bool isHovered;
  final void Function(bool) onHover;
  final VoidCallback onToggle;

  static const _categoryColors = {
    'Health': Color(0xFF22C55E),
    'Fitness': Color(0xFF6366F1),
    'Learning': Color(0xFFF59E0B),
    'Mindfulness': Color(0xFF06B6D4),
  };

  @override
  Widget build(BuildContext context) {
    final catColor = _categoryColors[habit.category] ?? AppColors.textSecondary;

    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: isHovered
            ? AppColors.glassSurface.withValues(alpha: 0.5)
            : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              // Habit name + emoji
              Expanded(
                flex: 3,
                child: Row(children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8)),
                    child: Center(child: Text(habit.emoji,
                      style: const TextStyle(fontSize: 15)))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(habit.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: habit.isCompleted
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        decoration: habit.isCompleted
                            ? TextDecoration.lineThrough : null,
                        decorationColor: AppColors.textSecondary))),
                ]),
              ),
              // Category
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: catColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(6)),
                  child: Text(habit.category,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11, fontWeight: FontWeight.w500,
                      color: catColor)),
                ),
              ),
              // Streak
              Expanded(
                flex: 2,
                child: Row(children: [
                  const Text('🔥', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 4),
                  Text('${habit.streakDays}d',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12, fontWeight: FontWeight.w600,
                      color: AppColors.streakOrange)),
                ]),
              ),
              // Status badge
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: habit.isCompleted
                        ? const Color(0xFF22C55E).withValues(alpha: 0.12)
                        : const Color(0xFFF59E0B).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    habit.isCompleted ? 'Completed' : 'Pending',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11, fontWeight: FontWeight.w600,
                      color: habit.isCompleted
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFF59E0B))),
                ),
              ),
              // Toggle button
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: onToggle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: habit.isCompleted
                          ? AppColors.progressGradient : null,
                      border: Border.all(
                        color: habit.isCompleted
                            ? Colors.transparent
                            : AppColors.textMuted.withValues(alpha: 0.4),
                        width: 1.5)),
                    child: Center(
                      child: habit.isCompleted
                          ? const Icon(Icons.check_rounded,
                              size: 14, color: Colors.white)
                          : null),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 350.ms, delay: (500 + index * 80).ms)
        .slideX(begin: 0.05, end: 0, duration: 350.ms,
          delay: (500 + index * 80).ms, curve: Curves.easeOutCubic);
  }
}
