import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<HomeProductModel>> getProduct(int? categoryId,{required int limit, required int offset});
  Future<List<HomeCategoryModel>> getCategories();
}