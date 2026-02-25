import 'dart:async';

import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/services/dio_service.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../home/domain/models/product_model.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../../home/presentation/widgets/main_screen_widgets/custom_search_bar.dart';
import '../../../home/presentation/widgets/main_screen_widgets/products/product_card.dart';

class BundleProductsScreen extends StatefulWidget {
  const BundleProductsScreen({super.key});

  @override
  State<BundleProductsScreen> createState() => _BundleProductsScreenState();
}

class _BundleProductsScreenState extends State<BundleProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _searchBarKey = GlobalKey();

  final ScrollController _scrollController = ScrollController();

  Timer? _debounceTimer;

  List<ClientProduct> _products = [];
  bool _isLoading = false;
  bool _hasReachedMax = false;
  int _currentPage = 1;
  String? _error;

  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchBundleProducts(isRefresh: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  // ✅ نفس TabBarFirstPage: لما نقرب من آخر الصفحة
  void _scrollListener() {
    if (!_scrollController.hasClients) return;

    final pos = _scrollController.position.pixels;
    final max = _scrollController.position.maxScrollExtent;

    if (pos >= max - 250 && !_isLoading && !_hasReachedMax) {
      _fetchBundleProducts();
    }
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
    _fetchBundleProducts(isRefresh: true);
  }

  void _clearSearch() {
    FocusScope.of(context).unfocus();
    setState(() => _searchController.clear());
    _fetchBundleProducts(isRefresh: true);
  }

  Future<void> _fetchBundleProducts({bool isRefresh = false}) async {
    if (_isLoading) return;

    if (isRefresh) {
      setState(() {
        _currentPage = 1;
        _hasReachedMax = false;
        _products.clear();
        _error = null;
      });
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      debugPrint('🌐 Fetching bundle products - Page: $_currentPage, IsBundle: true');

      final response = await DioService.dio.get(
        '$base_url/v1/client/products',
        queryParameters: {
          'PageSize': _pageSize,
          'PageIndex': _currentPage,
          'IsBundle': true,
          if (_searchController.text.trim().isNotEmpty)
            'SearchTerm': _searchController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        final productsResponse = ProductsResponse(
          pageIndex: responseData['pageIndex'] ?? 1,
          pageSize: responseData['pageSize'] ?? 10,
          totalCount: responseData['totalCount'] ?? 0,
          totalPages: responseData['totalPages'] ?? 0,
          hasPreviousPage: responseData['hasPreviousPage'] ?? false,
          hasNextPage: responseData['hasNextPage'] ?? false,
          items: (responseData['items'] as List<dynamic>?)
              ?.map((item) => ClientProduct.fromJson(item as Map<String, dynamic>))
              .toList() ??
              [],
        );

        setState(() {
          _products.addAll(productsResponse.items);
          _hasReachedMax = !productsResponse.hasNextPage;
          _currentPage++;
          _isLoading = false;
        });

        debugPrint('✅ Bundle products loaded: ${_products.length} items, HasNext: ${!_hasReachedMax}');
      } else {
        throw Exception('Failed to load bundle products (status: ${response.statusCode})');
      }
    } catch (e) {
      debugPrint('❌ Error fetching bundle products: $e');
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  // ✅ زرار Load More (زي TabBarFirstPage)
  void _loadMoreProducts() {
    if (_isLoading || _hasReachedMax) return;
    _fetchBundleProducts();
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
            title: AppLocalizations.of(context)!.allBundles,
            is_returned: true,
          ),

          Positioned.fill(
            top: screenHeight * 0.15,
            bottom: screenHeight * 0.05,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.03,
                bottom: screenHeight * 0.09,
              ),

              // ✅ Refresh + CustomScrollView (زي TabBarFirstPage)
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => _fetchBundleProducts(isRefresh: true),
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    // Search
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: CustomSearchBar(
                                    key: _searchBarKey,
                                    controller: _searchController,
                                    height: screenHeight,
                                    width: screenWidth,
                                    fromSupplierDetail: true,
                                    hideFliterForNow: true,
                                    onChanged: _onSearchChanged,
                                    onClear: _clearSearch,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),

                    // حالات أول تحميل / Error / Empty
                    if (_isLoading && _products.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                      )
                    else if (_error != null && _products.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Failed to load bundles',
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    else if (_products.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.noBundlesFound,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                              ),
                            ),
                          ),
                        )
                      else
                      // Grid
                        SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                final product = _products[index];
                                return ProductCard(
                                  screenWidth: screenWidth,
                                  screenHeight: screenHeight,
                                  product: product,
                                  icon: 'assets/images/home/main_page/product.jpg',
                                );
                              },
                              childCount: _products.length,
                            ),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: screenWidth * 0.03,
                              mainAxisSpacing: screenWidth * 0.03,
                              childAspectRatio: 0.49,
                            ),
                          ),
                        ),

                    // Loader + Load More Button (زي TabBarFirstPage)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * .015,
                          bottom: screenHeight * .03,
                        ),
                        child: Column(
                          children: [
                            if (_isLoading && _products.isNotEmpty)
                              const Center(
                                child: CircularProgressIndicator(color: AppColors.primary),
                              ),

                            if (!_hasReachedMax && !_isLoading && _products.isNotEmpty)
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}