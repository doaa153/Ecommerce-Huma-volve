import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_product_entity.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_categories_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_products_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  final GetCategoriesUseCase categoriesUseCase;
  final GetProductsUseCase productsUseCase;
  final int limit = 10;
  int offset = 0;
  bool isLoadingMore = false;
  bool hasMore = true;
  int? selectedCategory;
  final List<HomeProductEntity> _products = [];
  HomeCubit({required this.categoriesUseCase, required this.productsUseCase})
    : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(CategoriesLoading());

    final categoriesResult = await categoriesUseCase.invoke();
    int categoryId = 0;

    categoriesResult.fold(
      (failure) {
        emit(CategoriesError(failure.failureMessage));
      },
      (categories) {
        categoryId = categories.isNotEmpty ? categories[0].id : 0;
        emit(CategoriesSuccess(categories));
      },
    );
    _products.clear();
    offset = 0;
    hasMore = true;
    isLoadingMore = false;
    selectedCategory = categoryId;
    emit(ProductsLoading());
    final productsResult = await productsUseCase.invoke(
      categoryId,
      limit: limit,
      offset: offset,
    );
    productsResult.fold(
      (failure) {
        emit(ProductsError(failure.failureMessage));
      },
      (products) {
        _products.addAll(products);
        offset = products.length;
        if (products.length < limit) {
          hasMore = false;
        }
        emit(ProductsSuccess(List.from(products)));
      },
    );
  }

  Future<void> loadProductsByCategory(int id) async {
    _products.clear();
    offset = 0;
    hasMore = true;
    isLoadingMore = false;
    selectedCategory = id;
    emit(ProductsLoading());
    // hasMore = true;

    final productsResult = await productsUseCase.invoke(
      id,
      limit: limit,
      offset: offset,
    );
    productsResult.fold(
      (failure) {
        emit(ProductsError(failure.failureMessage));
      },
      (products) {
        _products.addAll(products);
        offset = products.length;
        if (products.length < limit) {
          hasMore = false;
        }
        // selectedCategory = id;
        emit(ProductsSuccess(List.from(_products)));
      },
    );
  }

  Future<void> loadMoreProducts() async {
    if (isLoadingMore || !hasMore) return;
    isLoadingMore = true;
    emit(ProductsLoadingMore());
    final result = await productsUseCase.invoke(
      selectedCategory,
      limit: limit,
      offset: offset,
    );
    result.fold(
      (failure) {
        emit(ProductsLoadingError(errorMessage: failure.failureMessage));
      },
      (newProducts) {
        _products.addAll(newProducts);
        offset += newProducts.length;
        if (newProducts.length < limit) {
          hasMore = false;
        }
        isLoadingMore = false;
        emit(ProductsSuccess(List.from(_products)));
      },
    );
  }
}
