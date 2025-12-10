import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/tabler.dart';
import 'package:newwwwwwww/features/coupons/presentation/screens/coupons_screen.dart';
import 'package:newwwwwwww/features/home/presentation/pages/popular_categories_main_screen.dart';
import 'package:newwwwwwww/features/home/presentation/pages/popular_category_screen.dart';
import 'package:newwwwwwww/features/home/presentation/pages/suppliers/all_suppliers_screen.dart';
import 'package:newwwwwwww/features/home/presentation/pages/suppliers/product_details.dart';
import 'package:newwwwwwww/features/home/presentation/pages/suppliers/supplier_detail.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/category_card.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/custom_search_bar.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/store_card.dart';
import 'package:iconify_flutter/icons/game_icons.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/product_categories_bloc/product_categories_bloc.dart';
import '../bloc/product_categories_bloc/product_categories_event.dart';
import '../bloc/product_categories_bloc/product_categories_state.dart';
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

  @override
  void dispose() {
    _SearchController.dispose();
    super.dispose();
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ProductCategoriesBloc>().add(FetchProductCategories());
    context.read<SuppliersBloc>().add(FetchSuppliers());

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

          /// ✅ الأداء اتحسن باستخدام CustomScrollView و Slivers
          Positioned.fill(

            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            bottom: screenHeight*.05,
            child: Padding(
              padding:  EdgeInsets.only(bottom: screenHeight*.09),//top 03
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * .06,
                      //  vertical: screenHeight * .02
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        CustomSearchBar(
                          controller: _SearchController,
                          height: screenHeight,
                          width: screenWidth,
                        ),
                        SizedBox(height: screenHeight * .02),
                        BuildCarousSlider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => CouponsScreen(fromViewButton:true)));
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * .01),
                                child:
                                BuildTappedTitle('View All Coupons', screenWidth),
                              ),
                            ),
                          ],
                        ),
                        BuildStretchTitleHome(
                          screenWidth,
                          "Featured Suppliers",
                              () {
                                final state = context.read<SuppliersBloc>().state;

                                if (state is SuppliersLoaded) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => AllSuppliersScreen(suppliers:state.suppliers)));
                                } else {
                                  // لو لسه لودينج أو حصل error
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(
                                  //     content: Text('Categories are still loading, please try again.'),
                                  //   ),
                                  // );
                                }

                          },
                        ),
                        SizedBox(
                          height: screenHeight * 0.18,
                          child: BlocBuilder<SuppliersBloc, SuppliersState>(
                            builder: (context, state) {
                              if (state is SuppliersInitial || state is SuppliersLoading) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                );
                              } else if (state is SuppliersError) {
                                return Center(
                                  child: Text(
                                    'Failed to load suppliers',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              } else if (state is SuppliersLoaded) {
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
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => SupplierDetails(
                                              // لو عندك constructor بياخد supplier ابعتيه هنا
                                               supplier: supplier,
                                            ),
                                          ),
                                        );
                                      },
                                      child: StoreCard(
                                        screenWidth: screenWidth,
                                        screenHeight: screenHeight,
                                        supplier:supplier
                                        // لو StoreCard بياخد بيانات، مرّريها هنا مثلاً:
                                        // name: supplier.enName,
                                        // logoUrl: supplier.logoUrl,
                                      ),
                                    );
                                  },
                                );
                              }

                              // fallback لو حصل state غريب
                              return const SizedBox.shrink();
                            },
                          ),
                        ),

                        // SizedBox(
                        //   height: screenHeight * 0.18,
                        //   child: ListView.builder(
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount: 10,
                        //     itemBuilder: (context, index) => GestureDetector(
                        //         onTap: () {
                        //           Navigator.of(context).push(
                        //             MaterialPageRoute(builder: (_) => SupplierDetails()),
                        //           );},
                        //       child: StoreCard(
                        //         screenWidth: screenWidth,
                        //         screenHeight: screenHeight,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        BuildStretchTitleHome(
                          screenWidth,
                          "Popular Categories",
                              () {
                            final state = context.read<ProductCategoriesBloc>().state;

                            if (state is ProductCategoriesLoaded) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PopularCategoriesMainScreen(
                                    categories: state.categories,   // 👈 بنبعَت الليست هنا
                                  ),
                                ),
                              );
                            } else {
                              // لو لسه لودينج أو حصل error
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     content: Text('Categories are still loading, please try again.'),
                              //   ),
                              // );
                            }
                          },
                        ),

                        // SizedBox(
                        //   height: screenHeight * 0.15,
                        //   child: ListView(
                        //     scrollDirection: Axis.horizontal,
                        //     children: [
                        //       GestureDetector(
                        //         onTap: () {
                        //           Navigator.of(context).push(
                        //             MaterialPageRoute(builder: (_) => PopularCategoryScreen(CategoryName: 'Bottles')),
                        //           );},
                        //         child: CategoryCard(
                        //           screenWidth: screenWidth,
                        //           screenHeight: screenHeight,
                        //           icon: 'assets/images/home/main_page/bottle.svg',
                        //           title: 'Bottles',
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //           onTap: () {
                        //             Navigator.of(context).push(
                        //               MaterialPageRoute(builder: (_) => PopularCategoryScreen(CategoryName: 'Gallons')),
                        //             );},
                        //         child: CategoryCard(
                        //           screenWidth: screenWidth,
                        //           screenHeight: screenHeight,
                        //           icon: GameIcons.water_gallon,
                        //           title: 'Gallons',
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {
                        //           Navigator.of(context).push(
                        //             MaterialPageRoute(builder: (_) =>PopularCategoryScreen(CategoryName: 'Alkaline')),
                        //           );},
                        //         child: CategoryCard(
                        //           screenWidth: screenWidth,
                        //           screenHeight: screenHeight,
                        //           icon: 'assets/images/home/main_page/ph.svg',
                        //           title: 'Alkaline',
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {
                        //           Navigator.of(context).push(
                        //             MaterialPageRoute(builder: (_) => PopularCategoryScreen(CategoryName: 'Coupons')),
                        //           );},
                        //         child: CategoryCard(
                        //           screenWidth: screenWidth,
                        //           screenHeight: screenHeight,
                        //           icon: Mdi.coupon_outline,
                        //           title: 'Coupons',
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // In your MainScreen's build method, replace the SizedBox with:

                        SizedBox(
                          height: screenHeight * 0.15,
                          child: BlocBuilder<ProductCategoriesBloc, ProductCategoriesState>(
                            builder: (context, state) {
                              if (state is ProductCategoriesInitial ||
                                  state is ProductCategoriesLoading) {
                                return  Center(child: CircularProgressIndicator(color: AppColors.primary,));
                              } else if (state is ProductCategoriesError) {
                                return Center(child: Text('Error: ${state.message}'));
                              } else if (state is ProductCategoriesLoaded) {
                                if (state.categories.isEmpty) {
                                  return const Center(child: Text('No categories found'));
                                }
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: state.categories.length,
                                  itemBuilder: (context, index) {
                                    final category = state.categories[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => PopularCategoryScreen(
                                              CategoryName: category.enName ?? 'Category',
                                            ),
                                          ),
                                        );
                                      },
                                      child: CategoryCard(
                                        screenWidth: screenWidth,
                                        screenHeight: screenHeight,
                                        icon:'assets/images/home/main_page/bottle.svg',// _getCategoryIcon(category.enName ?? ''),
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


// Add this helper method to get the appropriate icon for each category
// You can customize this based on your category names

                        SizedBox(height: screenHeight * .01),
                        BuildStretchTitleHome(
                          screenWidth,
                          "Popular Products",
                              () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => AllProductScreen()));
                          },
                        ),
                      ]),
                    ),
                  ),

                  /// ✅ GridView بقى SliverGrid علشان Lazy Loading
                  SliverPadding(
                    padding:  EdgeInsets.only(left: screenWidth*.06,right: screenWidth*.06,top: screenHeight*.01,bottom: screenHeight*.03),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: screenWidth*.03,//12
                        mainAxisSpacing: screenWidth*.03, //12
                        childAspectRatio: 0.49, //0.48 handel design shimaa for product card
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return ProductCard(
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            icon: 'assets/images/home/main_page/product.jpg',
                          );
                        },
                        childCount: 10, // 🔥 غير الرقم ده حسب عدد المنتجات
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  String _getCategoryIcon(String categoryName) {
    String casee=categoryName.toLowerCase();
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
        return 'assets/images/placeholder_icon.svg'; // Add a default icon
    }
  }
}

