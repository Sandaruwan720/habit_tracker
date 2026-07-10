import 'package:flutter/foundation.dart';
import '../../domain/repositories/auth_repository.dart';

enum LoginStatus { idle, loading, success, error }

/// ChangeNotifier that drives the entire login screen UI.
class LoginController extends ChangeNotifier {
  LoginController(this._repo);

  final AuthRepository _repo;

  LoginStatus _status = LoginStatus.idle;
  String? _errorMessage;
  bool _rememberMe = false;
  bool _obscurePassword = true;

  // ── Getters ────────────────────────────────────────────────────────────────

  LoginStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get rememberMe => _rememberMe;
  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _status == LoginStatus.loading;
  bool get isSuccess => _status == LoginStatus.success;

  // ── Actions ────────────────────────────────────────────────────────────────

  void toggleRememberMe() {
    _rememberMe = !_rememberMe;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      _status = LoginStatus.idle;
      notifyListeners();
    }
  }

  // ── Auth flows ─────────────────────────────────────────────────────────────

  Future<void> signIn(String email, String password) async {
    _setLoading();
    try {
      await _repo.signInWithEmail(email.trim(), password);
      _setSuccess();
    } catch (e) {
      _setError(_friendlyError(e));
    }
  }

  Future<void> signInWithGoogle() async {
    _setLoading();
    try {
      await _repo.signInWithOAuth('google');
      _setSuccess();
    } catch (e) {
      _setError(_friendlyError(e));
    }
  }

  Future<void> signInWithApple() async {
    _setLoading();
    try {
      await _repo.signInWithOAuth('apple');
      _setSuccess();
    } catch (e) {
      _setError(_friendlyError(e));
    }
  }

  Future<void> signInWithMicrosoft() async {
    _setLoading();
    try {
      await _repo.signInWithOAuth('azure');
      _setSuccess();
    } catch (e) {
      _setError(_friendlyError(e));
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _setLoading() {
    _status = LoginStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setSuccess() {
    _status = LoginStatus.success;
    notifyListeners();
  }

  void _setError(String message) {
    _status = LoginStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  String _friendlyError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('invalid login') || msg.contains('invalid credentials')) {
      return 'Invalid email or password. Please try again.';
    }
    if (msg.contains('email not confirmed')) {
      return 'Please confirm your email before signing in.';
    }
    if (msg.contains('network') || msg.contains('socket')) {
      return 'No internet connection. Check your network and retry.';
    }
    return 'Something went wrong. Please try again.';
  }
}
