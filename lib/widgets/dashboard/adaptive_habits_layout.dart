import 'package:flutter/material.dart';
import '../../models/habit_model.dart';
import 'habit_mobile_card.dart';
import 'habits_data_table.dart';

/// An adaptive layout that switches between a mobile card list,
/// a tablet grid, and a desktop data table based on available width.
class AdaptiveHabitsLayout extends StatelessWidget {
  const AdaptiveHabitsLayout({
    super.key,
    required this.habits,
    required this.onToggle,
  });

  final List<HabitModel> habits;
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
              return HabitMobileCard(
                habit: entry.value,
                index: entry.key,
                onToggle: () => onToggle(entry.value.id),
              );
            }).toList(),
          );
        } else if (width < 1000) {
          // ── Tablet: 2-column grid of cards ─────────────────────────────────
          // Since we might be inside an IntrinsicHeight or ScrollView,
          // we use a Wrap instead of GridView to avoid nested scrolling issues.
          return Wrap(
            spacing: 16,
            runSpacing: 0, // HabitMobileCard already has bottom margin
            children: habits.asMap().entries.map((entry) {
              return SizedBox(
                width: (width - 16) / 2, // 2 columns with 16px spacing
                child: HabitMobileCard(
                  habit: entry.value,
                  index: entry.key,
                  onToggle: () => onToggle(entry.value.id),
                ),
              );
            }).toList(),
          );
        } else {
          // ── Desktop: Professional Data Table ───────────────────────────────
          return HabitsDataTable(
            habits: habits,
            onToggle: onToggle,
          );
        }
      },
    );
  }
}
