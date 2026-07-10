import '../entities/user_entity.dart';

/// Contract for all authentication operations.
abstract class AuthRepository {
  /// Sign in with email and password.
  Future<UserEntity> signInWithEmail(String email, String password);

  /// Create a new account with email and password.
  Future<UserEntity> signUpWithEmail(String email, String password);

  /// OAuth sign-in — provider: 'google' | 'apple' | 'azure'
  Future<void> signInWithOAuth(String provider);

  /// Sign out the current user.
  Future<void> signOut();

  /// Returns the currently authenticated user, or null if not signed in.
  Future<UserEntity?> getCurrentUser();
}
