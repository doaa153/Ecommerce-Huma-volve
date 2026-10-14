import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handling.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entites/auth_token_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entites/user_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImp(this.authRemoteDataSource);

  @override
  Future<Either<Failure, AuthTokenEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await authRemoteDataSource.login(
        email: email,
        password: password,
      );
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final result = await authRemoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
      );
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}