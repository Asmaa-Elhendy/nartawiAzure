import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:newwwwwwww/features/cart/presentation/widgets/delivery_address_cart.dart';
import 'package:newwwwwwww/features/cart/presentation/widgets/outline_buttons.dart';
import 'package:newwwwwwww/features/favourites/domain/models/favorite_product.dart';
import 'package:newwwwwwww/features/orders/domain/models/order_model.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/order_summary_card.dart';
import 'package:newwwwwwww/features/home/domain/models/product_model.dart';
import '../../../../core/services/dio_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/utils/components/confirmation_alert.dart';
import '../../../../injection_container.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/bloc/login_bloc.dart';
import '../../../favourites/pesentation/widgets/favourite_product_card.dart';
import '../../../home/presentation/widgets/General_alert.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import '../bloc/cached_cart_bloc.dart';
import '../../../home/presentation/bloc/cart/cart_state.dart';
import '../../../home/presentation/bloc/cart/cart_event.dart';
import '../../../profile/domain/models/client_address.dart';
import '../../../orders/presentation/provider/order_controller.dart';
import '../../../orders/domain/models/create_order_req.dart';
import '../widgets/cart_store_card.dart';
import '../widgets/payment_method_alert.dart';

// Helper function to create ClientOrder from cart items
ClientOrder _createOrderFromCart(List<Object> cartItems, Map<String, int>? productQuantities,BuildContext context) {
  double subtotal = 0.0;
  final quantities = productQuantities ?? {};
  List<Object> itemsWithQuantities = [];
  
  // Calculate subtotal from cart items with quantities and create items with quantities
  for (final item in cartItems) {
    String productKey;
    double price = 0.0;
    String name = AppLocalizations.of(context)!.unknownProduct;
    
    if (item is Map<String, dynamic>) {
      // Handle new product data structure
      price = (item['price'] as num?)?.toDouble() ?? 0.0;
      name = (item['name'] ?? item['enName'] ?? item['arName'] ?? AppLocalizations.of(context)!.unknownProduct).toString();
      productKey = 'product_${item['id'] ?? 0}';
    } else if (item.toString().contains('Product')) {
      // Handle old string format for backward compatibility
      price = 25.0; // Default price per item
      name = item.toString();
      productKey = item.toString();
    } else {
      continue;
    }
    
    final quantity = quantities[productKey] ?? 1;
    subtotal += price * quantity;
    
    // Create item with quantity for OrderSummaryCard
    if (item is Map<String, dynamic>) {
      final itemWithQuantity = Map<String, dynamic>.from(item);
      itemWithQuantity['quantity'] = quantity;
      itemsWithQuantities.add(itemWithQuantity);
    } else {
      // For string items, create a map with quantity
      itemsWithQuantities.add({
        'name': name,
        'price': price,
        'quantity': quantity,
      });
    }
  }
  
  // Calculate delivery cost (you can make this dynamic)
  final deliveryCost = 10.0;
  
  // Calculate total
  final total = subtotal + deliveryCost;
  
  return ClientOrder(
    id: 0,
    subTotal: subtotal,
    discount: 0.0,
    deliveryCost: deliveryCost,
    total: total,
    isPaid: false,
    items: itemsWithQuantities,
  );
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ClientAddress? _selectedAddress;
  final OrdersController _orderController = OrdersController(dio: sl());

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
    

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _clearCart(double width) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.clearCart,style: TextStyle(fontSize: width*.036,    fontWeight: FontWeight.w600,
        ),),
        content: Text(AppLocalizations.of(context)!.removeAllItemsFromCart,style: TextStyle(  color: Colors.grey[600],),),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(context)!.cancel,style: TextStyle(color: AppColors.primary),),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              AppLocalizations.of(context)!.clearAll,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {





          context.read<CachedCartBloc>().add(CartClear());

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.cartClearedSuccessfully),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );

      } catch (e) {
        if (Navigator.canPop(context)) Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.failedToClearCart}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _createOrderWithPayment(int paymentMethod) async {
    final cartState = context.read<CachedCartBloc>().state;

    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseSelectAddress),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Check if all products are from the same supplier
    String? firstSupplierId;
    for (final item in cartState.cartProducts) {
      String currentSupplierId = '0';
      
      if (item is Map<String, dynamic>) {
        if (item['product'] is Map<String, dynamic>) {
          currentSupplierId = item['product']['SupplierId']?.toString() ?? '0';
        } else {
          currentSupplierId = item['SupplierId']?.toString() ?? '0';
        }
      } else if (item is ClientProduct) {
        currentSupplierId = item.supplierId.toString();
      }
      
      if (firstSupplierId == null) {
        firstSupplierId = currentSupplierId;
      } else if (firstSupplierId != currentSupplierId) {
       // Different supplier found
       //  ScaffoldMessenger.of(context).showSnackBar(
       //    const SnackBar(
       //      content: Text('All order Products Must be from Same Supplier'),
       //      backgroundColor: Colors.red,
       //      behavior: SnackBarBehavior.floating,//k
       //    ),
       //  );
        showDialog(
          context: context,
          builder: (ctx) => GeneralAlert(
            width: MediaQuery.of(context).size.width,
            message: AppLocalizations.of(context)!.allProductsSameSupplier,
          ),
        );

        return;
      }
    }

    // Build items
    final List<CreateOrderItemRequest> orderItems = [];
    for (final item in cartState.cartProducts) {
      if (item is Map<String, dynamic>) {
        final productId = item['id'] as int? ?? 0;
        final quantity = cartState.productQuantities?['product_$productId'] ?? 1;

        orderItems.add(CreateOrderItemRequest(
          productId: productId,
          quantity: quantity,
          notes: '', // أو "string" لو لازم
        ));
      }
    }

   final orderRequest = CreateOrderRequest(
  items: orderItems,
  deliveryAddressId: _selectedAddress!.id!,
  couponId: 0,
  notes: 'string',
  terminalId: 0,
);

