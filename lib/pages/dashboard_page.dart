import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/header/top_header_section.dart';

/// Dashboard page — hosts the TopHeaderSection at the top and leaves the
/// rest of the body for future habit-tracking content.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Premium Header ───────────────────────────────────────────────
          TopHeaderSection(
            userName: 'Tharuka',
            // avatarUrl: 'https://example.com/avatar.jpg', // plug in real URL
            notificationCount: 3,
            onAvatarTap: () {
              // TODO: Navigate to Profile page
            },
            onNotificationTap: () {
              // TODO: Open notifications panel
            },
            onSettingsTap: () {
              // TODO: Navigate to Settings page
            },
            onDateChipTap: () {
              // TODO: Open calendar picker
            },
          ),

          // ── Body Placeholder ─────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _SectionPlaceholder(
                      label: 'Today\'s Habits',
                      height: 180,
                    ),
                    const SizedBox(height: 16),
                    _SectionPlaceholder(
                      label: 'Weekly Progress',
                      height: 140,
                    ),
                    const SizedBox(height: 16),
                    _SectionPlaceholder(
                      label: 'Streaks',
                      height: 120,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Placeholder cards – will be replaced by real habit widgets later
// ────────────────────────────────────────────────────────────────────────────

class _SectionPlaceholder extends StatelessWidget {
  const _SectionPlaceholder({required this.label, required this.height});
  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.glassSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder, width: 1),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
