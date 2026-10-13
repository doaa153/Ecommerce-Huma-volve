import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_category_entity.dart';

abstract class HomeRepository {
  Future<Either <Failure,List<HomeCategoryEntity>>> getCategories();
}