import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/home_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/view_model/home_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dummy_data.dart';
import '../../../../core/theme.dart';
import 'widgets/product_card.dart';
import 'widgets/category_chip.dart';

import 'package:ecommerce_app_huma_volve/features/home/data/models/category_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  List<HomeCategoryModel> categories = [];
  late final ScrollController scrollController;

  @override
  void initState() {
    context.read<HomeCubit>().loadHomeData();
    scrollController = ScrollController();
    scrollController.addListener(_onListen);
    super.initState();
  }

  void _onListen() {
    final pixels = scrollController.position.pixels;
    final max = scrollController.position.maxScrollExtent;
    final int triggerDistance = 200;
    print('current pixels:$pixels , max= $max');
    if (pixels >= max - triggerDistance) {
      context.read<HomeCubit>().loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.menu,
                            color: AppTheme.primary,
                          ),
                        ),
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            dummyUser.profilePictureUrl,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Explore',
                      style: Theme.of(context).textTheme.displayLarge
                          ?.copyWith(fontSize: 36),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Best trendy collection!',
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search clothes...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<HomeCubit, HomeStates>(
                      buildWhen: (previous, current) {
                        if (current is ProductsLoading ||
                            current is ProductsSuccess ||
                            current is ProductsError ||
                            current is ProductsLoadingError ||
                            current is ProductsLoadingMore) {
                          return false;
                        }
                        return true;
                      },
                      builder: (BuildContext context, state) {
                        if (state is CategoriesLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is CategoriesError) {
                          return Center(child: Text(state.errorMessage));
                        } else if (state is CategoriesSuccess) {
                          final categories = state.categories;
                          return SizedBox(
                            height: 44,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                return CategoryChip(
                                  label: categories[index].name ?? 'All',
                                  isSelected: _selectedCategoryIndex == index,
                                  onTap: () {
                                    setState(() {
                                      _selectedCategoryIndex = index;
                                    });
                                    context
                                        .read<HomeCubit>()
                                        .loadProductsByCategory(
                                          categories[index].id!,
                                        );
                                  },
                                );
                              },
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),

              sliver: BlocBuilder<HomeCubit, HomeStates>(
                buildWhen: (previous, current) {
                  if (current is ProductsLoadingError ||
                      current is ProductsLoadingMore) {
                    return false;
                  }
                  return true;

                  // return current is ProductsLoading ||
                  //     current is ProductsSuccess ||
                  //     current is ProductsError;
                },
                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }

                  if (state is ProductsError) {
                    return SliverToBoxAdapter(
                      child: Center(child: Text(state.errorMessage)),
                    );
                  }

                  if (state is ProductsSuccess) {
                    final products = state.products;

                    if (products.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text('No products found'),
                          ),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.58,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return ProductCard(product: products[index]);
                        }, childCount: products.length),
                      ),
                    );
                  }

                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ),
            BlocBuilder<HomeCubit, HomeStates>(
              builder: (context, state) {
                if (state is ProductsLoadingMore) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }
                return SliverToBoxAdapter(child: SizedBox(height: 24));
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
