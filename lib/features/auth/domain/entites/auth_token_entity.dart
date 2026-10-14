class AuthTokenEntity {
  final String accessToken;
  final String refreshToken;

  const AuthTokenEntity({
    this.accessToken = '',
    this.refreshToken = '',
  });
}