import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

/// Premium animated horizontal progress bar card for monthly performance.
class MonthlyProgressCard extends StatefulWidget {
  const MonthlyProgressCard({
    super.key,
    required this.monthlyPercent,
  });

  /// Monthly completion percentage in [0, 100].
  final double monthlyPercent;

  @override
  State<MonthlyProgressCard> createState() => _MonthlyProgressCardState();
}

class _MonthlyProgressCardState extends State<MonthlyProgressCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _barAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _barAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    Future.delayed(const Duration(milliseconds: 500), () {
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.greenGlow,
            blurRadius: 24,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: AppColors.progressGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('📅', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Monthly Progress',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              // Animated percentage counter
              AnimatedBuilder(
                animation: _barAnimation,
                builder: (context, _) {
                  final display =
                      (_barAnimation.value * widget.monthlyPercent).round();
                  return ShaderMask(
                    shaderCallback: (bounds) =>
                        AppColors.progressGradient.createShader(bounds),
                    child: Text(
                      '$display%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress bar track
          Container(
            height: 10,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: AnimatedBuilder(
              animation: _barAnimation,
              builder: (context, _) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor:
                      _barAnimation.value * widget.monthlyPercent / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.progressGradient,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.progressGreen
                              .withValues(alpha: 0.6),
                          blurRadius: 8,
                          spreadRadius: -1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // Sub-label
          Text(
            'Based on all habits this month',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
