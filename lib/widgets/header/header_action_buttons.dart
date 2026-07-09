import 'package:flutter/material.dart';
import 'header_action_button.dart';

/// Groups the notification and settings buttons for placement on the right
/// side of the header.  Each button is independently configured via the
/// [notificationCount] and [onNotificationTap] / [onSettingsTap] callbacks.
class HeaderActionButtons extends StatelessWidget {
  const HeaderActionButtons({
    super.key,
    this.notificationCount = 0,
    this.onNotificationTap,
    this.onSettingsTap,
  });

  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Notification Button ─────────────────────────────────────────────
        HeaderActionButton(
          icon: Icons.notifications_none_rounded,
          badgeCount: notificationCount,
          tooltip: 'Notifications',
          onTap: onNotificationTap ?? () {},
        ),

        const SizedBox(width: 10),

        // ── Settings Button ─────────────────────────────────────────────────
        HeaderActionButton(
          icon: Icons.tune_rounded,
          tooltip: 'Settings',
          onTap: onSettingsTap ?? () {},
        ),
      ],
    );
  }
}
