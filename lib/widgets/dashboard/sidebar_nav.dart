import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

/// Left-side navigation sidebar.
class SidebarNav extends StatelessWidget {
  const SidebarNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTap,
  });

  final int selectedIndex;
  final void Function(int) onItemTap;

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _NavItem(icon: Icons.track_changes_rounded, label: 'Habits'),
    _NavItem(icon: Icons.local_fire_department_rounded, label: 'Streaks'),
    _NavItem(icon: Icons.bar_chart_rounded, label: 'Analytics'),
    _NavItem(icon: Icons.calendar_month_rounded, label: 'Calendar'),
    _NavItem(icon: Icons.emoji_events_rounded, label: 'Achievements'),
    _NavItem(icon: Icons.settings_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1120),
        border: Border(
          right: BorderSide(
            color: AppColors.glassBorder,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo area ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: AppColors.progressGradient,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.greenGlow,
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('H', style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    )),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('HabitFlow',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      )),
                    Text('Pro Dashboard',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.progressGreen,
                      )),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

          // ── Navigation items ───────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final selected = index == selectedIndex;
                return _NavTile(
                  item: item,
                  selected: selected,
                  onTap: () => onItemTap(index),
                  delay: (index * 50).ms,
                );
              },
            ),
          ),

          // ── User profile footer ────────────────────────────────────────
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.glassSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('T',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      )),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tharuka',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        )),
                      Text('Pro Member',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        )),
                    ],
                  ),
                ),
                Icon(Icons.more_vert_rounded,
                  size: 16, color: AppColors.textMuted),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Nav tile
// ──────────────────────────────────────────────────────────────────────────────

class _NavTile extends StatefulWidget {
  const _NavTile({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.delay,
  });
  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;
  final Duration delay;

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: widget.selected
                ? AppColors.progressGreen.withValues(alpha: 0.15)
                : _hovered
                    ? AppColors.glassSurface
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: widget.selected
                  ? AppColors.progressGreen.withValues(alpha: 0.35)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              ShaderMask(
                shaderCallback: (b) => (widget.selected
                        ? AppColors.progressGradient
                        : const LinearGradient(
                            colors: [Color(0xFF64748B), Color(0xFF64748B)]))
                    .createShader(b),
                child: Icon(
                  widget.item.icon,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                widget.item.label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight:
                      widget.selected ? FontWeight.w600 : FontWeight.w400,
                  color: widget.selected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
              if (widget.selected) ...[
                const Spacer(),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.progressGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.greenGlow,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 350.ms, delay: widget.delay).slideX(
          begin: -0.2,
          end: 0,
          duration: 350.ms,
          delay: widget.delay,
          curve: Curves.easeOutCubic,
        );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
