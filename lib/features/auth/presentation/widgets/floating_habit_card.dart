import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'progress_ring_painter.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Base glass card container
// ─────────────────────────────────────────────────────────────────────────────

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: const Color(0x14FFFFFF),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0x20FFFFFF),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Today's Progress card  (circular ring)
// ─────────────────────────────────────────────────────────────────────────────

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Today's Progress",
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF94A3B8),
              fontSize: 11,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: CustomPaint(
                  painter: const ProgressRingPainter(
                    progress: 0.78,
                    trackColor: Color(0x2022C55E),
                    progressGradient: LinearGradient(
                      colors: [Color(0xFF22C55E), Color(0xFF10B981)],
                    ),
                    strokeWidth: 6,
                  ),
                  child: Center(
                    child: Text(
                      '78%',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '7 / 9',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'habits done',
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF64748B),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: 0, end: -8, duration: 3200.ms, curve: Curves.easeInOut);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Streak card
// ─────────────────────────────────────────────────────────────────────────────

class StreakCard extends StatelessWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Text(
                'Streak',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF94A3B8),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '21',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          Text(
            'Days',
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFF97316),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: -6, end: 6, duration: 2800.ms, curve: Curves.easeInOut);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Weekly progress bar chart card
// ─────────────────────────────────────────────────────────────────────────────

class WeeklyChartCard extends StatelessWidget {
  const WeeklyChartCard({super.key});

  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const _values = [0.9, 0.7, 1.0, 0.8, 0.6, 0.95, 0.4];

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Weekly Progress',
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF94A3B8),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (i) {
              final isToday = i == 5;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 400 + i * 60),
                        height: 48 * _values[i],
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: isToday
                                ? [const Color(0xFF22C55E), const Color(0xFF4ADE80)]
                                : [const Color(0x3022C55E), const Color(0x5022C55E)],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _days[i],
                        style: GoogleFonts.plusJakartaSans(
                          color: isToday
                              ? const Color(0xFF22C55E)
                              : const Color(0xFF475569),
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: 4, end: -4, duration: 3600.ms, curve: Curves.easeInOut);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Today's habits checklist card
// ─────────────────────────────────────────────────────────────────────────────

class HabitsChecklistCard extends StatelessWidget {
  const HabitsChecklistCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Today's Habits",
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF94A3B8),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          _habitRow('Workout', true, const Color(0xFF22C55E)),
          const SizedBox(height: 6),
          _habitRow('Reading', true, const Color(0xFF6366F1)),
          const SizedBox(height: 6),
          _habitRow('Meditation', false, const Color(0xFF64748B)),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: 0, end: -10, duration: 4000.ms, curve: Curves.easeInOut);
  }

  Widget _habitRow(String label, bool done, Color color) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? color.withValues(alpha: 0.2) : Colors.transparent,
            border: Border.all(
              color: done ? color : const Color(0xFF334155),
              width: 1.5,
            ),
          ),
          child: done
              ? Icon(Icons.check, size: 11, color: color)
              : null,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: done ? Colors.white : const Color(0xFF64748B),
            fontSize: 12,
            fontWeight: done ? FontWeight.w600 : FontWeight.w400,
            decoration: done ? TextDecoration.none : null,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mini calendar card
// ─────────────────────────────────────────────────────────────────────────────

class CalendarCard extends StatelessWidget {
  const CalendarCard({super.key});

  static const _completedDays = {2, 3, 5, 6, 7, 9, 10, 12, 13, 14, 16, 17, 19, 20, 21};

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: 190,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'July 2026',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '21 days ✓',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF22C55E),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 3,
              crossAxisSpacing: 3,
            ),
            itemCount: 21,
            itemBuilder: (_, i) {
              final day = i + 1;
              final done = _completedDays.contains(day);
              final isToday = day == 21;
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isToday
                      ? const Color(0xFF22C55E)
                      : done
                          ? const Color(0x3022C55E)
                          : const Color(0x0AFFFFFF),
                  border: isToday
                      ? null
                      : Border.all(
                          color: done
                              ? const Color(0x6022C55E)
                              : const Color(0x10FFFFFF),
                          width: 0.5,
                        ),
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: isToday
                          ? Colors.white
                          : done
                              ? const Color(0xFF4ADE80)
                              : const Color(0xFF334155),
                      fontSize: 7,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(begin: -4, end: 8, duration: 3400.ms, curve: Curves.easeInOut);
  }
}
