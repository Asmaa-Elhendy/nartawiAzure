import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:newwwwwwww/features/coupons/presentation/screens/coupons_screen.dart';
import 'package:newwwwwwww/features/home/domain/models/product_model.dart';
import 'package:newwwwwwww/features/home/presentation/bloc/products_bloc/products_event.dart';
import 'package:newwwwwwww/features/home/presentation/pages/popular_categories_main_screen.dart';
import 'package:newwwwwwww/features/home/presentation/pages/popular_category_screen.dart';
import 'package:newwwwwwww/features/home/presentation/pages/suppliers/all_suppliers_screen.dart';
import 'package:newwwwwwww/features/home/presentation/pages/suppliers/supplier_detail.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/category_card.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/custom_search_bar.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/store_card.dart';
import 'package:iconify_flutter/icons/game_icons.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/product_categories_bloc/product_categories_bloc.dart';
import '../bloc/product_categories_bloc/product_categories_event.dart';
import '../bloc/product_categories_bloc/product_categories_state.dart';
import '../bloc/products_bloc/products_bloc.dart';
import '../bloc/products_bloc/products_state.dart';
import '../bloc/suppliers_bloc/suppliers_bloc.dart';
import '../bloc/suppliers_bloc/suppliers_event.dart';
import '../bloc/suppliers_bloc/suppliers_state.dart';
import '../widgets/background_home_Appbar.dart';
import '../widgets/build_ForegroundAppBarHome.dart';
import '../widgets/main_screen_widgets/build_carous_slider.dart';
import '../widgets/main_screen_widgets/build_tapped_blue_title.dart';
import '../widgets/main_screen_widgets/products/product_card.dart';
import 'all_product_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _SearchController = TextEditingController();

  // ✅ GlobalKey عشان ننادي refresh() في BuildCarousSlider
  final GlobalKey<BuildCarousSliderState> _sliderKey = GlobalKey();

  @override
  void dispose() {
    _SearchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<ProductCategoriesBloc>().add(FetchProductCategories());
    context.read<SuppliersBloc>().add(FetchFeaturedSuppliers());
    context.read<ProductsBloc>().add(FetchProducts(executeClear: true));
  }

  Future<void> _onRefresh() async {
    debugPrint('🔄 PULL TO REFRESH TRIGGERED');

    // ✅ Reload categories
    context.read<ProductCategoriesBloc>().add(FetchProductCategories());

    // ✅ Reload featured suppliers
    context.read<SuppliersBloc>().add(FetchFeaturedSuppliers());

    // ✅ Reload products (first page)
    context.read<ProductsBloc>().refresh(
      supplierId: null,
      categoryId: null,
    );

    // ✅ Refresh slider (coupon balance API)
    _sliderKey.currentState?.refresh();

    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            color: AppColors.backgrounHome,
          ),
          buildBackgroundAppbar(screenWidth),
          BuildForegroundappbarhome(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            title: 'NARTAWI',
            is_returned: false,
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            bottom: screenHeight * .05,
            child: Padding(
              padding: EdgeInsets.only(bottom: screenHeight * .09),
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _onRefresh,

                // ✅ أهم تعديل: امنعي refresh إلا لو المستخدم في أعلى الصفحة
                notificationPredicate: (notification) {
                  return notification.metrics.pixels <= 0;
                },

                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * .06,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          CustomSearchBar(
                            controller: _SearchController,
                            height: screenHeight,
                            width: screenWidth,
                          ),
                          SizedBox(height: screenHeight * .02),

                          // ✅ هنا التعديل: key
                          BuildCarousSlider(key: _sliderKey),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CouponsScreen(fromViewButton: true),
                                    ),
                                  )
                                      .then((_) {
                                    context.read<ProductsBloc>().refresh();
                                    // ✅ optional: كمان حدثي السلايدر بعد الرجوع
                                    // _sliderKey.currentState?.refresh();
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * .01),
                                  child: BuildTappedTitle(
                                      'View All Coupons', screenWidth),
                                ),
                              ),
                            ],
                          ),
                          BuildStretchTitleHome(
                            screenWidth,
                            "Featured Suppliers",
                                () {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (_) => AllSuppliersScreen(),
                                ),
                              )
                                  .then((_) {
                                context.read<ProductsBloc>().refresh();
                                // Refresh featured suppliers when returning
                                context.read<SuppliersBloc>().add(FetchFeaturedSuppliers());
                              });
                            },
                          ),
                          SizedBox(
                            height: screenHeight * 0.18,
                            child: BlocBuilder<SuppliersBloc, SuppliersState>(
                              builder: (context, state) {
                                if (state is SuppliersInitial ||
                                    state is SuppliersLoading ||
                                    state is FeaturedSuppliersLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                    ),
                                  );
                                } else if (state is SuppliersError ||
                                    state is FeaturedSuppliersError) {
                                  final errorMessage = state is SuppliersError 
                                    ? state.message 
                                    : (state as FeaturedSuppliersError).message;
                                  return Center(
                                    child: Text(
                                      errorMessage,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  );
                                } else if (state is FeaturedSuppliersLoaded) {
                                  if (state.featuredSuppliers.isEmpty) {
                                    return const Center(
                                      child: Text('No featured suppliers found'),
                                    );
                                  }

                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.featuredSuppliers.length,
                                    itemBuilder: (context, index) {
                                      final supplier = state.featuredSuppliers[index];

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (_) => SupplierDetails(
                                                supplier: supplier,
                                              ),
                                            ),
                                          )
                                              .then((_) {
                                            context
                                                .read<ProductsBloc>()
                                                .refresh();
                                          });
                                        },
                                        child: StoreCard(
                                          screenWidth: screenWidth,
                                          screenHeight: screenHeight,
                                          supplier: supplier,
                                        ),
                                      );
                                    },
                                  );
                                } else if (state is SuppliersLoaded) {
                                  // Fallback to regular suppliers if featured suppliers not loaded yet
                                  if (state.suppliers.isEmpty) {
                                    return const Center(
                                      child: Text('No suppliers found'),
                                    );
                                  }

                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.suppliers.length,
                                    itemBuilder: (context, index) {
                                      final supplier = state.suppliers[index];

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (_) => SupplierDetails(
                                                supplier: supplier,
                                              ),
                                            ),
                                          )
                                              .then((_) {
                                            context
                                                .read<ProductsBloc>()
                                                .refresh();
                                          });
                                        },
                                        child: StoreCard(
                                          screenWidth: screenWidth,
                                          screenHeight: screenHeight,
                                          supplier: supplier,
                                        ),
                                      );
                                    },
                                  );
                                }

                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          BuildStretchTitleHome(
                            screenWidth,
                            "Popular Categories",
                                () {
                              final state = context
                                  .read<ProductCategoriesBloc>()
                                  .state;

                              if (state is ProductCategoriesLoaded) {
                                Navigator.of(context)
                                    .push(
                                  MaterialPageRoute(
                                    builder: (_) => PopularCategoriesMainScreen(
                                      categories: state.categories,
                                    ),
                                  ),
                                )
                                    .then((_) {
                                  context.read<ProductsBloc>().refresh();
                                });
                              }
                            },
                          ),
                          SizedBox(
                            height: screenHeight * 0.15,
                            child: BlocBuilder<ProductCategoriesBloc,
                                ProductCategoriesState>(
                              builder: (context, state) {
                                if (state is ProductCategoriesInitial ||
                                    state is ProductCategoriesLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                        color: AppColors.primary),
                                  );
                                } else if (state is ProductCategoriesError) {
                                  return Center(
                                    child: Text('Error: ${state.message}'),
                                  );
                                } else if (state is ProductCategoriesLoaded) {
                                  if (state.categories.isEmpty) {
                                    return const Center(
                                        child: Text('No categories found'));
                                  }

                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.categories.length,
                                    itemBuilder: (context, index) {
                                      final category = state.categories[index];

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  PopularCategoryScreen(
                                                    category: category,
                                                  ),
                                            ),
                                          )
                                              .then((_) {
                                            context
                                                .read<ProductsBloc>()
                                                .refresh();
                                          });
                                        },
                                        child: CategoryCard(
                                          screenWidth: screenWidth,
                                          screenHeight: screenHeight,
                                          icon: 'assets/images/home/main_page/bottle.svg',
                                          title: category.enName ?? 'Category',
                                        ),
                                      );
                                    },
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          SizedBox(height: screenHeight * .01),
                          BuildStretchTitleHome(
                            screenWidth,
                            "Popular Products",
                                () {
                              final productState =
                                  context.read<ProductsBloc>().state;

                              if (productState is ProductsLoaded) {
                                Navigator.of(context)
                                    .push(
                                  MaterialPageRoute(
                                    builder: (_) => AllProductScreen(),
                                  ),
                                )
                                    .then((_) {
                                  context.read<ProductsBloc>().refresh();
                                });
                              } else if (productState is ProductsLoading ||
                                  productState is ProductsInitial) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Products are still loading, please try again.'),
                                  ),
                                );
                              }
                            },
                          ),
                        ]),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.only(
                        left: screenWidth * .06,
                        right: screenWidth * .06,
                        top: screenHeight * .01,
                        bottom: screenHeight * .03,
                      ),
                      sliver: BlocBuilder<ProductsBloc, ProductsState>(
                        builder: (context, state) {
                          if (state is ProductsInitial ||
                              state is ProductsLoading) {
                            return SliverToBoxAdapter(
                              child: Center(
                                child: Padding(
                                  padding:
                                  EdgeInsets.only(top: screenHeight * .02),
                                  child: CircularProgressIndicator(
                                      color: AppColors.primary),
                                ),
                              ),
                            );
                          } else if (state is ProductsError) {
                            return SliverToBoxAdapter(
                              child: Center(
                                child: Padding(
                                  padding:
                                  EdgeInsets.only(top: screenHeight * .02),
                                  child: const Text(
                                    'Failed to load products',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            );
                          } else if (state is ProductsLoaded) {
                            final products = state.response.items;

                            if (products.isEmpty) {
                              return SliverToBoxAdapter(
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: screenHeight * .02),
                                    child: const Text('No products found'),
                                  ),
                                ),
                              );
                            }

                            return SliverGrid(
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: screenWidth * .03,
                                mainAxisSpacing: screenWidth * .03,
                                childAspectRatio: 0.49,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  ClientProduct product = products[index];

                                  return ProductCard(
                                    screenWidth: screenWidth,
                                    screenHeight: screenHeight,
                                    product: product,
                                    icon:
                                    'assets/images/home/main_page/product.jpg',
                                  );
                                },
                                childCount: products.length.clamp(0, 10),
                              ),
                            );
                          }

                          return const SliverToBoxAdapter(
                              child: SizedBox.shrink());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryIcon(String categoryName) {
    String casee = categoryName.toLowerCase();
    switch (casee) {
      case 'bottle':
        return 'assets/images/home/main_page/bottle.svg';
      case 'gallon':
        return GameIcons.water_gallon;
      case 'alkaline':
        return 'assets/images/home/main_page/ph.svg';
      case 'coupons':
        return Mdi.coupon_outline;
      default:
        return 'assets/images/placeholder_icon.svg';
    }
  }
}
