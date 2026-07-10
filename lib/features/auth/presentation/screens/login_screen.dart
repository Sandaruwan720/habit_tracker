import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../controllers/login_controller.dart';
import '../widgets/curved_background_painter.dart';
import '../widgets/hero_illustration.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';
import '../../../../pages/dashboard_page.dart';

/// Root login screen widget.
///
/// Responsive layout:
///   ≥ 800px → desktop split-panel (auth 45% | hero 55%)
///   < 800px → mobile full-screen auth panel
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController(
      AuthRepositoryImpl(AuthRemoteDatasource()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
          opacity: animation,
          child: const DashboardPage(),
        ),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
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
            return isDesktop
                ? _DesktopLayout(onNavigateToDashboard: _navigateToDashboard)
                : _MobileLayout(onNavigateToDashboard: _navigateToDashboard);
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Desktop split-panel layout
// ─────────────────────────────────────────────────────────────────────────────

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({required this.onNavigateToDashboard});

  final VoidCallback onNavigateToDashboard;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0B0F17), Color(0xFF111827)],
            ),
          ),
        ),

        // Main row
        Row(
          children: [
            // ── Auth panel (45%) ────────────────────────────────────────────
            Expanded(
              flex: 45,
              child: _AuthPanel(onNavigateToDashboard: onNavigateToDashboard),
            ),

            // ── Hero panel (55%) with organic wave clip ─────────────────────
            Expanded(
              flex: 55,
              child: ClipPath(
                clipper: const HeroPanelClipper(),
                child: const HeroIllustrationSection(),
              ),
            ),
          ],
        ),

        // Glowing edge overlay — sits above the panels on the seam
        Positioned.fill(
          child: IgnorePointer(
            child: Row(
              children: [
                const Spacer(flex: 45),
                SizedBox(
                  width: 120,
                  child: CustomPaint(
                    painter: const CurvedEdgePainter(),
                  ),
                ),
                const Spacer(flex: 55),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mobile full-screen layout
// ─────────────────────────────────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.onNavigateToDashboard});

  final VoidCallback onNavigateToDashboard;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0B0F17), Color(0xFF111827)],
            ),
          ),
        ),

        // Glow blobs
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 350,
            height: 350,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0x206366F1), Colors.transparent],
                radius: 0.7,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          left: -80,
          child: Container(
            width: 280,
            height: 280,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0x1822C55E), Colors.transparent],
                radius: 0.7,
              ),
            ),
          ),
        ),

        // Content
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LoginHeader(),
                const SizedBox(height: 36),
                LoginForm(onNavigateToDashboard: onNavigateToDashboard),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Auth panel (reused inside desktop layout)
// ─────────────────────────────────────────────────────────────────────────────

class _AuthPanel extends StatelessWidget {
  const _AuthPanel({required this.onNavigateToDashboard});

  final VoidCallback onNavigateToDashboard;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0B0F17),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LoginHeader(),
                const SizedBox(height: 36),
                LoginForm(onNavigateToDashboard: onNavigateToDashboard),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
