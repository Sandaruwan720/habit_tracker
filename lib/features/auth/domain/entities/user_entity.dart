/// Immutable domain entity representing a signed-in user.
class UserEntity {
  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;

  @override
  String toString() =>
      'UserEntity(id: $id, email: $email, displayName: $displayName)';
}
