import 'package:flutter/foundation.dart';
import '../../domain/repositories/auth_repository.dart';

enum RegisterStatus { idle, loading, success, error }

/// ChangeNotifier that drives the registration screen UI.
class RegisterController extends ChangeNotifier {
  RegisterController(this._repo);

  final AuthRepository _repo;

  RegisterStatus _status = RegisterStatus.idle;
  String? _errorMessage;
  bool _obscurePassword = true;

  // ── Getters ─────────────────────────────────────────────────────────────────

  RegisterStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _status == RegisterStatus.loading;
  bool get isSuccess => _status == RegisterStatus.success;

  // ── Actions ─────────────────────────────────────────────────────────────────

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      _status = RegisterStatus.idle;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    _setLoading();
    try {
      await _repo.signUpWithEmail(email, password);
      _setSuccess();
    } catch (e) {
      _setError(_friendlyError(e));
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  void _setLoading() {
    _status = RegisterStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setSuccess() {
    _status = RegisterStatus.success;
    notifyListeners();
  }

  void _setError(String message) {
    _status = RegisterStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  String _friendlyError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('already registered') || msg.contains('already exists')) {
      return 'An account with this email already exists.';
    }
    if (msg.contains('weak password') || msg.contains('password')) {
      return 'Password is too weak. Use at least 8 characters.';
    }
    if (msg.contains('invalid email')) {
      return 'Please enter a valid email address.';
    }
    if (msg.contains('network') || msg.contains('socket')) {
      return 'No internet connection. Check your network and retry.';
    }
    return 'Something went wrong. Please try again.';
  }
}
