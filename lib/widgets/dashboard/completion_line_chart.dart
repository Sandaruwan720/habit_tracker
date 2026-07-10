import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/dashboard_analytics.dart';
import '../../theme/app_colors.dart';

/// Line chart showing habit completion percentage over 12 months.
class CompletionLineChart extends StatefulWidget {
  const CompletionLineChart({super.key});

  @override
  State<CompletionLineChart> createState() => _CompletionLineChartState();
}

class _CompletionLineChartState extends State<CompletionLineChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(400.ms, () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final data = DashboardAnalytics.monthlyCompletionHistory;
    final spots = List.generate(
      data.length,
      (i) => FlSpot(i.toDouble(), data[i]),
    );

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
                  Text('Completion Overview',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary, letterSpacing: -0.2)),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(text: '92% ',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22, fontWeight: FontWeight.w800,
                          color: AppColors.progressGreen, letterSpacing: -0.5)),
                      WidgetSpan(child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.arrow_upward_rounded,
                            size: 11, color: Color(0xFF22C55E)),
                          Text(' 3.1%',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11, fontWeight: FontWeight.w700,
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
                    fontSize: 11, fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary)),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Chart ─────────────────────────────────────────────────────────
          SizedBox(
            height: 180,
            child: AnimatedBuilder(
              animation: _anim,
              builder: (_, _) => LineChart(
                LineChartData(
                  minY: 50,
                  maxY: 100,
                  clipData: const FlClipData.all(),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 10,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: AppColors.glassBorder,
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        interval: 10,
                        getTitlesWidget: (v, _) => Text('${v.toInt()}%',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10, color: AppColors.textMuted)),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 24,
                        getTitlesWidget: (v, _) {
                          final idx = v.toInt();
                          if (idx < 0 || idx >= DashboardAnalytics.monthLabels.length) {
                            return const SizedBox.shrink();
                          }
                          return Text(DashboardAnalytics.monthLabels[idx],
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10, color: AppColors.textMuted));
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots.map((s) => FlSpot(s.x, s.y * _anim.value + 50 * (1 - _anim.value))).toList(),
                      isCurved: true,
                      curveSmoothness: 0.35,
                      color: const Color(0xFF22C55E),
                      barWidth: 2.5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) {
                          if (index != spots.length - 1) {
                            return FlDotCirclePainter(
                              radius: 0,
                              color: Colors.transparent,
                              strokeWidth: 0,
                              strokeColor: Colors.transparent,
                            );
                          }
                          return FlDotCirclePainter(
                            radius: 5,
                            color: const Color(0xFF22C55E),
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF22C55E).withValues(alpha: 0.25),
                            const Color(0xFF22C55E).withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => const Color(0xFF1E293B),
                      tooltipRoundedRadius: 8,
                      getTooltipItems: (spots) => spots.map((s) =>
                        LineTooltipItem(
                          '${s.y.toStringAsFixed(1)}%',
                          GoogleFonts.plusJakartaSans(
                            fontSize: 12, fontWeight: FontWeight.w700,
                            color: const Color(0xFF22C55E)),
                        )).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms);
  }
}
