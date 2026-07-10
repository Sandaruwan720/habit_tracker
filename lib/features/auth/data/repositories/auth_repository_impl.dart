import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Concrete implementation of [AuthRepository] that delegates to the remote
/// Supabase datasource.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote);

  final AuthRemoteDatasource _remote;

  @override
  Future<UserEntity> signInWithEmail(String email, String password) =>
      _remote.signInWithEmail(email, password);

  @override
  Future<UserEntity> signUpWithEmail(String email, String password) =>
      _remote.signUpWithEmail(email, password);

  @override
  Future<void> signInWithOAuth(String provider) =>
      _remote.signInWithOAuth(provider);

  @override
  Future<void> signOut() => _remote.signOut();

  @override
  Future<UserEntity?> getCurrentUser() => _remote.getCurrentUser();
}
