import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';
import 'profile_section.dart';
import 'greeting_section.dart';
import 'date_chip.dart';
import 'header_action_buttons.dart';

/// Top-level header widget for the Habit Tracker dashboard.
///
/// Composes all header sub-widgets in a balanced left-right layout:
///
/// ```
/// ┌────────────────────────────────────────────────────┐
/// │  [Avatar]  Good Morning, Tharuka 👋    [🔔] [⚙]  │
/// │            Let's complete your goals today          │
/// │            [ 📅 Monday, July 9 ]                   │
/// └────────────────────────────────────────────────────┘
/// ```
///
/// Animated entrance: staggered fade-in + slide-up via flutter_animate.
class TopHeaderSection extends StatelessWidget {
  const TopHeaderSection({
    super.key,
    this.userName = 'Tharuka',
    this.avatarUrl,
    this.notificationCount = 3,
    this.onAvatarTap,
    this.onNotificationTap,
    this.onSettingsTap,
    this.onDateChipTap,
  });

  final String userName;
  final String? avatarUrl;
  final int notificationCount;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onDateChipTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Row: Avatar + Greeting + Buttons ─────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  ProfileSection(
                    avatarUrl: avatarUrl,
                    onTap: onAvatarTap,
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 50.ms)
                      .scale(
                        begin: const Offset(0.7, 0.7),
                        end: const Offset(1, 1),
                        duration: 450.ms,
                        delay: 50.ms,
                        curve: Curves.easeOutBack,
                      ),

                  const SizedBox(width: 14),

                  // Greeting – expands to fill remaining horizontal space
                  Expanded(
                    child: GreetingSection(userName: userName)
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 120.ms)
                        .slideY(
                          begin: 0.3,
                          end: 0,
                          duration: 420.ms,
                          delay: 120.ms,
                          curve: Curves.easeOutCubic,
                        ),
                  ),

                  const SizedBox(width: 12),

                  // Action buttons
                  HeaderActionButtons(
                    notificationCount: notificationCount,
                    onNotificationTap: onNotificationTap,
                    onSettingsTap: onSettingsTap,
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 200.ms)
                      .slideY(
                        begin: -0.3,
                        end: 0,
                        duration: 400.ms,
                        delay: 200.ms,
                        curve: Curves.easeOutCubic,
                      ),
                ],
              ),

              const SizedBox(height: 14),

              // ── Date Chip row ────────────────────────────────────────────
              Padding(
                // Align date chip under the greeting text (after avatar width)
                padding: const EdgeInsets.only(left: 74),
                child: DateChip(onTap: onDateChipTap)
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 280.ms)
                    .slideX(
                      begin: -0.15,
                      end: 0,
                      duration: 380.ms,
                      delay: 280.ms,
                      curve: Curves.easeOutCubic,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
