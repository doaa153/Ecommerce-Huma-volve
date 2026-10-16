import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/error/error_handling.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/details/data/data_source/product_details_remote_data_source.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/repository/product_details_repository.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_product_entity.dart';

class ProductDetailsRepositoryImp implements ProductDetailsRepository {
  final ProductDetailsRemoteDataSource productDetailsRemoteDataSource;

  ProductDetailsRepositoryImp(this.productDetailsRemoteDataSource);

  @override
  Future<Either<Failure, HomeProductEntity>> getProductDetails(
    int productId,
  ) async {
    try {
      final result =
          await productDetailsRemoteDataSource.getProductDetails(productId);
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}