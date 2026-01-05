import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  // ✅ مهم: RefreshIndicator لازم ScrollController/Physics قابلة للسحب
  final ScrollController _productsScroll = ScrollController();
  final ScrollController _storesScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // ✅ Get controller from provider instead of creating new instance
    favController = context.read<FavoritesController>();
    
    // ✅ Delay the fetch calls to avoid calling notifyListeners during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        favController.fetchFavoriteProducts(); // ✅ أول تحميل
        favController.fetchFavoriteVendors(); // ✅ أول تحميل للتاب التاني
      }
    });
  }

  @override
  void dispose() {
    _productsScroll.dispose();
    _storesScroll.dispose();
    _tabController.dispose();
    // ✅ Don't dispose favController here - provider handles it
    super.dispose();
  }

  Future<void> _onRefreshCurrentTab() async {
    // 0 = Products, 1 = Stores
    if (_tabController.index == 0) {
      await favController.refresh(); // products
    } else {
      await favController.refreshVendors(); // stores
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure the context is still valid
    if (!mounted || context.mounted == false) return const SizedBox.shrink();
    
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
              padding: EdgeInsets.only(bottom: screenHeight * .1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tabs header
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
                      labelPadding: EdgeInsets.symmetric(horizontal: screenWidth * .01),
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
                      unselectedLabelColor: AppColors.greyDarktextIntExtFieldAndIconsHome,
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

                  // ✅ RefreshIndicator لازم يبقى فوق Scrollable
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // =======================
                        // ✅ Products Tab + Refresh
                        // =======================
                        AnimatedBuilder(
                          animation: favController,
                          builder: (context, _) {
                            final favs = favController.favorites.where((fav) => fav.product != null).toList();

                            // Wrap list in RefreshIndicator
                            return RefreshIndicator(
                              color: AppColors.primary,
                              onRefresh: () async {
                                await favController.refresh(); // products only
                              },
                              child: Builder(
                                builder: (_) {
                                  if (favController.isLoading && favs.isEmpty) {
                                    // لازم Scrollable حتى لو Loading
                                    return ListView(
                                      controller: _productsScroll,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      children: [
                                        SizedBox(height: screenHeight * .2),
                                        Center(
                                          child: CircularProgressIndicator(color: AppColors.primary),
                                        ),
                                      ],
                                    );
                                  }

                                  if (favController.error != null && favs.isEmpty) {
                                    return ListView(
                                      controller: _productsScroll,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      children: [
                                        SizedBox(height: screenHeight * .2),
                                        Center(
                                          child: Text(
                                            favController.error!,
                                            style: const TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    );
                                  }

                                  if (favs.isEmpty) {
                                    return ListView(
                                      controller: _productsScroll,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      children: const [
                                        SizedBox(height: 120),
                                        Center(child: Text('No favourite products')),
                                      ],
                                    );
                                  }

                                  return ListView.builder(
                                    controller: _productsScroll,
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    padding: EdgeInsets.only(bottom: screenHeight * 0.06),
                                    itemCount: favs.length,
                                    itemBuilder: (context, index) {
                                      final fav = favs[index];
                                      return FavouriteProductCard(
                                        screenWidth: screenWidth,
                                        screenHeight: screenHeight,
                                        favouriteProduct: fav,
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),

                        // =======================
                        // ✅ Stores Tab + Refresh
                        // =======================
                        AnimatedBuilder(
                          animation: favController,
                          builder: (context, _) {
                            final vendors = favController.favoriteVendors;

                            return RefreshIndicator(
                              color: AppColors.primary,
                              onRefresh: () async {
                                await favController.refreshVendors(); // stores only
                              },
                              child: Builder(
                                builder: (_) {
                                  if (favController.isLoadingVendors && vendors.isEmpty) {
                                    return ListView(
                                      controller: _storesScroll,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      children: [
                                        SizedBox(height: screenHeight * .2),
                                        Center(
                                          child: CircularProgressIndicator(color: AppColors.primary),
                                        ),
                                      ],
                                    );
                                  }

                                  if (favController.vendorsError != null && vendors.isEmpty) {
                                    return ListView(
                                      controller: _storesScroll,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      children: [
                                        SizedBox(height: screenHeight * .2),
                                        Center(
                                          child: Text(
                                            favController.vendorsError!,
                                            style: const TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    );
                                  }

                                  if (vendors.isEmpty) {
                                    return ListView(
                                      controller: _storesScroll,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      children: const [
                                        SizedBox(height: 120),
                                        Center(child: Text('No favourite stores')),
                                      ],
                                    );
                                  }

                                  return ListView.builder(
                                    controller: _storesScroll,
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount: vendors.length,
                                    itemBuilder: (context, index) {
                                      final favVendor = vendors[index];
                                      final supplier = favVendor.supplier;

                                      if (supplier == null) return const SizedBox.shrink();

                                      log('${supplier.rating ?? 0}  ${supplier.arName} ${supplier.enName}');

                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SupplierDetails(supplier: supplier),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding:  EdgeInsets.only(bottom: screenHeight*.02),
                                          child: BuildFullCardSupplier(
                                            screenHeight,
                                            screenWidth,
                                            supplier,
                                            supplier.isVerified,
                                            fromFavouritesScreen: false, // ✅ Changed to false to allow toggle
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
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
        ],
      ),
    );
  }
}
