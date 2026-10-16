import 'package:ecommerce_app_huma_volve/core/constants/api_endpoints.dart';
import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/details/data/data_source/product_details_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/home/data/models/product_model.dart';

class ProductDetailsRemoteDataSourceImp
    implements ProductDetailsRemoteDataSource {
  final ApiClient apiClient;

  ProductDetailsRemoteDataSourceImp(this.apiClient);

  @override
  Future<HomeProductModel> getProductDetails(int productId) async {
    final response = await apiClient.dio.get(
      '${ApiEndpoints.productsEndpoint}/$productId',
    );

    return HomeProductModel.fromJson(response.data);
  }
}