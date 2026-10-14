import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_categories_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/use_cases/get_products_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  final GetCategoriesUseCase categoriesUseCase;
  final GetProductsUseCase productsUseCase;
  HomeCubit({required this.categoriesUseCase, required this.productsUseCase})
    : super(HomeInitial());

  void loadHomeData() async {
    int categoryId=0;
    emit(CategoriesLoading());

    final categories = await categoriesUseCase.invoke();
    categories.fold((failure) {
      emit(CategoriesError(failure.failureMessage));
    }, (categories) {
      categoryId= categories[0].id;
      emit(CategoriesSuccess(categories));
    });
    final products = await productsUseCase.invoke(categoryId);
    products.fold((failure){
      emit(ProductsError(failure.failureMessage));
    }, (products){
      emit(ProductsSuccess(products));
    });
  }

  Future<void> loadProductsByCategory(int id) async {
    emit(ProductsLoading());


      final products = await productsUseCase.invoke(id);
      products.fold((failure){
        emit(ProductsError(failure.failureMessage));
      },(products){
        emit(ProductsSuccess(products));
      });
      
    
  }
}
