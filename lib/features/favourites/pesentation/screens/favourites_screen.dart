import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/favourites/domain/models/favorite_product.dart';
import 'package:newwwwwwww/features/home/domain/models/supplier_model.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/supplier_full_card.dart';
import '../../../../core/theme/colors.dart';
import '../../../home/presentation/pages/suppliers/supplier_detail.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../provider/favourite_controller.dart';
import '../widgets/favourite_product_card.dart';



class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late FavoritesController favController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    favController = FavoritesController(dio: Dio());
    favController.fetchFavoriteProducts(); // ✅ أول تحميل
    favController.fetchFavoriteVendors(); // ✅ ADD THIS

  }

  @override
  void dispose() {
    _tabController.dispose();
    favController.dispose();
    super.dispose();
  }

  String? imageUrl = null;

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
            title: 'Favorites',
            is_returned: false,
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            bottom: screenHeight * .05,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: screenHeight * .1,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * .004,
                          horizontal: screenWidth * .004,
                        ),
                        margin: EdgeInsets.only(
                          left: .06 * screenWidth,
                          right: .06 * screenWidth,
                          bottom: screenHeight * .03,
                        ),
                        height: screenHeight * .05,
                        decoration: BoxDecoration(
                          color: AppColors.tabViewBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TabBar(
                          padding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * .01,
                          ),
                          controller: _tabController,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.whiteColor,
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                          unselectedLabelColor:
                          AppColors.greyDarktextIntExtFieldAndIconsHome,
                          tabs: [
                            SizedBox(
                              width: screenWidth * .5,
                              child: const Tab(text: 'Products'),
                            ),
                            SizedBox(
                              width: screenWidth * .5,
                              child: const Tab(text: 'Stores'),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: screenHeight * .65,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // =======================
                            // ✅ Products Tab (Favorites API)
                            // =======================
                            AnimatedBuilder(
                              animation: favController,
                              builder: (context, _) {
                                // Loading
                                if (favController.isLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                    ),
                                  );
                                }

                                // Error
                                if (favController.error != null) {
                                  return Center(
                                    child: Text(
                                      favController.error!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  );
                                }

                                final List<FavoriteProduct> favs =
                                    favController.favorites;

                                if (favs.isEmpty) {
                                  return const Center(
                                      child: Text('No favourite products'));
                                }

                                return ListView.builder(
                                  padding: EdgeInsets.only(
                                      bottom: screenHeight * 0.06),
                                  itemCount: favs.length,
                                  itemBuilder: (context, index) {
                                    final fav = favs[index];

                                    // ⚠️ أنت قلت: "كل الموضوع عايزه دي تمشي ع ال list"
                                    // فهنستخدم نفس FavouriteProductCard زي ما هو
                                    // (لو الكارد عندك بياخد product data ابعتلي constructor وأنا أركّبه)
                                    return FavouriteProductCard(
                                      screenWidth: screenWidth,
                                      screenHeight: screenHeight,
                                      favouriteProduct:fav,
                                    );
                                  },
                                );
                              },
                            ),

                            // =======================
                            // Stores Tab (زي ما هو عندك مؤقت)
                            // =======================
                            AnimatedBuilder(
                              animation: favController,
                              builder: (context, _) {
                                if (favController.isLoadingVendors) {
                                  return Center(
                                    child: CircularProgressIndicator(color: AppColors.primary),
                                  );
                                }

                                if (favController.vendorsError != null) {
                                  return Center(
                                    child: Text(
                                      favController.vendorsError!,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  );
                                }

                                final vendors = favController.favoriteVendors;

                                if (vendors.isEmpty) {
                                  return const Center(child: Text('No favourite stores'));
                                }

                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: vendors.length,
                                  itemBuilder: (context, index) {
                                    final favVendor = vendors[index];
                                    final supplier = favVendor.supplier;
                                     log('${supplier!.rating.toString()}  ${supplier!.arName} ${supplier!.enName}');
                                    if (supplier == null) {
                                      return const SizedBox.shrink();
                                    }

                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SupplierDetails(supplier: supplier),
                                          ),
                                        );
                                      },
                                      child: BuildFullCardSupplier(
                                        screenHeight,
                                        screenWidth,
                                        supplier,
                                        supplier.isVerified,
                                        fromFavouritesScreen: true,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
