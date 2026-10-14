import 'package:ecommerce_app_huma_volve/features/auth/domain/entites/auth_token_entity.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/entites/user_entity.dart';

abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class LoginLoading extends AuthStates {}

class LoginSuccess extends AuthStates {
  final AuthTokenEntity token;
  LoginSuccess(this.token);
}

class LoginError extends AuthStates {
  final String errorMessage;
  LoginError(this.errorMessage);
}

class SignUpLoading extends AuthStates {}

class SignUpSuccess extends AuthStates {
  final UserEntity user;
  SignUpSuccess(this.user);
}

class SignUpError extends AuthStates {
  final String errorMessage;
  SignUpError(this.errorMessage);
}