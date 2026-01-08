import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newwwwwwww/features/favourites/domain/models/favorite_product.dart';
import 'package:newwwwwwww/features/home/domain/models/product_model.dart';
import '../../../../../../core/theme/colors.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_bloc.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_event.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_state.dart';
import '../../../home/presentation/bloc/cart/cart_bloc.dart';
import '../../../home/presentation/bloc/cart/cart_event.dart';
import '../../../home/presentation/pages/suppliers/product_details.dart';
import '../../../home/presentation/widgets/main_screen_widgets/price_widget.dart';
import '../../../home/presentation/widgets/main_screen_widgets/products/icon_on_product_card.dart';
import '../../../home/presentation/widgets/main_screen_widgets/products/product_card.dart';
import '../../../profile/presentation/widgets/quantity_increase_Decrease.dart';

class FavouriteProductCard extends StatefulWidget {
  double screenWidth;
  double screenHeight;
FavoriteProduct favouriteProduct;
    bool fromCartScreen;

  FavouriteProductCard({
    required this.screenWidth,
    required this.screenHeight,
    required this.favouriteProduct,
    this.fromCartScreen = false,
  });

  @override
  State<FavouriteProductCard> createState() => _FavouriteProductCardState();
}

class _FavouriteProductCardState extends State<FavouriteProductCard> {
  late final TextEditingController _quantityController;
  late final ProductQuantityBloc _quantityBloc;
  late final ProductQuantityBloc _quantityTwoBloc;
  late final TextEditingController _quantityTwoController;
  
  // Separate bloc for Weekly Sent Bundles
  late final ProductQuantityBloc _weeklyBundlesBloc;
  late final TextEditingController _weeklyBundlesController;

  // Helper method to get product item for cart updates
  Object _getProductItemForCart() {
    if (widget.favouriteProduct.product != null) {
      return {
        'id': widget.favouriteProduct.product!.id,
        'name': widget.favouriteProduct.product!.enName,
        'price': widget.favouriteProduct.product!.price,
      };
    } else {
      return 'Product_${widget.favouriteProduct.id}';
    }
  }

  // Helper method to get product key that matches the one used in CartBloc
  String _getProductKeyForCurrentItem() {
    if (widget.favouriteProduct.product != null) {
      return 'product_${widget.favouriteProduct.product!.id}';
    } else {
      return 'Product_${widget.favouriteProduct.id}';
    }
  }

  // Helper method to notify cart of quantity change
  void _notifyCartQuantityChange(int quantity) {
    if (widget.fromCartScreen) {
      try {
        final productItem = _getProductItemForCart();
        final cartBloc = context.read<CartBloc>();
        
        // Check if the bloc is properly initialized
        if (cartBloc.isClosed) {
          return;
        }
        
        cartBloc.add(CartUpdateQuantity(productItem, quantity));
      } catch (e) {
        // Handle any errors gracefully
      }
    }
  }

  // Helper method to get the actual cart item that matches what's in the cart
  Object _getActualCartItem() {
    if (widget.favouriteProduct.product != null) {
      // This should match exactly what's added to cart
      return {
        'id': widget.favouriteProduct.product!.id,
        'name': widget.favouriteProduct.product!.enName,
        'price': widget.favouriteProduct.product!.price,
      };
    } else {
      return 'Product_${widget.favouriteProduct.id}';
    }
  }

