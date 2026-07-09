import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

/// Hero circular progress ring.
///
/// Renders a gradient-stroked arc with:
///  - A soft radial glow behind the active arc
///  - Rounded stroke caps
///  - A frosted-glass inner circle
///  - Animated count-up percentage in the center
///  - Smooth sweep animation on mount via [AnimationController]
class ProgressRingWidget extends StatefulWidget {
  const ProgressRingWidget({
    super.key,
    required this.completionFraction,
    required this.completedCount,
    required this.totalCount,
  });

  /// Value in [0, 1] representing daily completion.
  final double completionFraction;
  final int completedCount;
  final int totalCount;

  @override
  State<ProgressRingWidget> createState() => _ProgressRingWidgetState();
}

class _ProgressRingWidgetState extends State<ProgressRingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _sweepAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _sweepAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    // Slight delay so the card entrance animation plays first.
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 220,
        height: 220,
        child: AnimatedBuilder(
          animation: _sweepAnimation,
          builder: (context, _) {
            final animatedFraction =
                _sweepAnimation.value * widget.completionFraction;
            final displayPercent =
                (animatedFraction * 100).round();

            return CustomPaint(
              painter: _RingPainter(fraction: animatedFraction),
              child: Center(
                child: _RingCenter(
                  percent: displayPercent,
                  completedCount: widget.completedCount,
                  totalCount: widget.totalCount,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Custom Painter
// ──────────────────────────────────────────────────────────────────────────────

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.fraction});

  final double fraction;

  static const double _strokeWidth = 18.0;
  static const double _startAngle = -math.pi / 2; // top

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - _strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // 1. Background track ────────────────────────────────────────────────────
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF1E293B);

    canvas.drawCircle(center, radius, trackPaint);

    if (fraction <= 0) return;

    // 2. Glow layer (painted first, behind the arc) ──────────────────────────
    final sweepAngle = 2 * math.pi * fraction;

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth + 12
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [Color(0xFF22C55E), Color(0xFF10B981)],
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawArc(rect, _startAngle, sweepAngle, false, glowPaint);

    // 3. Main gradient arc ────────────────────────────────────────────────────
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: _startAngle,
        endAngle: _startAngle + sweepAngle,
        colors: const [Color(0xFF22C55E), Color(0xFF10B981), Color(0xFF22C55E)],
        stops: const [0.0, 0.7, 1.0],
        tileMode: TileMode.clamp,
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(rect, _startAngle, sweepAngle, false, arcPaint);

    // 4. Trailing dot (leading cap highlight) ────────────────────────────────
    final dotAngle = _startAngle + sweepAngle;
    final dotX = center.dx + radius * math.cos(dotAngle);
    final dotY = center.dy + radius * math.sin(dotAngle);

    final dotGlow = Paint()
      ..color = const Color(0xFF22C55E).withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(dotX, dotY), 8, dotGlow);

    final dotPaint = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawCircle(Offset(dotX, dotY), 4, dotPaint);

    final dotInner = Paint()..color = const Color(0xFF10B981);
    canvas.drawCircle(Offset(dotX, dotY), 2.5, dotInner);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.fraction != fraction;
}

// ──────────────────────────────────────────────────────────────────────────────
// Ring Center Content
// ──────────────────────────────────────────────────────────────────────────────

class _RingCenter extends StatelessWidget {
  const _RingCenter({
    required this.percent,
    required this.completedCount,
    required this.totalCount,
  });

  final int percent;
  final int completedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      height: 148,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFF1A2035), Color(0xFF121826)],
          radius: 0.9,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: -4,
          ),
          BoxShadow(
            color: const Color(0xFF22C55E).withValues(alpha: 0.08),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: const Color(0xFF1E293B),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Percentage
          ShaderMask(
            shaderCallback: (bounds) => AppColors.progressGradient
                .createShader(bounds),
            child: Text(
              '$percent%',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 38,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -1.5,
                height: 1,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Daily Completion',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              letterSpacing: 0.2,
            ),
          ),

          const SizedBox(height: 8),

          // Habit count pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF22C55E).withValues(alpha: 0.3),
                width: 0.8,
              ),
            ),
            child: Text(
              '$completedCount of $totalCount Habits',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.progressGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
