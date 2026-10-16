import 'package:ecommerce_app_huma_volve/features/home/data/models/product_model.dart';

abstract class ProductDetailsRemoteDataSource {
  Future<HomeProductModel> getProductDetails(int productId);
}