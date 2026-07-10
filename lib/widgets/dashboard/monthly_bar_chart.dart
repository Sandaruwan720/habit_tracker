import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/dashboard_analytics.dart';
import '../../theme/app_colors.dart';

/// Bar chart showing monthly completion count over 12 months.
class MonthlyBarChart extends StatefulWidget {
  const MonthlyBarChart({super.key});

  @override
  State<MonthlyBarChart> createState() => _MonthlyBarChartState();
}

class _MonthlyBarChartState extends State<MonthlyBarChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(600.ms, () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final data = DashboardAnalytics.monthlyCompletionHistory;

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Monthly Overview',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary, letterSpacing: -0.2)),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(text: '82% ',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18, fontWeight: FontWeight.w800,
                          color: AppColors.progressGreen, letterSpacing: -0.3)),
                      WidgetSpan(child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.arrow_upward_rounded,
                            size: 10, color: Color(0xFF22C55E)),
                          Text(' 15.3%',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10, fontWeight: FontWeight.w700,
                              color: const Color(0xFF22C55E))),
                        ]))),
                    ]),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.glassSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.glassBorder)),
                child: Text('This Year',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11, color: AppColors.textSecondary)),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Bar chart ─────────────────────────────────────────────────────
          SizedBox(
            height: 160,
            child: AnimatedBuilder(
              animation: _anim,
              builder: (_, _) => BarChart(
                BarChartData(
                  maxY: 100,
                  minY: 0,
                  barTouchData: BarTouchData(
                    touchCallback: (evt, resp) {
                      setState(() {
                        _touchedIndex = resp?.spot == null ? -1
                            : resp!.spot!.touchedBarGroupIndex;
                      });
                    },
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => const Color(0xFF1E293B),
                      tooltipRoundedRadius: 8,
                      getTooltipItem: (group, _, rod, _) => BarTooltipItem(
                        '${rod.toY.toInt()}%',
                        GoogleFonts.plusJakartaSans(
                          fontSize: 11, fontWeight: FontWeight.w700,
                          color: const Color(0xFF22C55E)),
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 25,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: AppColors.glassBorder,
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        getTitlesWidget: (v, _) {
                          final idx = v.toInt();
                          if (idx < 0 || idx >= DashboardAnalytics.monthLabels.length) {
                            return const SizedBox.shrink();
                          }
                          return Text(DashboardAnalytics.monthLabels[idx],
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9, color: AppColors.textMuted));
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  barGroups: List.generate(data.length, (i) {
                    final isTouched = i == _touchedIndex;
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: data[i] * _anim.value,
                          width: 14,
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: isTouched
                                ? [const Color(0xFF10B981), const Color(0xFF22C55E)]
                                : [
                                    const Color(0xFF22C55E).withValues(alpha: 0.5),
                                    const Color(0xFF22C55E),
                                  ],
                          ),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 100,
                            color: AppColors.glassBorder.withValues(alpha: 0.3),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 350.ms);
  }
}
