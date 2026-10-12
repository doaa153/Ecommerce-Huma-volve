import 'package:ecommerce_app_huma_volve/features/home/cubit/home_states.dart';
import 'package:ecommerce_app_huma_volve/features/home/services/home_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeService homeService;
  HomeCubit(this.homeService) : super(HomeInitial());

  void loadHomeData() async {
    emit(CategoriesLoading());
    try {
      final categories = await homeService.getCategories();
      emit(CategoriesSuccess(categories));
      final products = await homeService.getProduct(categories[0].id);
      emit(ProductsSuccess(products));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }
  
Future<void> loadProductsByCategory(int categoryId) async {
  emit(ProductsLoading());

  try {
    final products = await homeService.getProduct(categoryId);
    emit(ProductsSuccess(products));
  } catch (e) {
    emit(ProductsError(e.toString()));
  }
}

}
