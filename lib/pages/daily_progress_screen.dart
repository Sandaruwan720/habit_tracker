import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/providers/habits_provider.dart';
import '../../features/habits/domain/entities/habit_entity.dart';
import '../../features/habits/presentation/screens/add_habit_screen.dart';
import '../../features/habits/presentation/screens/edit_habit_screen.dart';

// Icon map for rendering
const _kIconMap = <String, IconData>{
  'check_circle': Icons.check_circle_outline_rounded,
  'fitness': Icons.fitness_center_rounded,
  'book': Icons.menu_book_rounded,
  'water': Icons.water_drop_outlined,
  'bed': Icons.bedtime_outlined,
  'run': Icons.directions_run_rounded,
  'meditate': Icons.self_improvement_rounded,
  'food': Icons.restaurant_outlined,
  'code': Icons.code_rounded,
  'music': Icons.music_note_rounded,
};

/// Daily habits tracking screen — shows today's habits with completion toggles.
class DailyProgressScreen extends StatefulWidget {
  const DailyProgressScreen({super.key});

  @override
  State<DailyProgressScreen> createState() => _DailyProgressScreenState();
}

class _DailyProgressScreenState extends State<DailyProgressScreen> {
  @override
  void initState() {
    super.initState();
    // Load habits on first open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitsProvider>().loadHabits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final added = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider.value(
                      value: context.read<HabitsProvider>(),
                      child: const AddHabitScreen(),
                    )),
          );
          if (added == true) {
            // Reload
            if (mounted) context.read<HabitsProvider>().loadHabits();
          }
        },
        backgroundColor: const Color(0xFF6366F1),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Add Habit',
          style: GoogleFonts.plusJakartaSans(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Consumer<HabitsProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── App Bar ───────────────────────────────────────────────────
              SliverAppBar(
                backgroundColor: const Color(0xFF0A0E1A),
                expandedHeight: 160,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  title: Text(
                    'Today',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                  background: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 60),
                    child: _ProgressHeader(provider: provider),
                  ),
                ),
              ),

              // ── Date bar ─────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: Text(
                    _formattedDate(),
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF64748B),
                      fontSize: 13,
                    ),
                  ),
                ),
              ),

              // ── Loading ───────────────────────────────────────────────────
              if (provider.isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF6366F1)),
                  ),
                )

              // ── Error ─────────────────────────────────────────────────────
              else if (provider.errorMessage != null)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.wifi_off_rounded,
                            color: Color(0xFF64748B), size: 48),
                        const SizedBox(height: 12),
                        Text(
                          provider.errorMessage!,
                          style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF64748B)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => provider.loadHabits(),
                          child: Text('Retry',
                              style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF6366F1))),
                        ),
                      ],
                    ),
                  ),
                )

              // ── Empty state ───────────────────────────────────────────────
              else if (provider.habits.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🌱', style: TextStyle(fontSize: 64)),
                        const SizedBox(height: 16),
                        Text(
                          'No habits yet.',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap "+ Add Habit" to start building\nyour daily routine.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                )

              // ── Habits list ───────────────────────────────────────────────
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final habit = provider.habits[index];
                        return _HabitTile(
                          habit: habit,
                          isCompleted: provider.isCompletedToday(habit.id),
                          onToggle: () =>
                              provider.toggleTodayCompletion(habit.id),
                          onEdit: () async {
                            final changed =
                                await Navigator.of(context).push<bool>(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ChangeNotifierProvider.value(
                                  value: provider,
                                  child: EditHabitScreen(habit: habit),
                                ),
                              ),
                            );
                            if (changed == true && mounted) {
                              provider.loadHabits();
                            }
                          },
                        ).animate().fadeIn(
                              delay: (index * 60).ms,
                              duration: 350.ms,
                            );
                      },
                      childCount: provider.habits.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String _formattedDate() {
    final now = DateTime.now();
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }
}

// ── Progress header ───────────────────────────────────────────────────────────

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.provider});
  final HabitsProvider provider;

  @override
  Widget build(BuildContext context) {
    final pct = provider.todayCompletionPercent;
    final done = provider.completedTodayCount;
    final total = provider.habits.length;

    return Row(
      children: [
        // Ring
        SizedBox(
          width: 64,
          height: 64,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: total == 0 ? 0 : pct / 100,
                strokeWidth: 6,
                backgroundColor: const Color(0xFF1E293B),
                valueColor: AlwaysStoppedAnimation<Color>(
                  pct == 100
                      ? const Color(0xFF22C55E)
                      : const Color(0xFF6366F1),
                ),
              ),
              Center(
                child: Text(
                  '${pct.toInt()}%',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              pct == 100
                  ? '🎉 All done!'
                  : '$done of $total completed',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              pct == 100
                  ? 'Amazing! Keep the streak going.'
                  : 'Keep going — you\'re doing great!',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF94A3B8),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Habit tile ────────────────────────────────────────────────────────────────

class _HabitTile extends StatelessWidget {
  const _HabitTile({
    required this.habit,
    required this.isCompleted,
    required this.onToggle,
    required this.onEdit,
  });

  final HabitEntity habit;
  final bool isCompleted;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final color = Color(habit.color);
    final icon = _kIconMap[habit.icon] ?? Icons.check_circle_outline_rounded;

    return GestureDetector(
      onLongPress: onEdit,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCompleted
              ? color.withOpacity(0.12)
              : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted
                ? color.withOpacity(0.4)
                : const Color(0xFF334155),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            // Name + description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: GoogleFonts.plusJakartaSans(
                      color: isCompleted
                          ? const Color(0xFF94A3B8)
                          : Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  if (habit.description != null &&
                      habit.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        habit.description!,
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF64748B),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 4),
                  _FrequencyChip(
                      frequency: habit.frequency, color: color),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Checkbox
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted ? color : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted ? color : const Color(0xFF475569),
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 18)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FrequencyChip extends StatelessWidget {
  const _FrequencyChip({required this.frequency, required this.color});
  final String frequency;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        frequency,
        style: GoogleFonts.plusJakartaSans(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
