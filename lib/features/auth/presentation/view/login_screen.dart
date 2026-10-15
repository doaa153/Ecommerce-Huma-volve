import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/theme.dart';
import '../../../main_navigation/screens/main_navigation_screen.dart';
import '../../data/data_source/auth_remote_data_source.dart';
import '../../data/data_source/auth_remote_data_source_imp.dart';
import '../../data/repository/auth_repository_imp.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/sign_up_use_case.dart';
import '../view_model/auth_cubit.dart';
import '../view_model/auth_states.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  late final ApiClient apiClient;
  late final AuthRemoteDataSource authRemoteDataSource;
  late final AuthRepository authRepository;
  late final LoginUseCase loginUseCase;
  late final SignUpUseCase signUpUseCase;
  late final AuthCubit authCubit;
  bool isLoading = false;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    apiClient = ApiClient();
    authRemoteDataSource = AuthRemoteDataSourceImp(apiClient);
    authRepository = AuthRepositoryImp(authRemoteDataSource);
    loginUseCase = LoginUseCase(authRepository);
    signUpUseCase = SignUpUseCase(authRepository);
    authCubit = AuthCubit(
      loginUseCase: loginUseCase,
      signUpUseCase: signUpUseCase,
    );
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    authCubit.close();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      authCubit.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authCubit,
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppTheme.background,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 60),
                      Icon(
                        Icons.shopping_bag,
                        size: 80,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Welcome Back!',
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(fontSize: 32),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Login to continue your shopping',
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 64),
                      CustomTextField(
                        controller: emailController,
                        hintText: 'Email Address',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      BlocConsumer<AuthCubit, AuthStates>(
                        listener: (context, state) {
                          if (state is LoginSuccess) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MainNavigationScreen(),
                              ),
                            );
                          } else if (state is LoginError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.errorMessage)),
                            );
                          }
                        },
                        builder: (context, state) {
                          final isLoading = state is LoginLoading;

                          return PrimaryButton(
                            text: 'Login',
                            onPressed: _login,
                            isLoading: isLoading,
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account? '),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                  ) => const SignUpScreen(),
                                  transitionsBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                ),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
