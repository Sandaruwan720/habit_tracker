import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../controllers/register_controller.dart';
import '../widgets/curved_background_painter.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/animated_gradient_button.dart';

/// Sign-up screen — mirrors the login screen's dark glassmorphism style.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final RegisterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegisterController(
      AuthRepositoryImpl(AuthRemoteDatasource()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B0F17),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 800;
            if (isDesktop) return _buildDesktop(context);
            return _buildMobile(context);
          },
        ),
      ),
    );
  }

  // ── Desktop split-panel layout ──────────────────────────────────────────────

  Widget _buildDesktop(BuildContext context) {
    return Row(
      children: [
        // Auth panel (45%)
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: _buildAuthPanel(context),
        ),
        // Hero panel (55%) with S-curve clip
        Expanded(
          child: ClipPath(
            clipper: HeroPanelClipper(),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.track_changes_rounded,
                        color: Color(0xFF818CF8), size: 96),
                    const SizedBox(height: 24),
                    Text(
                      'Build better habits,\none day at a time.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Track, analyze, and achieve your goals.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Mobile full-screen layout ───────────────────────────────────────────────

  Widget _buildMobile(BuildContext context) {
    return SafeArea(child: _buildAuthPanel(context));
  }

  // ── Shared auth panel ───────────────────────────────────────────────────────

  Widget _buildAuthPanel(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Row(
              children: [
                const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF94A3B8), size: 16),
                const SizedBox(width: 6),
                Text(
                  'Back to Sign In',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 50.ms),

          const SizedBox(height: 40),

          // Header
          Text(
            'Create Account',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),

          const SizedBox(height: 8),

          Text(
            'Start your habit journey today.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              color: const Color(0xFF94A3B8),
            ),
          ).animate().fadeIn(delay: 150.ms),

          const SizedBox(height: 40),

          _RegisterForm(
            onNavigateToLogin: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

// ── Register Form ─────────────────────────────────────────────────────────────

class _RegisterForm extends StatefulWidget {
  const _RegisterForm({this.onNavigateToLogin});
  final VoidCallback? onNavigateToLogin;

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit(RegisterController controller) async {
    if (!_formKey.currentState!.validate()) return;
    await controller.signUp(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (controller.isSuccess && mounted) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text('Account Created! 🎉',
            style: GoogleFonts.plusJakartaSans(
                color: Colors.white, fontWeight: FontWeight.w700)),
        content: Text(
          'Please check your email to confirm your account, then sign in.',
          style:
              GoogleFonts.plusJakartaSans(color: const Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // close dialog
              widget.onNavigateToLogin?.call();
            },
            child: Text('Go to Sign In',
                style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF6366F1),
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterController>(
      builder: (context, controller, _) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              // Error banner
              if (controller.errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0x1AEF4444),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0x33EF4444)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: Color(0xFFEF4444), size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(controller.errorMessage!,
                            style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFFEF4444),
                                fontSize: 13)),
                      ),
                    ],
                  ),
                ),

              // Full name
              GlassTextField(
                controller: _nameController,
                label: 'Full Name',
                hint: 'Your name',
                icon: Icons.person_outline_rounded,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),

              // Email
              GlassTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'you@example.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email is required';
                  if (!v.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password
              GlassTextField(
                controller: _passwordController,
                label: 'Password',
                hint: '8+ characters',
                icon: Icons.lock_outline_rounded,
                obscureText: controller.obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF64748B),
                    size: 20,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password is required';
                  if (v.length < 8) return 'Must be at least 8 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirm password
              GlassTextField(
                controller: _confirmController,
                label: 'Confirm Password',
                hint: 'Re-enter password',
                icon: Icons.lock_outline_rounded,
                obscureText: true,
                validator: (v) {
                  if (v != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),

              // Submit button
              AnimatedGradientButton(
                label: 'Create Account',
                isLoading: controller.isLoading,
                onPressed: controller.isLoading ? null : () => _submit(controller),
              ),

              const SizedBox(height: 24),

              // Sign-in link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF64748B), fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: widget.onNavigateToLogin,
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF818CF8),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
