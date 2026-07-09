import 'habit_model.dart';

/// Aggregated daily progress data for the dashboard overview.
class DailyProgressData {
  const DailyProgressData({
    required this.habits,
    required this.streakDays,
    required this.consistencyPercent,
    required this.monthlyPercent,
    required this.longestStreakDays,
  });

  final List<HabitModel> habits;

  /// Current daily streak in days.
  final int streakDays;

  /// Overall consistency percentage (0–100).
  final double consistencyPercent;

  /// Monthly completion percentage (0–100).
  final double monthlyPercent;

  /// Longest ever streak across all habits.
  final int longestStreakDays;

  // ── Derived Metrics ────────────────────────────────────────────────────────

  int get totalHabits => habits.length;

  int get completedCount => habits.where((h) => h.isCompleted).length;

  int get remainingCount => totalHabits - completedCount;

  /// Completion fraction in [0, 1].
  double get completionFraction =>
      totalHabits == 0 ? 0 : completedCount / totalHabits;

  int get completionPercent => (completionFraction * 100).round();

  // ── Sample Fixture ─────────────────────────────────────────────────────────

  /// Pre-populated demo data used while there is no backend.
  static DailyProgressData get sample => DailyProgressData(
        habits: const [
          HabitModel(
            id: 'water',
            name: 'Drink Water',
            emoji: '💧',
            category: 'Health',
            streakDays: 18,
            isCompleted: true,
          ),
          HabitModel(
            id: 'reading',
            name: 'Reading',
            emoji: '📚',
            category: 'Learning',
            streakDays: 42,
            isCompleted: false,
          ),
          HabitModel(
            id: 'workout',
            name: 'Workout',
            emoji: '🏃',
            category: 'Fitness',
            streakDays: 9,
            isCompleted: true,
          ),
          HabitModel(
            id: 'meditation',
            name: 'Meditation',
            emoji: '🧘',
            category: 'Mindfulness',
            streakDays: 27,
            isCompleted: true,
          ),
        ],
        streakDays: 21,
        consistencyPercent: 92,
        monthlyPercent: 82,
        longestStreakDays: 42,
      );

  DailyProgressData copyWithHabits(List<HabitModel> updatedHabits) {
    return DailyProgressData(
      habits: updatedHabits,
      streakDays: streakDays,
      consistencyPercent: consistencyPercent,
      monthlyPercent: monthlyPercent,
      longestStreakDays: longestStreakDays,
    );
  }
}
