import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_entity.dart';

/// Talks directly to Supabase Auth for sign-in, sign-up, and OAuth flows.
class AuthRemoteDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  // ---------------------------------------------------------------------------
  // Email / Password
  // ---------------------------------------------------------------------------

  Future<UserEntity> signInWithEmail(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return _mapUser(response.user!);
  }

  Future<UserEntity> signUpWithEmail(String email, String password) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );
    return _mapUser(response.user!);
  }

  // ---------------------------------------------------------------------------
  // OAuth (Google / Apple / Microsoft)
  // ---------------------------------------------------------------------------

  /// Opens the OAuth provider's consent screen in the system browser.
  ///
  /// [provider] must be one of: 'google', 'apple', 'azure'
  ///
  /// ⚠️  Each provider must be enabled in:
  ///     Supabase Dashboard → Authentication → Providers
  Future<void> signInWithOAuth(String provider) async {
    final OAuthProvider oauthProvider = _resolveProvider(provider);
    await _client.auth.signInWithOAuth(
      oauthProvider,
      redirectTo: 'io.supabase.habitflow://login-callback/',
    );
  }

  // ---------------------------------------------------------------------------
  // Session
  // ---------------------------------------------------------------------------

  Future<void> signOut() async => _client.auth.signOut();

  Future<UserEntity?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    return user != null ? _mapUser(user) : null;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  UserEntity _mapUser(User user) => UserEntity(
        id: user.id,
        email: user.email ?? '',
        displayName: user.userMetadata?['full_name'] as String?,
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
      );

  OAuthProvider _resolveProvider(String provider) {
    switch (provider) {
      case 'google':
        return OAuthProvider.google;
      case 'apple':
        return OAuthProvider.apple;
      case 'azure':
        return OAuthProvider.azure;
      default:
        throw ArgumentError('Unknown OAuth provider: $provider');
    }
  }
}
