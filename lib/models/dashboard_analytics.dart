import '../models/habit_model.dart';

/// All analytics / fixture data powering the professional dashboard.
class DashboardAnalytics {
  DashboardAnalytics._();

  // ── Top-level KPIs ─────────────────────────────────────────────────────────
  static const int currentStreak = 21;
  static const double todayCompletion = 75.0;   // percent
  static const int completedToday = 3;
  static const int totalHabits = 4;
  static const double consistency = 92.0;        // percent
  static const int bestStreak = 42;
  static const double monthlyCompletion = 82.0;  // percent

  // ── Streak change vs last week ─────────────────────────────────────────────
  static const double streakChange = 16.7;       // +16.7 %
  static const double completionChange = 8.2;
  static const double completedChange = -25.0;   // one fewer today vs yesterday
  static const double consistencyChange = 3.1;
  static const double bestStreakChange = 5.0;

  // ── 12-month completion % (Jan → Dec) ─────────────────────────────────────
  static const List<double> monthlyCompletionHistory = [
    68, 72, 65, 78, 80, 77,
    85, 82, 88, 90, 87, 92,
  ];

  static const List<String> monthLabels = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  // ── Weekly completion count Mon→Sun (habits completed per day) ─────────────
  static const List<double> weeklyCompletion = [4, 3, 4, 2, 4, 3, 4];
  static const List<String> dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  // ── Category breakdown (for donut chart) ──────────────────────────────────
  static const List<CategoryStat> categoryStats = [
    CategoryStat(name: 'Health',      value: 28, colorHex: 0xFF22C55E),
    CategoryStat(name: 'Fitness',     value: 32, colorHex: 0xFF6366F1),
    CategoryStat(name: 'Learning',    value: 22, colorHex: 0xFFF59E0B),
    CategoryStat(name: 'Mindfulness', value: 18, colorHex: 0xFF06B6D4),
  ];

  // ── Habits fixture (matches HabitModel) ────────────────────────────────────
  static const List<HabitModel> habits = [
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
  ];

  // ── Recent activity feed ───────────────────────────────────────────────────
  static const List<ActivityEntry> recentActivity = [
    ActivityEntry(
      habitName: 'Drink Water',
      emoji: '💧',
      action: 'Completed',
      time: '9:04 AM',
      isCompleted: true,
    ),
    ActivityEntry(
      habitName: 'Workout',
      emoji: '🏃',
      action: 'Completed',
      time: '7:30 AM',
      isCompleted: true,
    ),
    ActivityEntry(
      habitName: 'Meditation',
      emoji: '🧘',
      action: 'Completed',
      time: '6:15 AM',
      isCompleted: true,
    ),
    ActivityEntry(
      habitName: 'Reading',
      emoji: '📚',
      action: 'Pending',
      time: 'Due today',
      isCompleted: false,
    ),
  ];

  // ── Streak achievements ────────────────────────────────────────────────────
  static const List<AchievementEntry> achievements = [
    AchievementEntry(title: '21-Day Streak', subtitle: 'Current streak 🔥', icon: '🏅'),
    AchievementEntry(title: '42-Day Record', subtitle: 'Best streak ever', icon: '🏆'),
    AchievementEntry(title: '92% Consistent', subtitle: 'This month', icon: '⭐'),
    AchievementEntry(title: '3 Done Today', subtitle: '1 remaining', icon: '✅'),
  ];
}

class CategoryStat {
  const CategoryStat({
    required this.name,
    required this.value,
    required this.colorHex,
  });
  final String name;
  final double value;
  final int colorHex;
}

class ActivityEntry {
  const ActivityEntry({
    required this.habitName,
    required this.emoji,
    required this.action,
    required this.time,
    required this.isCompleted,
  });
  final String habitName;
  final String emoji;
  final String action;
  final String time;
  final bool isCompleted;
}

class AchievementEntry {
  const AchievementEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
  final String title;
  final String subtitle;
  final String icon;
}
