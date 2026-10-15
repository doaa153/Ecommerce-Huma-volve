import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_category_entity.dart';

class HomeCategoryModel extends HomeCategoryEntity {
  const HomeCategoryModel({
    super.id,
    super.name,
  });

  factory HomeCategoryModel.fromJson(Map<String, dynamic> json) {
    return HomeCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}