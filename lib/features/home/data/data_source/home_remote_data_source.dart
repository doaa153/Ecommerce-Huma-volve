import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<HomeProductModel>> getProduct(int? categoryId);
  Future<List<HomeCategoryModel>> getCategories();
}