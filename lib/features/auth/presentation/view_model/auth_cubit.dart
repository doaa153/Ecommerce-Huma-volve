import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/login_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/auth/presentation/view_model/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthStates> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.signUpUseCase,
  }) : super(AuthInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    final result = await loginUseCase.invoke(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(LoginError(failure.failureMessage)),
      (token) => emit(LoginSuccess(token)),
    );
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignUpLoading());

    final result = await signUpUseCase.invoke(
      name: name,
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(SignUpError(failure.failureMessage)),
      (user) => emit(SignUpSuccess(user)),
    );
  }
}