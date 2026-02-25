import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:newwwwwwww/core/theme/colors.dart';
import 'package:newwwwwwww/features/home/domain/models/product_categories_models/product_category_model.dart';
import 'package:newwwwwwww/features/home/domain/models/supplier_model.dart';

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


  TabBarFirstPage({
    super.key,
    required this.category,
    required this.supplier,
    this.fromAllProducts = false,

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
  final ScrollController _scrollController = ScrollController();

  bool _isLoadingMore = false;
  late TextEditingController _searchController;
  Timer? _debounceTimer;
  bool _isSearching = false;

  // ✅ Cache علشان حتى لو البلوك عمل Loading نفضل عارضين الجريد
  List<dynamic> _cachedProducts = [];
  bool _cachedHasReachedMax = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      log('🔍 ScrollController attached: ${_scrollController.hasClients}');
    });

    // أول تحميل
    context.read<ProductsBloc>().add(
      FetchProducts(
        categoryId: widget.category?.id,
        supplierId: widget.supplier?.id,

        executeClear: true,
      ),
    );
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;

    final pos = _scrollController.position.pixels;
    final max = _scrollController.position.maxScrollExtent;

    if (pos >= max - 250 && !_isLoadingMore && !_cachedHasReachedMax) {
      _loadMoreProducts();
    }
  }

  void _loadMoreProducts() {
    if (_isLoadingMore || _cachedHasReachedMax) return;

    setState(() => _isLoadingMore = true);

    context.read<ProductsBloc>().loadNextPage(
      categoryId: widget.category?.id,
      supplierId: widget.supplier?.id,
      searchTerm: _isSearching ? _searchController.text.trim() : null,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    _hideFilterMenu();
    _scrollController.dispose();
    super.dispose();
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
      onChanged: () => setState(() {}),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideFilterMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final q = query.trim();
      if (q.isEmpty) {
        _clearSearch();
      } else {
        _performSearch(q);
      }
    });
  }

  void _performSearch(String query) {
    setState(() => _isSearching = true);

    context.read<ProductsBloc>().add(
      FetchProducts(
        categoryId: widget.category?.id,
        supplierId: widget.supplier?.id,

        searchTerm: query,
        executeClear: true,
      ),
    );
  }

  void _clearSearch() {
    FocusScope.of(context).unfocus();

    setState(() {
      _isSearching = false;
      _searchController.clear();
    });

    context.read<ProductsBloc>().add(
      FetchProducts(
        categoryId: widget.category?.id,
        supplierId: widget.supplier?.id,

        executeClear: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<ProductsBloc, ProductsState>(
      listener: (context, state) {
        if (state is ProductsLoaded) {
          _cachedProducts = state.response.items;
          _cachedHasReachedMax = state.hasReachedMax;

          if (_isLoadingMore) setState(() => _isLoadingMore = false);
        }

        if (state is ProductsError) {
          if (_isLoadingMore) setState(() => _isLoadingMore = false);
        }
      },
      builder: (context, state) {
        // ✅ First load فقط (لو مفيش cache)
        if ((state is ProductsInitial || (state is ProductsLoading && state.isFirstFetch)) &&
            _cachedProducts.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        // ✅ لو Error ومفيش بيانات
        if (state is ProductsError && _cachedProducts.isEmpty) {
          return Center(
            child: Text(
              'Failed to load products: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final products = (state is ProductsLoaded)
            ? state.response.items
            : _cachedProducts;

        final hasReachedMax =
        (state is ProductsLoaded) ? state.hasReachedMax : _cachedHasReachedMax;

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                      ],
                    ),
                    if (widget.fromAllProducts )
                      BuildCompareButton(screenWidth, screenHeight, context),
                    SizedBox(height: screenHeight * 0.01),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return ProductCard(
                      product: products[index],
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      icon: 'assets/images/home/main_page/product.jpg',
                      fromAllProducts:
                      (widget.fromAllProducts ),
                    );
                  },
                  childCount: products.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: screenWidth * .03,
                  mainAxisSpacing: screenWidth * .03,
                  childAspectRatio: 0.49,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(
                  top: screenHeight * .015,
                  bottom: screenHeight * .03,
                ),
                child: Column(
                  children: [
                    if (_isLoadingMore)
                      const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),

                    if (!hasReachedMax && !_isLoadingMore)
                      Center(
                        child: ElevatedButton(
                          onPressed: _loadMoreProducts,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * .08,
                              vertical: screenHeight * .015,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'Load More',
                            style: TextStyle(
                              fontSize: screenWidth * .04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}