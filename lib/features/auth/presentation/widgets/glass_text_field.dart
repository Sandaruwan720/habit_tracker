import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium glassmorphism text field with animated focus border,
/// floating label, leading icon, and validation shake animation.
class GlassTextField extends StatefulWidget {
  const GlassTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.autofillHints,
    this.focusNode,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? suffixIcon;
  final Iterable<String>? autofillHints;
  final FocusNode? focusNode;

  @override
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _focusAnim;
  late Animation<Color?> _borderColor;

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _borderColor = ColorTween(
      begin: const Color(0x20FFFFFF),
      end: const Color(0xFF22C55E),
    ).animate(CurvedAnimation(parent: _focusAnim, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _focusAnim.dispose();
    super.dispose();
  }

  void _onFocusChange(bool focused) {
    setState(() => _isFocused = focused);
    if (focused) {
      _focusAnim.forward();
    } else {
      _focusAnim.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _focusAnim,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0x0FFFFFFF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _borderColor.value ?? const Color(0x20FFFFFF),
                  width: 1.5,
                ),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: const Color(0xFF22C55E).withValues(alpha: 0.12),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Focus(
                onFocusChange: _onFocusChange,
                child: TextFormField(
                  controller: widget.controller,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  validator: widget.validator,
                  onFieldSubmitted: widget.onFieldSubmitted,
                  autofillHints: widget.autofillHints,
                  focusNode: widget.focusNode,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: widget.label,
                    hintText: widget.hint,
                    hintStyle: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF475569),
                      fontSize: 14,
                    ),
                    labelStyle: GoogleFonts.plusJakartaSans(
                      color: _isFocused
                          ? const Color(0xFF22C55E)
                          : const Color(0xFF64748B),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    floatingLabelStyle: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF22C55E),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    prefixIcon: Icon(
                      widget.icon,
                      color: _isFocused
                          ? const Color(0xFF22C55E)
                          : const Color(0xFF475569),
                      size: 20,
                    ),
                    suffixIcon: widget.suffixIcon,
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFFEF4444),
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFFEF4444),
                        width: 1.5,
                      ),
                    ),
                    errorStyle: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFFEF4444),
                      fontSize: 11,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