  @override
  void initState() {
    super.initState();
    
    // Get initial quantity from cart state if in cart screen
    int initialQuantity = 1;
    if (widget.fromCartScreen) {
      try {
        final cartState = context.read<CartBloc>().state;
        final productKey = _getProductKeyForCurrentItem();
        initialQuantity = cartState.productQuantities?[productKey] ?? 1;
      } catch (e) {
        // Handle any errors gracefully
        initialQuantity = 1;
      }
    }
    
    _quantityController = TextEditingController(text: initialQuantity.toString());
    
    // Check if product exists, otherwise use default price
    final productPrice = widget.favouriteProduct.product?.price.toDouble() ?? 0.0;
    
    _quantityBloc = ProductQuantityBloc(
      calculateProductPrice: CalculateProductPrice(),
      basePrice: productPrice,
    );
    
    _quantityTwoBloc = ProductQuantityBloc(
      calculateProductPrice: CalculateProductPrice(),
      basePrice: productPrice,
    );
    
    _quantityTwoController = TextEditingController(text: initialQuantity.toString());
    
    // Initialize weekly bundles bloc (always starts with 1)
    _weeklyBundlesBloc = ProductQuantityBloc(
      calculateProductPrice: CalculateProductPrice(),
      basePrice: productPrice,
    );
    _weeklyBundlesController = TextEditingController(text: '1');
    
    // Initialize the ProductQuantityBlocs after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.fromCartScreen) {
        _quantityBloc.add(QuantityChanged(initialQuantity.toString()));
        _quantityTwoBloc.add(QuantityChanged(initialQuantity.toString()));
        // Weekly bundles always starts with 1
        _weeklyBundlesBloc.add(QuantityChanged('1'));
      }
    });
  }

  // Helper method to get product key from cart state logic
  String _getProductKey(Object item) {
    if (item is Map<String, dynamic>) {
      return 'product_${item['id'] ?? 0}';
    } else if (item.toString().contains('Product')) {
      return item.toString();
    }
    return 'unknown_${item.hashCode}';
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _quantityBloc.close();
    _quantityTwoBloc.close();
    _quantityTwoController.dispose();
    _weeklyBundlesController.dispose();
    _weeklyBundlesBloc.close();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => ProductDetailScreen(favoriteProduct: widget.favouriteProduct,fromFavorite: true,)));
      },
      child: BlocProvider.value(
        value: _quantityBloc,
        child: BlocBuilder<ProductQuantityBloc, ProductQuantityState>(
          builder: (context, state) {
            // Update controller when state changes
            if (_quantityController.text != state.quantity) {
              _quantityController.text = state.quantity;
            }
            double containerHeight = widget.fromCartScreen
                ? widget.screenHeight * .29//.33 handle design shimaa
                : widget.screenHeight * .257; //handle height of favourite product card handle design dhimaa
            return Padding(
              padding: EdgeInsets.only(
                bottom: widget.screenHeight * .02,
                left: widget.fromCartScreen ? 0 : widget.screenWidth * .06,
                right: widget.fromCartScreen ? 0 : widget.screenWidth * .06,
              ),
              child: Container(
                width: widget.screenWidth,
                height: containerHeight,
                //from cart can be coupon or product (weekly sent bundles)
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.favouriteProductCard,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                              child: Image.asset(

                                'assets/images/home/main_page/product.jpg',
                                width: widget.screenWidth * .31,
                                // match or be smaller than containe
                                height: containerHeight,
                                //height according container
                                fit: BoxFit.cover,
                              ),
                            ),
                            widget.fromCartScreen//j
                                ? Positioned(
                                    top: widget.screenHeight * 0.01,
                                    left: widget.screenWidth * 0.01,
                                    child: BuildIconOnProduct(
                                      true,  // fromFavouriteScreen
                                      widget.favouriteProduct.productVsId,  // productVsا
                                      widget.favouriteProduct.product?.enName,  // productName
                                      state.price,  // price
                                      widget.screenWidth,  // width
                                      widget.screenHeight,  // height
                                      false,  // isPlus (false for delete)
                                      isFavourite: true,  // isFavourite
                                      isDelete: true,  // isDelete = true
                                    ),
                                  )
                                : Positioned(
                                    top: widget.screenHeight * 0.01,
                                    right: widget.screenWidth * 0.01,
                                    left: widget.screenWidth * 0.01,
                                    child: Row(
                                      //  mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        BuildIconOnProduct(true,widget.favouriteProduct.productVsId,widget.favouriteProduct.product?.enName,(widget.favouriteProduct.product?.price ?? 0.0).toDouble(),
                                          widget.screenWidth,
                                          widget.screenHeight,
                                          true, // plus icon
                                          isFavourite: true,
                                        ),
                                        //      SizedBox(width: widget.screenWidth * 0.02), // Spacing between icons
                                        BuildIconOnProduct(true,widget.favouriteProduct.productVsId,widget.favouriteProduct.product?.enName,(widget.favouriteProduct.product?.price ?? 0.0).toDouble(),
                                          widget.screenWidth,
                                          widget.screenHeight,
                                          false, // heart icon
                                          isFavourite: true,
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: widget.screenHeight * .005,//edit design for mobile
                              top: widget.screenHeight * .005,//edit design for mobile
                              right: widget.screenWidth * .03,
                              left: widget.screenWidth * .03,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.fromCartScreen
                                    ? SizedBox()
                                    : ProductTitle(
                                        widget.screenHeight,
                                        widget.screenWidth,
                                      ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: widget.fromCartScreen
                                        ? 0
                                        : widget.screenWidth * .01,
                                    bottom: widget.screenHeight * .01,
                                  ),
                                  child: Text(
                                   widget.favouriteProduct.product?.enName ?? 'Product',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: widget.screenWidth * .03, //.028
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  'company hand pump dispenser-pure natural...',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: widget.screenWidth * .028,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: widget.screenHeight * .01,
                                  ),
                                  child: Text(
                                    "QAR ${widget.favouriteProduct.product?.price}",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: widget.screenWidth * .036,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  'one-time purchase',
                                  style: TextStyle(
                                    fontSize: widget.screenWidth * .028,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: widget.screenHeight * .01,
                                    horizontal: widget.screenWidth * .01,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: BuildRoundedIconOnProduct(
                                          fromCartScreen: widget.fromCartScreen,
                                          context: context,
                                          width: widget.screenWidth,
                                          height: widget.screenHeight,
                                          isPlus: true,

                                          price: 0,
                                          onIncrease: () {
                                            context.read<ProductQuantityBloc>().add(IncreaseQuantity());
                                            // Notify cart of quantity change after state updates
                                            Future.delayed(Duration(milliseconds: 100), () {
                                              final currentQuantity = int.tryParse(_quantityController.text) ?? 1;
                                              _notifyCartQuantityChange(currentQuantity);
                                            });
                                          },
                                          onDecrease: () {
                                            context.read<ProductQuantityBloc>().add(DecreaseQuantity());
                                            // Notify cart of quantity change after state updates
                                            Future.delayed(Duration(milliseconds: 100), () {
                                              final currentQuantity = int.tryParse(_quantityController.text) ?? 1;
                                              _notifyCartQuantityChange(currentQuantity);
                                            });
                                          },
                                          quantityCntroller: _quantityController,
                                          onTextfieldChanged: (value) {
                                            context.read<ProductQuantityBloc>().add(QuantityChanged(value));
                                            // Notify cart of quantity change
                                            final quantity = int.tryParse(value) ?? 1;
                                            _notifyCartQuantityChange(quantity);
                                          },
                                          onDone: () {
                                            context.read<ProductQuantityBloc>().add(QuantityEditingComplete());
                                            // Notify cart of quantity change
                                            final quantity = int.tryParse(_quantityController.text) ?? 1;
                                            _notifyCartQuantityChange(quantity);
                                          },
                                        ),//k
                                      ),
                                      SizedBox(width: widget.screenWidth*.01,),
                                      BuildPriceContainer(
                                        widget.screenWidth,
                                        widget.screenHeight,
                                        state,
                                      ),
                                    ],
                                  ),
                                ),
                                widget.fromCartScreen
                                    ? //not always when coupon only not product in cart screen
                                      Text(
                                        "Weekly Sent Bundles",
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: widget.screenWidth * .036,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : SizedBox(),
                                widget.fromCartScreen
                                    ? BlocProvider.value(
                                        value: _weeklyBundlesBloc,
                                        child:
                                            BlocBuilder<
                                              ProductQuantityBloc,
                                              ProductQuantityState
                                            >(
                                              builder: (context, state) {
                                                // Update controller when state changes
                                                if (_weeklyBundlesController.text != state.quantity) {
                                                  _weeklyBundlesController.text = state.quantity;
                                                }
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        top:
                                                            widget
                                                                .screenHeight *
                                                            0.01,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: IncreaseDecreaseQuantity(
                                                              context: context,
                                                              width: widget
                                                                  .screenWidth,
                                                              height: widget
                                                                  .screenHeight,
                                                              isPlus: true,
                                                              price: 0,
                                                              // Not used for the controls
                                                              onIncrease: () => context
                                                                  .read<
                                                                    ProductQuantityBloc
                                                                  >()
                                                                  .add(
                                                                    IncreaseQuantity(),
                                                                  ),
                                                              onDecrease: () => context
                                                                  .read<
                                                                    ProductQuantityBloc
                                                                  >()
                                                                  .add(
                                                                    DecreaseQuantity(),
                                                                  ),
                                                              quantityCntroller:
                                                                  _weeklyBundlesController,
                                                              onTextfieldChanged:
                                                                  (
                                                                    value,
                                                                  ) => context
                                                                      .read<
                                                                        ProductQuantityBloc
                                                                      >()
                                                                      .add(
                                                                        QuantityChanged(
                                                                          value,
                                                                        ),
                                                                      ),
                                                              onDone: () => context
                                                                  .read<
                                                                    ProductQuantityBloc
                                                                  >()
                                                                  .add(
                                                                    QuantityEditingComplete(),
                                                                  ),
                                                              fromDetailedScreen:
                                                                  true,
                                                              title: '',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
