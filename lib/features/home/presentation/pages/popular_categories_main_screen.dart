import 'package:flutter/material.dart';
import 'dart:async';
import 'package:iconify_flutter/icons/game_icons.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:newwwwwwww/features/home/presentation/pages/popular_category_screen.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/supplier_full_card.dart';
import '../../../../../core/theme/colors.dart';
import '../../domain/models/product_categories_models/product_category_model.dart';
import '../widgets/background_home_Appbar.dart';
import '../widgets/build_ForegroundAppBarHome.dart';
import '../widgets/main_screen_widgets/category_card.dart';
import '../widgets/main_screen_widgets/custom_search_bar.dart';
import '../widgets/main_screen_widgets/suppliers/build_filter_button.dart';
import '../widgets/main_screen_widgets/suppliers/filter_overlay.dart';
import '../widgets/main_screen_widgets/suppliers/tapBarfirstPage.dart';

class PopularCategoriesMainScreen extends StatefulWidget {
  final List<ProductCategory> categories;   // 👈 الليست اللي جاية من المين

  const PopularCategoriesMainScreen({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  State<PopularCategoriesMainScreen> createState() =>
      _PopularCategoriesMainScreenState();
}

class _PopularCategoriesMainScreenState extends State<PopularCategoriesMainScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  List<ProductCategory> _filteredCategories = [];
  
  // final List<Map<String, dynamic>> categories = [
  //   {
  //     'type': 'svg',
  //     'icon': 'assets/images/home/main_page/bottle.svg',
  //     'title': 'Bottles',
  //   },
  //   {
  //     'type': 'iconify',
  //     'icon': GameIcons.water_gallon,
  //     'title': 'Gallons',
  //   },
  //   {
  //     'type': 'icon',
  //     'icon': Mdi.coupon_outline, // بديل لـ coupon_outline لو بتحبيه
  //     'title': 'Coupons',
  //   },
  //   {
  //     'type': 'svg',
  //     'icon':'assets/images/home/main_page/ph.svg',
  //     'title': 'Alkaline',
  //   },
  //   {
  //     'type': 'svg',
  //     'icon': 'assets/images/home/main_page/bottle.svg',
  //     'title': 'Small Bottles',
  //   },
  //   {
  //     'type': 'svg',
  //     'icon': 'assets/images/home/main_page/dispenser.svg',
  //     'title': 'Dispenser',
  //   },
  // ];
  final GlobalKey _searchBarKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  final Set<String> selectedFilters = {};
  final Set<String> tags = {'small bottles', 'gallons', 'under QAE 50', 'spring water'};

  @override
  void initState() {
    super.initState();
    _filteredCategories = widget.categories;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }
  List<Widget> generateTags(double width, double height) {
    return tags.map((tag) => getChip(tag, width, height)).toList();
  }

  Widget getChip(String name, double width, double height) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * .015,
        vertical: height * .008,
      ),
      decoration: BoxDecoration(
        color: AppColors.greyDarktextIntExtFieldAndIconsHome,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: width * .031,
              fontWeight: FontWeight.w600,
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                tags.remove(name);
              });
            },
            child: Padding(
              padding: EdgeInsets.only(right: width * .01, left: width * .02),
              child: Icon(Icons.close, color: AppColors.whiteColor, size: width * .042),
            ),
          )
        ],
      ),
    );
  }

  void _toggleFilterMenu() {
    if (_overlayEntry == null) {
      _showFilterMenu();
    } else {
      _hideFilterMenu();
    }
  }

  void _showFilterMenu() {
    final renderBox = _searchBarKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = buildFilterOverlay(
      context: context,
      offset: offset,
      width: size.width,
      height: size.height,
      selectedFilters: selectedFilters,
      onClose: _hideFilterMenu,
      onChanged: () {
        // Rebuild parent to reflect tag visibility when filters change
        setState(() {});
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideFilterMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _filterCategories(query.trim());
    });
  }

  void _filterCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = widget.categories;
      } else {
        _filteredCategories = widget.categories
            .where((category) {
              final categoryName = _getCategoryName(category);
              return categoryName.toLowerCase().contains(query.toLowerCase());
            })
            .toList();
      }
    });
  }

  void _clearSearch() {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();
    
    setState(() {
      _searchController.clear();
      _filteredCategories = widget.categories;
    });
  }

  // Helper method to safely extract category name
  String _getCategoryName(ProductCategory category) {
    try {
      if (category.enName is String) {
        return category.enName;
      } else if (category.enName is Map) {
        final nameMap = category.enName as Map;
        return nameMap['enName']?.toString() ?? 
               nameMap['arName']?.toString() ??
               category.enName.toString();
      } else {
        return category.enName.toString();
      }
    } catch (e) {
      return category.enName.toString();
    }
  }


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final topPadding = mediaQuery.padding.top;

    return Scaffold(
      extendBody: true,
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
            title: 'Popular Categories',
            is_returned: true,
          ),
          Positioned.fill(
            top: topPadding + screenHeight * .1,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * .03,
                bottom: screenHeight * .09,
              ),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomSearchBar(
                            key: _searchBarKey,
                            controller: _searchController,
                            height: screenHeight,
                            width: screenWidth,
                            fromSupplierDetail: true,
                            hideFliterForNow: true,
                            onChanged: _onSearchChanged,
                            onClear: _clearSearch,
                          ),
                          // BuildFilterButton(
                          //   screenWidth,
                          //   screenHeight,
                          //   _toggleFilterMenu,
                          // ),
                        ],
                      ),

                      // الفلاتر المختارة (Tags)
                      if (selectedFilters.isNotEmpty)
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: generateTags(screenWidth, screenHeight),
                        ),

                      // الـ Grid بتاعت الـ Categories
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: screenWidth * 0.008,
                          mainAxisSpacing: screenWidth * 0.008,
                          childAspectRatio: 1.1,
                        ),
                        itemCount: _filteredCategories.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => PopularCategoryScreen(category:_filteredCategories[index])));
                            },

                            child: CategoryCard(
                              fromMainPupularCategoriesScreen: true,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              icon:'assets/images/home/main_page/bottle.svg', //widget.categories[index]['icon'],
                              title: _getCategoryName(_filteredCategories[index]),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: screenHeight*.08,)
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
