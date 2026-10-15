import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_product_entity.dart';

import '../../domain/entites/home_category_entity.dart';
import 'category_model.dart';

class HomeProductModel extends HomeProductEntity{
  HomeProductModel({
    super.id,
    super.title,
    super.slug,
    super.price,
    super.description,
    super.category,
    super.images,
  });

  HomeProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    price = json['price'];
    description = json['description'];
    category = json['category'] != null
        ? HomeCategoryModel.fromJson(json['category'])
        : HomeCategoryEntity();
    images = json['images'].cast<String>();
  }
}
