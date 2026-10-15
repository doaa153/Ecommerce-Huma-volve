import 'package:ecommerce_app_huma_volve/features/auth/domain/entites/user_entity.dart';

class SignupResModel extends UserEntity {


  const SignupResModel(
      {super.id,
      super.email,
      super.name,
      super.role,
      super.avatar,});

factory SignupResModel.fromJson(Map<String, dynamic> json) {
    return SignupResModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }
}
  // SignupResModel.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   email = json['email'];
  //   password = json['password'];
  //   name = json['name'];
  //   role = json['role'];
  //   avatar = json['avatar'];
  // }
