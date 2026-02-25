import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:newwwwwwww/core/theme/colors.dart';
import 'package:newwwwwwww/features/home/domain/models/product_categories_models/product_category_model.dart';
import 'package:newwwwwwww/features/home/domain/models/supplier_model.dart';

import '../../../../domain/models/product_model.dart';
import '../../../bloc/products_bloc/products_bloc.dart';
import '../../../bloc/products_bloc/products_event.dart';
import '../../../bloc/products_bloc/products_state.dart';
import '../custom_search_bar.dart';
import '../products/product_card.dart';
import 'build_filter_button.dart';
import 'filter_overlay.dart';

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

class TabBarFirstPage extends StatefulWidget {
  final bool fromAllProducts;
  ProductCategory? category;
  Supplier? supplier;
  final bool? isBundle;
  
  TabBarFirstPage({
    super.key, 
    required this.category,
    required this.supplier,
    this.fromAllProducts = false,
    this.isBundle,
  });

  @override
  State<TabBarFirstPage> createState() => _TabBarFirstPageState();
}

class _TabBarFirstPageState extends State<TabBarFirstPage> {
  final Set<String> selectedFilters = {};
  final Set<String> tags = {
    'small bottles',
    'gallons',
    'under QAR 50',
    'spring water',
  };

  OverlayEntry? _overlayEntry;
  final GlobalKey _searchBarKey = GlobalKey();
  late TextEditingController _searchController;
  Timer? _debounceTimer;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    // أول تحميل للـ products
    context.read<ProductsBloc>().add(
        FetchProducts(
          categoryId: widget.category?.id,//j
          supplierId: widget.supplier?.id,
          isBundle: widget.isBundle,
          executeClear: true, // 👈 مهم
        ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    _hideFilterMenu();
    
    // Note: Removed BLoC refresh from dispose to avoid "deactivated widget" error
    // The refresh is now handled by AllProductScreen and MainScreen lifecycle methods
    
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
              padding: EdgeInsets.only(
                right: width * .01,
                left: width * .02,
              ),
              child: Icon(
                Icons.close,
                color: AppColors.whiteColor,
                size: width * .042,
              ),
            ),
          ),
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
    final renderBox =
    _searchBarKey.currentContext!.findRenderObject() as RenderBox;
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
      if (query.trim().isEmpty) {
        _clearSearch();
      } else {
        _performSearch(query.trim());
      }
    });
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = true;
    });
    
    context.read<ProductsBloc>().add(
      FetchProducts(
        categoryId: widget.category?.id,
        supplierId: widget.supplier?.id,
        isBundle: widget.isBundle,
        searchTerm: query,
        executeClear: true,
      ),
    );
  }

  void _clearSearch() {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();
    
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
    
    // Return to normal products view
    context.read<ProductsBloc>().add(
      FetchProducts(
        categoryId: widget.category?.id,
        supplierId: widget.supplier?.id,
        isBundle: widget.isBundle,
        executeClear: true,
      ),
    );
  }

  /// ⬇ استدعائها من السكروول عشان تجيب الصفحة اللي بعدها
  bool _onScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.pixels >=
        scrollInfo.metrics.maxScrollExtent - 200) {
      final bloc = context.read<ProductsBloc>();
      final state = bloc.state;

      if (state is ProductsLoaded && !state.hasReachedMax) {
        bloc.loadNextPage(
          categoryId: widget.category?.id,
          supplierId: widget.supplier?.id,
          isBundle: widget.isBundle,
        );
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Search + Filter + Tags + Compare
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search + Filter Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomSearchBar(
                        key: _searchBarKey,
                        controller: _searchController,
                        height: screenHeight,
                        width: screenWidth,
                        fromSupplierDetail: true,
                        hideFliterForNow: true,   //hide search filter for now
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

                  // Filter tags
                  // selectedFilters.isNotEmpty
                  //     ? Wrap(
                  //   spacing: 8.0,
                  //   runSpacing: 4.0,
                  //   children: generateTags(screenWidth, screenHeight),
                  // )
                  //     : const SizedBox(),

                  // Compare button لو من صفحة All Products
                  widget.fromAllProducts&&widget.isBundle == false
                      ? BuildCompareButton(
                    screenWidth,
                    screenHeight,
                    context,
                  )
                      : const SizedBox(),
                ],
              ),
            ),

            /// 🔹 Products Grid من الـ Bloc + Load More
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.0,
              ),
              child: BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, state) {
                  // First Load
                  if (state is ProductsInitial ||
                      (state is ProductsLoading && state.isFirstFetch)) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: screenHeight * .02),
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    );
                  }

                  // Errors
                  if (state is ProductsError) {
                    return Center(
                      child: Text(state.message, style: TextStyle(color: Colors.red)),
                    );
                  }

                  // Get latest loaded products
                  ProductsLoaded? loadedState;

                  if (state is ProductsLoaded) {
                    loadedState = state;
                  } else if (state is ProductsLoading) {
                    final blocState = context.read<ProductsBloc>().state;
                    if (blocState is ProductsLoaded) {
                      loadedState = blocState;
                    }
                  }

                  if (loadedState == null) return const SizedBox.shrink();

                  final products = loadedState.response.items;

                  if (products.isEmpty) {
                    return const Center(child: Text("No Products Found"));
                  }

                  return Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: screenWidth * .03,
                          mainAxisSpacing: screenWidth * .03,
                          childAspectRatio: 0.49,
                        ),
                        itemCount: products.length,
                        itemBuilder: (_, index) {
                          return ProductCard(
                            product: products[index],
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            icon: 'assets/images/home/main_page/product.jpg',
                            fromAllProducts: (widget.fromAllProducts&&widget.isBundle == false),
                          );
                        },
                      ),

                      // Loader for pagination
                      if (state is ProductsLoading && !state.isFirstFetch)
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * .015),
                          child: Center(
                            child: CircularProgressIndicator(color: AppColors.primary),
                          ),
                        ),
                    ],
                  );
                },
              )

            ),
          ],
        ),
      ),
    );
  }
}
