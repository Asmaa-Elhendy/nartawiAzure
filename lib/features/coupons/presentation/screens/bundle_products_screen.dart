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
  List<ClientProduct> _products = [];
  bool _isLoading = false;
  bool _hasReachedMax = false;
  int _currentPage = 1;
  String? _error;
  final int _pageSize = 10;
  final GlobalKey _searchBarKey = GlobalKey();
  Timer? _debounceTimer;
  @override
  void initState() {
    super.initState();
    _fetchBundleProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
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

  Future<void> _fetchBundleProducts({bool isRefresh = false}) async {
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
          'PageSize': _pageSize.toString(),
          'PageIndex': _currentPage.toString(),
          'IsBundle': 'true',
          if (_searchController.text.trim().isNotEmpty) 
            'SearchTerm': _searchController.text.trim() 
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        
        // Create ProductsResponse manually since we can't import it
        final productsResponse = ProductsResponse(
          pageIndex: responseData['pageIndex'] ?? 1,
          pageSize: responseData['pageSize'] ?? 10,
          totalCount: responseData['totalCount'] ?? 0,
          totalPages: responseData['totalPages'] ?? 0,
          hasPreviousPage: responseData['hasPreviousPage'] ?? false,
          hasNextPage: responseData['hasNextPage'] ?? false,
          items: (responseData['items'] as List<dynamic>?)
              ?.map((item) => ClientProduct.fromJson(item as Map<String, dynamic>))
              .toList() ?? [],
        );

        setState(() {
          if (isRefresh) {
            _products = productsResponse.items;
          } else {
            _products.addAll(productsResponse.items);
          }
          _hasReachedMax = !productsResponse.hasNextPage;
          _currentPage++;
          _isLoading = false;
        });

        debugPrint('✅ Bundle products loaded: ${_products.length} items, HasNext: ${!_hasReachedMax}');
      } else {
        throw Exception('Failed to load bundle products');
      }
    } catch (e) {
      debugPrint('❌ Error fetching bundle products: $e');
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  void _performSearch(String query) {
    setState(() {
      _currentPage = 1;
      _hasReachedMax = false;
    });
    _fetchBundleProducts(isRefresh: true);
  }

  void _clearSearch() {
    FocusScope.of(context).unfocus();
    setState(() {
      _searchController.clear();
    });
    _fetchBundleProducts(isRefresh: true);
  }

  Future<void> _loadNextPage() async {
    if (!_isLoading && !_hasReachedMax) {
      await _fetchBundleProducts();
    }
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
          // Background appbar (reuse existing component)
         buildBackgroundAppbar(screenWidth),
              BuildForegroundappbarhome(
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                title:
                    AppLocalizations.of(context)!.allBundles,
                is_returned: true,
              ),
          // Main content
          Positioned.fill(
            top: screenHeight * 0.15,
            bottom: screenHeight * 0.05,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.03,
                bottom: screenHeight * 0.09,
              ),
              child: Column(
                children: [
                  // Search bar
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

                  const SizedBox(height: 16),
                  // Products list
                  Expanded(
                    child: _buildProductsList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    if (_isLoading && _products.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _error!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_products.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noBundlesFound,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.greyDarktextIntExtFieldAndIconsHome,
          ),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification && !_hasReachedMax) {
          _loadNextPage();
        }
        return false;
      },
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => _fetchBundleProducts(isRefresh: true),
        child: GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.06),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: MediaQuery.of(context).size.width * 0.03,
            mainAxisSpacing: MediaQuery.of(context).size.width * 0.03,
            childAspectRatio: 0.49,
          ),
          itemCount: _products.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _products.length && _isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            final product = _products[index];
            return ProductCard(
              screenWidth: MediaQuery.of(context).size.width,
              screenHeight: MediaQuery.of(context).size.height,
              product: product,
              icon: 'assets/images/home/main_page/product.jpg',
            );
          },
        ),
      ),
    );
  }
}

