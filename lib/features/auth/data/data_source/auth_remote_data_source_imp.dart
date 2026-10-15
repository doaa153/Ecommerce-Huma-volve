import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/core/storage/secure_storage.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/login_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/data/models/signup_res_model.dart';

class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImp(this.apiClient);

  @override
  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.loginEndpoint,
      data: {
        "email": email,
        "password": password,
      },
    );

    final Map<String, dynamic> jsonData = response.data;
    final modelData = LoginModel.fromJson(jsonData);

    await SecureStorage.saveAccessToken(modelData.accessToken);
    await SecureStorage.saveRefreshToken(modelData.refreshToken);

    return modelData;
  }

  @override
  Future<SignupResModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      ApiEndpoints.signupEndpoint,
      data: {
        "email": email,
        "name": name,
        "password": password,
        "avatar":
            "https://i.pinimg.com/736x/02/b6/ee/02b6eeea79d23f603489c9f65b3b5822.jpg",
      },
    );

    final jsonData = response.data;
    final dartData = SignupResModel.fromJson(jsonData);
    return dartData;
  }
}