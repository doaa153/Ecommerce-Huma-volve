import 'package:ecommerce_app_huma_volve/core/network/api_client.dart';
import 'package:ecommerce_app_huma_volve/core/theme.dart';
import 'package:ecommerce_app_huma_volve/core/widgets/primary_button.dart';
import 'package:ecommerce_app_huma_volve/features/details/data/data_source/product_details_remote_data_source_imp.dart';
import 'package:ecommerce_app_huma_volve/features/details/data/repository/product_details_repository_imp.dart';
import 'package:ecommerce_app_huma_volve/features/details/domain/use_cases/get_product_details_use_case.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentation/view/widgets/share_product_button.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentation/view_model/product_details_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentation/view_model/product_details_states.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentation/view/widgets/color_selector.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentation/view/widgets/size_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    final remoteDataSource = ProductDetailsRemoteDataSourceImp(apiClient);
    final repository = ProductDetailsRepositoryImp(remoteDataSource);
    final useCase = GetProductDetailsUseCase(repository);

    return BlocProvider(
      create: (context) =>
          ProductDetailsCubit(getProductDetailsUseCase: useCase)
            ..getProductDetails(productId),
      child: _ProductDetailsView(productId: productId),
    );
  }
}

class _ProductDetailsView extends StatelessWidget {
  final int productId;
  const _ProductDetailsView({required this.productId});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsStates>(
      builder: (context, state) {
        if (state is ProductDetailsLoading) {
          return _buildLoading(context);
        }

        if (state is ProductDetailsError) {
          return _buildError(context, state.errorMessage);
        }

        if (state is ProductDetailsSuccess) {
          return _buildSuccess(context, state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _buildBackButton(context),
      ),
      body: const Center(
        child: CircularProgressIndicator(color: AppTheme.primary),
      ),
    );
  }

  Widget _buildError(BuildContext context, String errorMessage) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _buildBackButton(context),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccess(BuildContext context, ProductDetailsSuccess state) {
    final product = state.product;
    final cubit = context.read<ProductDetailsCubit>();

    final imageUrl = product.images.isNotEmpty ? product.images.first : null;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: AppTheme.background,
            leading: _buildBackButton(context),
            actions: [
              ShareProductButton(productId: productId.toString()),
              const SizedBox(width: 8),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border, size: 18),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${product.id}',
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 48,
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 48,
                        ),
                      ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + Price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.title,
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(fontSize: 28, height: 1.2),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(color: AppTheme.primary, fontSize: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Description
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description.isNotEmpty
                          ? product.description
                          : 'No description available.',
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(height: 1.6, fontSize: 16),
                    ),
                    const SizedBox(height: 24),

                    // Color Selector
                    Text(
                      'Select Color',
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ColorSelector(
                      colors: cubit.colors,
                      selectedColor: state.selectedColor,
                      onColorSelected: (color) {
                        cubit.changeColor(color);
                      },
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Select Size',
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SizeSelector(
                      sizes: cubit.sizes,
                      selectedSize: state.selectedSize,
                      onSizeSelected: (size) {
                        cubit.changeSize(size);
                      },
                    ),
                    const SizedBox(height: 32),

                    PrimaryButton(
                      text: 'Add to Cart',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.title} added to cart'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: AppTheme.primary,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.arrow_back_ios_new, size: 16),
      ),
      onPressed: () => Navigator.pop(context),
    );
  }
}
