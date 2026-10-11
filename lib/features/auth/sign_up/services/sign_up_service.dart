import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_req_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_res_model.dart';

class SignUpService {
  ApiClient apiClient;
  SignUpService(this.apiClient);
  Future<SignupResModel> signUp(SignupReqModel signupReqModel) async{
    final response= await apiClient.dio.post(
      ApiEndpoints.signupEndpoint,
      data: {
  "email": signupReqModel.email,
  "name": signupReqModel.name,
  "password": signupReqModel.password,
  "avatar": "https://i.pinimg.com/736x/02/b6/ee/02b6eeea79d23f603489c9f65b3b5822.jpg"
});
final jsonData = response.data;
final dartData= SignupResModel.fromJson(jsonData);
return dartData;
  }
}