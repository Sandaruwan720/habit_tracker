import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// Displays the time-aware greeting headline and motivational subtitle.
///
/// The user's name is rendered with the primary accent color.
/// Layout: stacked column, left-aligned.
class GreetingSection extends StatelessWidget {
  const GreetingSection({
    super.key,
    this.userName = 'Tharuka',
  });

  final String userName;

  /// Returns "Good Morning", "Good Afternoon", or "Good Evening"
  /// based on the current local hour.
  String _buildGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _buildGreeting();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Greeting Headline ───────────────────────────────────────────────
        RichText(
          text: TextSpan(
            style: AppTextStyles.greetingTitle,
            children: [
              TextSpan(text: '$greeting, '),
              TextSpan(
                text: userName,
                style: AppTextStyles.greetingTitle.copyWith(
                  color: AppColors.primaryLight,
                  // Subtle shimmer-like underline for premium feel
                  decoration: TextDecoration.none,
                ),
              ),
              const TextSpan(text: ' 👋'),
            ],
          ),
        ),
        const SizedBox(height: 4),

        // ── Motivational subtitle ───────────────────────────────────────────
        Text(
          "Let's complete your goals today",
          style: AppTextStyles.greetingSubtitle,
        ),
      ],
    );
  }
}
