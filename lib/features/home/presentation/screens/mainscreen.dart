import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/tabler.dart';
import 'package:newwwwwwww/features/home/presentation/screens/all_product_screen.dart';
import 'package:newwwwwwww/features/home/presentation/screens/popular_categories_screen.dart';
import 'package:newwwwwwww/features/home/presentation/screens/suppliers/all_suppliers_screen.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/category_card.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/custom_search_bar.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/store_card.dart';
import 'package:iconify_flutter/icons/game_icons.dart';
import '../../../../core/theme/colors.dart';
import '../widgets/background_home_Appbar.dart';
import '../widgets/build_ForegroundAppBarHome.dart';
import '../widgets/main_screen_widgets/build_carous_slider.dart';
import '../widgets/main_screen_widgets/build_tapped_blue_title.dart';
import '../widgets/main_screen_widgets/products/product_card.dart';

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
            child: Padding(
              padding:  EdgeInsets.only(top: screenHeight*.03,bottom: screenHeight*.09),
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
                              onTap: () {},
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
                          "Featured Stores",
                              () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => AllSuppliersScreen()));
                          },
                        ),
                        SizedBox(
                          height: screenHeight * 0.18,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) => StoreCard(
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                            ),
                          ),
                        ),
                        BuildStretchTitleHome(
                          screenWidth,
                          "Popular Categories",
                              () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => PopularCategoriesScreen()));
                          },
                        ),
                        SizedBox(
                          height: screenHeight * 0.15,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              CategoryCard(
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                                icon: Tabler.bottle,
                                title: 'Bottles',
                              ),
                              CategoryCard(
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                                icon: GameIcons.water_gallon,
                                title: 'Gallons',
                              ),
                              CategoryCard(
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                                icon: MaterialSymbols.water_drop_outline_rounded,
                                title: 'Alkaline',
                              ),
                              CategoryCard(
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                                icon: Mdi.coupon_outline,
                                title: 'Coupons',
                              ),
                            ],
                          ),
                        ),
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
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.48,
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
}
