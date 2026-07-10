import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/dashboard_analytics.dart';
import '../../theme/app_colors.dart';

/// Donut chart showing habit completion breakdown by category.
class CategoryDonutChart extends StatefulWidget {
  const CategoryDonutChart({super.key});

  @override
  State<CategoryDonutChart> createState() => _CategoryDonutChartState();
}

class _CategoryDonutChartState extends State<CategoryDonutChart> {
  int _touchedIndex = -1;

  static const List<Color> _colors = [
    Color(0xFF22C55E),
    Color(0xFF6366F1),
    Color(0xFFF59E0B),
    Color(0xFF06B6D4),
  ];

  @override
  Widget build(BuildContext context) {
    final categories = DashboardAnalytics.categoryStats;

    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('By Category',
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

          const SizedBox(height: 16),

          // ── Donut chart ───────────────────────────────────────────────────
          SizedBox(
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (evt, resp) {
                        setState(() {
                          _touchedIndex = (resp?.touchedSection?.touchedSectionIndex ?? -1);
                        });
                      },
                    ),
                    centerSpaceRadius: 52,
                    sectionsSpace: 3,
                    sections: List.generate(categories.length, (i) {
                      final cat = categories[i];
                      final isTouched = i == _touchedIndex;
                      return PieChartSectionData(
                        value: cat.value,
                        color: _colors[i],
                        radius: isTouched ? 52 : 44,
                        title: '',
                        badgeWidget: isTouched
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: _colors[i],
                                  borderRadius: BorderRadius.circular(6)),
                                child: Text('${cat.value.toInt()}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700)))
                            : null,
                        badgePositionPercentageOffset: 1.15,
                      );
                    }),
                  ),
                ),
                // Center label
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      shaderCallback: (b) => AppColors.progressGradient.createShader(b),
                      child: Text('\$24.7K',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16, fontWeight: FontWeight.w800,
                          color: Colors.white, letterSpacing: -0.5)),
                    ),
                    Text('Total',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10, color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Legend ────────────────────────────────────────────────────────
          ...List.generate(categories.length, (i) {
            final cat = categories[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 10, height: 10,
                    decoration: BoxDecoration(
                      color: _colors[i], shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(cat.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11, color: AppColors.textSecondary))),
                  Text('${cat.value.toInt()}%',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11, fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
                ],
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 300.ms);
  }
}
