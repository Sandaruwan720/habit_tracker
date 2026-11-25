import 'package:flutter/material.dart';
import '../../features/habits/domain/entities/habit_entity.dart';
import 'habit_mobile_card.dart';
import 'habits_data_table.dart';

/// An adaptive layout that switches between a mobile card list,
/// a tablet grid, and a desktop data table based on available width.
class AdaptiveHabitsLayout extends StatelessWidget {
  const AdaptiveHabitsLayout({
    super.key,
    required this.habits,
    required this.completedIds,
    required this.onToggle,
  });

  final List<HabitEntity> habits;
  final Set<String> completedIds;
  final void Function(String id) onToggle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width < 600) {
          // ── Mobile: Vertical list of cards ─────────────────────────────────
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: habits.asMap().entries.map((entry) {
              final habit = entry.value;
              return HabitMobileCard(
                habit: habit,
                isCompleted: completedIds.contains(habit.id),
                index: entry.key,
                onToggle: () => onToggle(habit.id),
              );
            }).toList(),
          );
        } else if (width < 1000) {
          // ── Tablet: 2-column grid of cards ─────────────────────────────────
          return Wrap(
            spacing: 16,
            runSpacing: 0,
            children: habits.asMap().entries.map((entry) {
              final habit = entry.value;
              return SizedBox(
                width: (width - 16) / 2,
                child: HabitMobileCard(
                  habit: habit,
                  isCompleted: completedIds.contains(habit.id),
                  index: entry.key,
                  onToggle: () => onToggle(habit.id),
                ),
              );
            }).toList(),
          );
        } else {
          // ── Desktop: Professional Data Table ───────────────────────────────
          return HabitsDataTable(
            habits: habits,
            completedIds: completedIds,
            onToggle: onToggle,
          );
        }
      },
    );
  }
}
