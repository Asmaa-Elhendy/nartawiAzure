import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:newwwwwwww/features/cart/presentation/widgets/delivery_address_cart.dart';
import 'package:newwwwwwww/features/cart/presentation/widgets/outline_buttons.dart';
import 'package:newwwwwwww/features/favourites/domain/models/favorite_product.dart';
import 'package:newwwwwwww/features/orders/domain/models/order_model.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/order_summary_card.dart';
import 'package:newwwwwwww/features/home/domain/models/product_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../injection_container.dart';
import '../../../favourites/pesentation/widgets/favourite_product_card.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import '../../../home/presentation/bloc/cart/cart_bloc.dart';
import '../../../home/presentation/bloc/cart/cart_state.dart';
import '../../../home/presentation/bloc/cart/cart_event.dart';
import '../../../profile/domain/models/client_address.dart';
import '../../../orders/presentation/provider/order_controller.dart';
import '../../../orders/domain/models/create_order_req.dart';
import '../widgets/cart_store_card.dart';
import '../widgets/payment_method_alert.dart';

// Helper function to create ClientOrder from cart items
ClientOrder _createOrderFromCart(List<Object> cartItems, Map<String, int>? productQuantities) {
  double subtotal = 0.0;
  final quantities = productQuantities ?? {};
  List<Object> itemsWithQuantities = [];
  
  // Calculate subtotal from cart items with quantities and create items with quantities
  for (final item in cartItems) {
    String productKey;
    double price = 0.0;
    String name = 'Unknown Product';
    
    if (item is Map<String, dynamic>) {
      // Handle new product data structure
      price = (item['price'] as num?)?.toDouble() ?? 0.0;
      name = (item['name'] ?? item['enName'] ?? item['arName'] ?? 'Unknown Product').toString();
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

  void _createOrderWithPayment(int paymentMethod) async {
    final cartState = context.read<CartBloc>().state;

    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Select address'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
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
          const SnackBar(
            content: Text('Order created successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        context.read<CartBloc>().add(CartClear());

        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/orders');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_orderController.error ?? 'Failed to create order'),
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
          ? (data['message'] ?? data['title'] ?? data['error'] ?? 'Failed to create order').toString()
          : 'Failed to create order';

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
        const SnackBar(
          content: Text('Failed to create order'),
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
              title: 'Your Cart',
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
                              CartStoreCard(context, screenWidth, screenHeight),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * .02,
                                ),
                                child: BlocBuilder<CartBloc, CartState>(
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
                              BlocBuilder<CartBloc, CartState>(
                                builder: (context, cartState) {
                                  return OrderSummaryCard(
                                    screenWidth, 
                                    screenHeight, 
                                    _createOrderFromCart(cartState.cartProducts, cartState.productQuantities)
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
                                'Proceed To Checkout',
                                false,
                                () {
                                  // Check if there's a selected or default address before proceeding to payment
                                  if (_selectedAddress == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Please Select address'),
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
                                'Continue Shopping',
                                'Clear Cart',
                                () {},
                                () {},
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
