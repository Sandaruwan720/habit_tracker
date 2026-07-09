import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/header/top_header_section.dart';
import '../widgets/daily_progress/daily_progress_overview.dart';

/// Dashboard page — hosts the TopHeaderSection at the top and the
/// DailyProgressOverview hero section in the scrollable body below.
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
            // avatarUrl: 'https://example.com/avatar.jpg',
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

          // ── Daily Progress Overview (hero body) ──────────────────────────
          const Expanded(
            child: DailyProgressOverview(),
          ),
        ],
      ),
    );
  }
}
