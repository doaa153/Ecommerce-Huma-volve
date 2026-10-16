import 'package:ecommerce_app_huma_volve/features/home/domain/entites/home_product_entity.dart';
import 'package:flutter/material.dart';

abstract class ProductDetailsStates {}

class ProductDetailsInitial extends ProductDetailsStates {}

class ProductDetailsLoading extends ProductDetailsStates {}

class ProductDetailsSuccess extends ProductDetailsStates {
  final HomeProductEntity product;
  final Color selectedColor;
  final String selectedSize;

  ProductDetailsSuccess({
    required this.product,
    required this.selectedColor,
    required this.selectedSize,
  });
}

class ProductDetailsError extends ProductDetailsStates {
  final String errorMessage;

  ProductDetailsError(this.errorMessage);
}