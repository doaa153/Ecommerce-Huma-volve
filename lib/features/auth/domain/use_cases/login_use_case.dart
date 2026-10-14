import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entites/auth_token_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<Either<Failure, AuthTokenEntity>> invoke({
    required String email,
    required String password,
  }) =>
      authRepository.login(email: email, password: password);
}