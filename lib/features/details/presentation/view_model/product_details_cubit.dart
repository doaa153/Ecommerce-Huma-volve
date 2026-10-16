import 'package:ecommerce_app_huma_volve/features/details/domain/use_cases/get_product_details_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentation/view_model/product_details_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsStates> {
  final GetProductDetailsUseCase getProductDetailsUseCase;

  // ===== الألوان والمقاسات الثابتة (زي ما كانت في الـ Screen القديمة) =====
  final List<Color> colors = [
    Colors.black,
    Colors.grey,
    Colors.brown,
  ];

  final List<String> sizes = [
    'S',
    'M',
    'L',
    'XL',
  ];

  late Color selectedColor;
  late String selectedSize;

  ProductDetailsCubit({required this.getProductDetailsUseCase})
      : super(ProductDetailsInitial()) {
    selectedColor = colors.first;
    selectedSize = sizes.first;
  }

  Future<void> getProductDetails(int productId) async {
    emit(ProductDetailsLoading());

    final result = await getProductDetailsUseCase.invoke(productId);

    result.fold(
      (failure) => emit(ProductDetailsError(failure.failureMessage)),
      (product) {
        emit(ProductDetailsSuccess(
          product: product,
          selectedColor: selectedColor,
          selectedSize: selectedSize,
        ));
      },
    );
  }

  void changeColor(Color color) {
    selectedColor = color;

    if (state is ProductDetailsSuccess) {
      final currentState = state as ProductDetailsSuccess;
      emit(ProductDetailsSuccess(
        product: currentState.product,
        selectedColor: selectedColor,
        selectedSize: selectedSize,
      ));
    }
  }

  void changeSize(String size) {
    selectedSize = size;

    if (state is ProductDetailsSuccess) {
      final currentState = state as ProductDetailsSuccess;
      emit(ProductDetailsSuccess(
        product: currentState.product,
        selectedColor: selectedColor,
        selectedSize: selectedSize,
      ));
    }
  }
}