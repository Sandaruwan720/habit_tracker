import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../controllers/login_controller.dart';
import 'glass_text_field.dart';
import 'animated_gradient_button.dart';
import 'social_login_section.dart';

/// The complete authentication form — email, password, remember me,
/// forgot password, sign in button, social login, and sign-up link.
class LoginForm extends StatefulWidget {
  const LoginForm({super.key, this.onNavigateToDashboard});

  final VoidCallback? onNavigateToDashboard;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit(LoginController controller) async {
    if (!_formKey.currentState!.validate()) return;
    await controller.signIn(
      _emailController.text,
      _passwordController.text,
    );
    if (controller.isSuccess && mounted) {
      widget.onNavigateToDashboard?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (context, controller, _) {
        // Navigate on success
        if (controller.isSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onNavigateToDashboard?.call();
          });
        }

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Email ──────────────────────────────────────────────────────
              GlassTextField(
                controller: _emailController,
                label: 'Email address',
                hint: 'you@example.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                focusNode: _emailFocus,
                autofillHints: const [AutofillHints.email],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
              )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 350.ms)
                  .slideX(begin: -0.08, end: 0),

              const SizedBox(height: 14),

              // ── Password ───────────────────────────────────────────────────
              GlassTextField(
                controller: _passwordController,
                label: 'Password',
                hint: '••••••••',
                icon: Icons.lock_outline_rounded,
                obscureText: controller.obscurePassword,
                focusNode: _passwordFocus,
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.done,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter your password';
                  if (v.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
                onFieldSubmitted: (_) => _submit(controller),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: const Color(0xFF64748B),
                    size: 20,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 450.ms)
                  .slideX(begin: -0.08, end: 0),

              const SizedBox(height: 12),

              // ── Remember me + Forgot password ─────────────────────────────
              Row(
                children: [
                  // Remember me
                  Checkbox.adaptive(
                    value: controller.rememberMe,
                    onChanged: (_) => controller.toggleRememberMe(),
                    activeColor: const Color(0xFF22C55E),
                    side: const BorderSide(
                      color: Color(0xFF475569),
                      width: 1.5,
                    ),
                  ),
                  Text(
                    'Remember me',
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF94A3B8),
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  // Forgot password
                  _HoverTextButton(
                    label: 'Forgot password?',
                    onTap: () {
                      // TODO: Navigate to forgot password
                    },
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 550.ms),

              const SizedBox(height: 8),

              // ── Error message ──────────────────────────────────────────────
              if (controller.errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x18EF4444),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0x40EF4444),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: Color(0xFFEF4444),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          controller.errorMessage!,
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFFEF4444),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .shake(hz: 4, offset: const Offset(4, 0)),
                const SizedBox(height: 12),
              ],

              // ── Sign In button ─────────────────────────────────────────────
              AnimatedGradientButton(
                label: 'Sign In',
                isLoading: controller.isLoading,
                isSuccess: controller.isSuccess,
                onPressed: () => _submit(controller),
              )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 650.ms)
                  .slideY(begin: 0.2, end: 0),

              const SizedBox(height: 24),

              // ── Social login ───────────────────────────────────────────────
              const SocialLoginSection(),

              const SizedBox(height: 24),

              // ── Sign Up link ───────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF64748B),
                      fontSize: 13,
                    ),
                  ),
                  _HoverTextButton(
                    label: 'Create Account',
                    color: const Color(0xFF22C55E),
                    onTap: () {
                      // TODO: Navigate to sign-up screen
                    },
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 950.ms),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hover text button
// ─────────────────────────────────────────────────────────────────────────────

class _HoverTextButton extends StatefulWidget {
  const _HoverTextButton({
    required this.label,
    required this.onTap,
    this.color = const Color(0xFF94A3B8),
  });

  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  State<_HoverTextButton> createState() => _HoverTextButtonState();
}

class _HoverTextButtonState extends State<_HoverTextButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: GoogleFonts.plusJakartaSans(
            color: _isHovered
                ? Colors.white
                : widget.color,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            decoration: _isHovered ? TextDecoration.underline : null,
            decorationColor: widget.color,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