debugPrint('📦 CREATE ORDER PAYLOAD => ${orderRequest.toJson()}');


    debugPrint('📦 CREATE ORDER PAYLOAD => ${orderRequest.toJson()}');

    try {
      final createdOrder =
      await _orderController.createOrder(request: orderRequest);

      // حتى لو API بيرجع null مع 204، اعتبرها نجاح
      if ((_orderController.error == null) &&
          (createdOrder != null || true)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.orderCreatedSuccessfully),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        context.read<CachedCartBloc>().add(CartClear());

        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/orders');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_orderController.error ?? AppLocalizations.of(context)!.failedToCreateOrder),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on DioException catch (e) {
      debugPrint('🌐 DioException: ${e.response?.statusCode}');
      debugPrint('🌐 Response data: ${e.response?.data}');

      final data = e.response?.data;
      final msg = (data is Map)
          ? (data['message'] ?? data['title'] ?? data['error'] ?? AppLocalizations.of(context)!.failedToCreateOrder).toString()
          : AppLocalizations.of(context)!.failedToCreateOrder;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      debugPrint('💥 Unexpected error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.failedToCreateOrder),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String? imageUrl = null;
  List<String> products = [
    'assets/images/home/main_page/product.jpg',
    'assets/images/home/main_page/product.jpg',
    'assets/images/home/main_page/product.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        // 🔥 يخلي الجسم يبدأ من أعلى الشاشة خلف الـ AppBar
        backgroundColor: Colors.transparent,
        // في حالة الصورة في الخلفية
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
              title: AppLocalizations.of(context)!.yourCart,
              is_returned: true,
              disabledCart: 'cart',
            ),
            Positioned.fill(
              top: MediaQuery.of(context).padding.top + screenHeight * .1,
              child: Padding(
                padding: EdgeInsets.only(
             //     top: screenHeight * .03,//04 handle design shimaa
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * .06,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              BlocBuilder<CachedCartBloc, CartState>(
                                builder: (context, cartState) {
                                  // Only show CartStoreCard if there are products in cart
                                  if (cartState.cartProducts.isEmpty) {
                                    return SizedBox.shrink();
                                  }

                                  // Extract supplier information from first cart product
                                  String? supplierId;
                                  String? supplierName;
                                  double? supplierRating;
                                  String? supplierLogo;

                                  if (cartState.cartProducts.isNotEmpty) {
                                    final firstProduct = cartState.cartProducts.first;
                                    if (firstProduct is Map<String, dynamic>) {
                                      if (firstProduct['product'] is Map<String, dynamic>) {
                                        // Supplier info is in nested product object
                                        supplierId = firstProduct['product']['SupplierId']?.toString();
                                        supplierName = firstProduct['product']['SupplierName']?.toString();
                                        supplierRating = (firstProduct['product']['SupplierRating'] as num?)?.toDouble();
                                        supplierLogo = firstProduct['product']['SupplierLogo']?.toString();
                                      } else {
                                        // Try to get from top level
                                        supplierId = firstProduct['SupplierId']?.toString();
                                        supplierName = firstProduct['SupplierName']?.toString();
                                        supplierRating = (firstProduct['SupplierRating'] as num?)?.toDouble();
                                        supplierLogo = firstProduct['SupplierLogo']?.toString();
                                      }
                                    } else if (firstProduct is ClientProduct) {
                                      supplierId = firstProduct.supplierId.toString();
                                      supplierName = firstProduct.supplierName;
                                      supplierRating = firstProduct.supplierRating;
                                      supplierLogo = firstProduct.supplierLogo;
                                    }
                                  }

                                  return CartStoreCard(
                                    context,
                                    screenWidth,
                                    screenHeight,
                                    supplierId: supplierId,
                                    supplierName: supplierName,
                                    supplierRating: supplierRating,
                                    supplierLogo: supplierLogo,
                                  );
                                },
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * .02,
                                ),
                                child: BlocBuilder<CachedCartBloc, CartState>(
                                  builder: (context, cartState) {
                                    if (cartState.cartProducts.isEmpty) {
                                      return Center(
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.shopping_cart_outlined,
                                              size: screenWidth * .1,
                                              color: Colors.grey[400],
                                            ),
                                            SizedBox(height: screenHeight * .02),
                                            Text(
                                              'Your cart is empty',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: screenWidth * .04,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }

                                    return Column(
                                      children: cartState.cartProducts
                                          .map((product) {
                                            // Check if product is Map with real data
                                            if (product is Map<String, dynamic>) {
                                              return Padding(
                                                padding: EdgeInsets.only(bottom: screenHeight * .02),
                                                child: FavouriteProductCard(
                                                  screenWidth: screenWidth,
                                                  screenHeight: screenHeight,
                                                  favouriteProduct: FavoriteProduct(
                                                    id: product['id'] ?? 0,
                                                    productVsId: product['id'] ?? 0,
                                                    createdAt: DateTime.now(),
                                                    product: FavoriteProductItem(
                                                      id: product['id'] ?? 0,
                                                      vsId: product['id'] ?? 0,
                                                      enName: product['name'] ?? 'Product',
                                                      arName: product['name'] ?? 'منتج',
                                                      isActive: true,
                                                      isCurrent: true,
                                                      price: (product['price'] as num?)?.toDouble() ?? 0.0,
                                                      categoryId: 0,
                                                      categoryName: 'General',
                                                      images: [],
                                                      totalAvailableQuantity: 0,
                                                      inventory: [],
                                                      supplierId: int.tryParse(product['SupplierId']?.toString() ?? '0') ?? 0,
                                                      supplierName: product['SupplierName']?.toString() ?? 'Unknown Supplier',
                                                     
                                                    ),
                                                  ),
                                                  fromCartScreen: true,
                                                ),
                                              );
                                            } else if (product is ClientProduct) {
                                              return Padding(
                                                padding: EdgeInsets.only(bottom: screenHeight * .02),
                                                child: FavouriteProductCard(
                                                  screenWidth: screenWidth,
                                                  screenHeight: screenHeight,
                                                  favouriteProduct: FavoriteProduct(
                                                    id: product.id,
                                                    productVsId: product.vsId,
                                                    createdAt: DateTime.now(),
                                                    product: FavoriteProductItem(
                                                      supplierId: product.supplierId,
                                                      supplierLogo: product.supplierLogo,
                                                      supplierName: product.supplierName,
                                                      id: product.id,
                                                      vsId: product.vsId,
                                                      enName: product.enName,
                                                      arName: product.arName,
                                                      isActive: product.isActive,
                                                      isCurrent: product.isCurrent,
                                                      price: product.price,
                                                      categoryId: product.categoryId,
                                                      categoryName: product.categoryName,
                                                      images: product.images,
                                                      totalAvailableQuantity: product.totalAvailableQuantity,
                                                      inventory: product.inventory,
                                                   
                                                    ),
                                                  ),
                                                  fromCartScreen: true,
                                                ),
                                              );
                                            } else {
                                              // Handle old string format for backward compatibility
                                              return Padding(
                                                padding: EdgeInsets.only(bottom: screenHeight * .02),
                                                child: FavouriteProductCard(
                                                  screenWidth: screenWidth,//kkjنjjت
                                                  screenHeight: screenHeight,
                                                  favouriteProduct: FavoriteProduct(
                                                    id: 0,
                                                    productVsId: 0,
                                                    createdAt: DateTime.now(),
                                                    product: FavoriteProductItem(
                                                      id: 0,
                                                      vsId: 0,
                                                      enName: product.toString(),
                                                      arName: product.toString(),
                                                      isActive: false,
                                                      isCurrent: false,
                                                      price: 0,
                                                      categoryId: 0,
                                                      categoryName: 'Unknown',
                                                      images: [],
                                                      totalAvailableQuantity: 0,
                                                      inventory: [],
                                                      supplierId: 0,
                                                      supplierName: 'Unknown Supplier',
                                                  
                                                    ),
                                                  ),
                                                  fromCartScreen: true,
                                                ),
                                              );
                                            }
                                          })
                                          .toList(),
                                    );
                                  },
                                ),
                                //                   FavouriteProductCard(screenWidth: screenWidth,screenHeight:  screenHeight,
                                //                     icon: 'assets/images/home/main_page/product.jpg',fromCartScreen:true
                                //                   ),
                                //                   FavouriteProductCard(screenWidth: screenWidth,screenHeight:  screenHeight,
                                //                       icon: 'assets/images/home/main_page/product.jpg',fromCartScreen:true
                                //                   ), FavouriteProductCard(screenWidth: screenWidth,screenHeight:  screenHeight,
                                //                       icon: 'assets/images/home/main_page/product.jpg',fromCartScreen:true
                                //                   ),
                                //
                                //
                                //                 ],),
                                //             ),
                              ),
                              BlocBuilder<CachedCartBloc, CartState>(
                                builder: (context, cartState) {
                                  // Only show OrderSummaryCard if there are products in cart
                                  if (cartState.cartProducts.isEmpty) {
                                    return SizedBox.shrink();
                                  }
                                  return OrderSummaryCard(context,
                                    screenWidth, 
                                    screenHeight, 
                                    _createOrderFromCart(cartState.cartProducts, cartState.productQuantities,context)
                                  );
                                },
                              ),
                              OrderDeliveryCartWidget(
                                onAddressSelected: (address) {
                                  setState(() {
                                    _selectedAddress = address;
                                  });
                                },
                              ),
                              BuildInfoAndAddToCartButton(
                                screenWidth,
                                screenHeight,
                                AppLocalizations.of(context)!.proceedToCheckout,
                                false,
                                () {
                                        
                                  // Print all supplier IDs from cart products
                                  final cartState = context.read<CachedCartBloc>().state;
                                  print('🛒 Cart Products Supplier IDs:');
                                  for (final product in cartState.cartProducts) {
                                    if (product is Map<String, dynamic>) {
                                      // Check if supplier info is in nested 'product' object or at top level
                                      String supplierId = '0';
                                      double? supplierRating;
                                      String? supplierLogo;
                                      String productName = product['name']?.toString() ?? 'Unknown Product';
                                      
                                      if (product['product'] is Map<String, dynamic>) {
                                        // Supplier info is in nested product object
                                        supplierId = product['product']['SupplierId']?.toString() ?? '0';
                                        supplierRating = (product['product']['SupplierRating'] as num?)?.toDouble();
                                        supplierLogo = product['product']['SupplierLogo']?.toString();
                                      } else {
                                        // Try to get from top level (fallback)
                                        supplierId = product['SupplierId']?.toString() ?? '0';
                                        supplierRating = (product['SupplierRating'] as num?)?.toDouble();
                                        supplierLogo = product['SupplierLogo']?.toString();
                                      }
                                      
                                      print('  - Product: $productName, Supplier ID: $supplierId, Rating: ${supplierRating ?? 'N/A'}, Logo: ${supplierLogo ?? 'N/A'}');
                                    } else if (product is ClientProduct) {
                                      print('  - Product: ${product.enName}, Supplier ID: ${product.supplierId}, Rating: ${product.supplierRating ?? 'N/A'}, Logo: ${product.supplierLogo ?? 'N/A'}');
                                    }
                                  }
                                  // Check if there's a selected or default address before proceeding to payment
                                  if (_selectedAddress == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(AppLocalizations.of(context)!.pleaseSelectAddress),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  
                                  // Show payment method dialog
                                  print('💳 Opening payment method dialog...');
                                  showDialog<int>(
                                    context: context,
                                    builder: (ctx) => PaymentMethodAlert(),
                                  ).then((paymentMethod) {
                                    print('🔔 Payment method callback received: $paymentMethod');
                                    if (paymentMethod != null) {
                                      // After payment method is selected, create the order
                                      _createOrderWithPayment(paymentMethod);
                                    }
                                  });
                                },
                              ),//k
                              RowOutlineButtons(
                                context,
                                screenWidth,
                                screenHeight,
                                  AppLocalizations.of(context)!.continueShopping,
                                  AppLocalizations.of(context)!.clearCart,
                                () {
                                  Navigator.pushNamed(context, '/main');
                                },
                                () {
                                  _clearCart(screenWidth);
                                },
                              ),
                              SizedBox(height: screenHeight * .04),
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
      ),
    );
  }
}
