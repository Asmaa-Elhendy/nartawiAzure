import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:newwwwwwww/core/theme/colors.dart';
import 'package:newwwwwwww/features/home/presentation/bloc/product_quantity/product_quantity_bloc.dart';
import 'package:newwwwwwww/features/home/presentation/bloc/product_quantity/product_quantity_event.dart';
import 'package:newwwwwwww/core/utils/components/confirmation_alert.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../cart/presentation/bloc/cached_cart_bloc.dart';
import '../../../../../favourites/pesentation/provider/favourite_controller.dart';
import '../../../bloc/cart/cart_event.dart';
import '../../../bloc/cart/cart_state.dart';
import '../../General_alert.dart';

class BuildIconOnProduct extends StatefulWidget {
  final bool fromFavouriteScreen;
  final int productVsId;
  final String? productName;

  final double width;
  final double height;
  final bool isPlus;

  /// ✅ start value from parent (for now you pass false always)
  final bool isFavourite;
  final bool isDelete;
  final double price;
  final String supplierId;
  final String supplierName;
  final double? supplierRating;
  final String? supplierLogo;

  const BuildIconOnProduct(
      this.fromFavouriteScreen,
      this.productVsId,
      this.productName,
      this.price,
      this.width,
      this.height,
      this.isPlus,
      this.supplierId,
      this.supplierName,
      this.supplierRating,
      this.supplierLogo, {
        this.isFavourite=false,
        this.isDelete = false,
      });

  @override
  _BuildIconOnProductState createState() => _BuildIconOnProductState();
}

class _BuildIconOnProductState extends State<BuildIconOnProduct> {
  late bool isFavourite;

  // ✅ يمنع الضغط المتكرر بسرعة (optional)
  bool _isToggling = false;

  // ✅ Store controller reference to avoid context issues in dispose
  FavoritesController? _favoritesController;

  @override
  void initState() {
    super.initState();

    // ✅ Check initial favorite status from controller
    if (widget.fromFavouriteScreen) {
      // In favorites screen, it's always favorited
      isFavourite = true;
    } else {
      // In other screens, check from controller
      _favoritesController = context.read<FavoritesController>();
      isFavourite = _favoritesController!.isFavoritedVsId(widget.productVsId);

      // ✅ Listen for changes to update UI automatically
      _favoritesController!.addListener(_onFavoritesChanged);
    }
  }

  @override
  void dispose() {
    if (!widget.fromFavouriteScreen && _favoritesController != null) {
      _favoritesController!.removeListener(_onFavoritesChanged);
    }
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (!widget.fromFavouriteScreen && mounted && _favoritesController != null) {
      final newStatus = _favoritesController!.isFavoritedVsId(widget.productVsId);
      if (isFavourite != newStatus) {
        setState(() {
          isFavourite = newStatus;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * .09,
      height: widget.height * .045,
      decoration: BoxDecoration(
        color: AppColors.backgrounHome,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: widget.isDelete
            ? InkWell(
          onTap: () {
            // Show confirmation dialog before deleting using same design as address deletion
            showDialog(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: Text(
                  AppLocalizations.of(context)!.removeFromCart,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: widget.width * .036,
                  ),
                ),
                content: Text(
                  AppLocalizations.of(context)!.removeFromCartConfirmation,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: AppColors.primary)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext, true);
                      // Remove from cart using exact matching
                      final cartState = context.read<CachedCartBloc>().state;
                      if (cartState is CartState) {
                        // Find the exact item to remove
                        Object? itemToRemove;

                        for (final item in cartState.cartProducts) {
                          if (item is Map<String, dynamic>) {
                            // For Map items, match by ID exactly
                            if (item['id'] == widget.productVsId) {
                              itemToRemove = item;
                              break;
                            }
                          } else if (item.toString().contains('Product')) {
                            // For string items, match by productVsId pattern
                            if (item.toString().contains('${widget.productVsId}')) {
                              itemToRemove = item;
                              break;
                            }
                          }
                        }

                        // Remove only the specific item
                        if (itemToRemove != null) {
                          context.read<CachedCartBloc>().add(CartRemoveItem(itemToRemove));
                        }
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.remove, style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          child: Icon(
            Icons.delete_outline,
            size: widget.height * .025,
            color: AppColors.primary,
          ),
        )
            : widget.isPlus
            ? InkWell(
          onTap: () {
            // Check supplier compatibility before showing dialog
            final cartState = context.read<CachedCartBloc>().state;
            bool productAlreadyInCart = false;
            String? existingSupplierId;

            if (cartState is CartState) {
              // Check for existing products and their suppliers
              for (final item in cartState.cartProducts) {
                if (item is Map<String, dynamic>) {
                  final existingProductId = item['id'] as int? ?? 0;
                  if (existingProductId == widget.productVsId) {
                    productAlreadyInCart = true;
                    break;
                  }

                  // Get supplier ID from existing cart items
                  if (existingSupplierId == null) {
                    if (item['product'] is Map<String, dynamic>) {
                      existingSupplierId = item['product']['Supplierid']?.toString() ??
                          item['product']['SupplierId']?.toString() ?? '0';
                    } else {
                      existingSupplierId = item['Supplierid']?.toString() ??
                          item['SupplierId']?.toString() ?? '0';
                    }
                  }
                }
              }
            }

            // Check supplier compatibility if cart is not empty
            if (existingSupplierId != null && existingSupplierId != widget.supplierId) {
              // Different supplier found - show error message immediately
              showDialog(
                context: context,
                builder: (ctx) => GeneralAlert(
                  width: MediaQuery.of(context).size.width,
                  message:AppLocalizations.of(context)!.supplierError,
                ),
              );
              return; // 
            }

            // Get quantity for the message before showing dialog
            int quantity = 1;
            try {
              final quantityBloc = context.read<ProductQuantityBloc>();
              quantity = int.tryParse(quantityBloc.state.quantity) ?? 1;
            } catch (e) {
              quantity = 1;
            }

            showDialog(
              context: context,
              builder: (dialogContext) => ConfirmationAlert(
                price: widget.price,
                centerTitle: AppLocalizations.of(context)!.addedToCart(quantity),
                leftOnTap: () {
                  Navigator.pop(dialogContext);

                  // Determine if product already exists in cart (prevents dead code)
                  final cartStateCheck = context.read<CachedCartBloc>().state;
                  bool productAlreadyInCart = false;

                  if (cartStateCheck is CartState) {
                    for (final item in cartStateCheck.cartProducts) {
                      if (item is Map<String, dynamic>) {
                        final existingId = item['id'] as int?;
                        if (existingId == widget.productVsId) {
                          productAlreadyInCart = true;
                          break;
                        }
                      } else {
                        // fallback for any non-map structure
                        if (item.toString().contains('${widget.productVsId}')) {
                          productAlreadyInCart = true;
                          break;
                        }
                      }
                    }
                  }

                  if (widget.fromFavouriteScreen && widget.isDelete == false) {
                    // For favorite products, create full product object
                    if (!productAlreadyInCart) {
                      // Try to get quantity from parent ProductQuantityBloc
                      int quantity = 1;
                      try {
                        // Look for ProductQuantityBloc in the widget tree
                        final quantityBloc = context.read<ProductQuantityBloc>();
                        quantity = int.tryParse(quantityBloc.state.quantity) ?? 1;
                      } catch (e) {
                        quantity = 1;
                      }

                      final productItem = {
                        'id': widget.productVsId,
                        'name': widget.productName ?? 'Product ${widget.productVsId}',
                        'price': widget.price,
                        'fromFavorite': true,
                        'quantity': quantity, // Add quantity to map
                        'product': {
                          'id': widget.productVsId,
                          'vsId': widget.productVsId,
                          'enName': widget.productName ?? 'Product ${widget.productVsId}',
                          'arName': widget.productName ?? 'منتج ${widget.productVsId}',
                          'Supplierid': widget.supplierId,
                          'SupplierName': widget.supplierName,
                          'SupplierRating': widget.supplierRating,
                          'SupplierLogo': widget.supplierLogo,
                          'price': widget.price,
                          'isActive': true,
                          'isCurrent': true,
                        }
                      };

                      context.read<CachedCartBloc>().add(CartAddItem(productItem));

                      // Reset controller to 1
                      try {
                        final quantityBloc = context.read<ProductQuantityBloc>();
                        quantityBloc.add(QuantityChanged('1'));
                      } catch (e) {
                        // Ignore if can't reset
                      }
                    } else {
                      // Product already exists, add controller quantity to existing quantity
                      int controllerQuantity = 1;
                      try {
                        // Get quantity from parent ProductQuantityBloc
                        final quantityBloc = context.read<ProductQuantityBloc>();
                        controllerQuantity = int.tryParse(quantityBloc.state.quantity) ?? 1;
                      } catch (e) {
                        controllerQuantity = 1;
                      }

                      // Get current quantity from cart
                      final cartState = context.read<CachedCartBloc>().state;
                      final productKey = 'product_${widget.productVsId}';
                      final currentQuantity = cartState.productQuantities?[productKey] ?? 1;
                      final newQuantity = currentQuantity + controllerQuantity;

                      final productItem = {
                        'id': widget.productVsId,
                        'name': widget.productName ?? 'Product ${widget.productVsId}',
                        'price': widget.price,
                        'fromFavorite': true,
                        'quantity': newQuantity, // Use new total quantity
                      };

                      // Update with new total quantity
                      context.read<CachedCartBloc>().add(CartUpdateQuantity(productItem, newQuantity));

                      // Reset controller to 1
                      try {
                        final quantityBloc = context.read<ProductQuantityBloc>();
                        quantityBloc.add(QuantityChanged('1'));
                      } catch (e) {
                        // Ignore if can't reset
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Product already in cart. Quantity updated to $newQuantity.'),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  } else if (!widget.fromFavouriteScreen && widget.isDelete == false) {
                    // For regular products, add with proper data
                    if (!productAlreadyInCart) {
                      // Try to get quantity from parent ProductQuantityBloc
                      int quantity = 1;
                      try {
                        // Look for ProductQuantityBloc in the widget tree
                        final quantityBloc = context.read<ProductQuantityBloc>();
                        quantity = int.tryParse(quantityBloc.state.quantity) ?? 1;
                      } catch (e) {
                        quantity = 1;
                      }

                      final productItem = {
                        'id': widget.productVsId,
                        'name': widget.productName ?? 'Product ${widget.productVsId}',
                        'price': widget.price,
                        'fromFavorite': false,
                        'quantity': quantity, // Add quantity to map
                        'product': {
                          'id': widget.productVsId,
                          'vsId': widget.productVsId,
                          'SupplierId': widget.supplierId,
                          'SupplierName': widget.supplierName,
                          'SupplierRating': widget.supplierRating,
                          'SupplierLogo': widget.supplierLogo,
                          'enName': widget.productName ?? 'Product ${widget.productVsId}',
                          'arName': widget.productName ?? 'منتج ${widget.productVsId}',
                          'price': widget.price,
                          'isActive': true,
                          'isCurrent': true,
                        }
                      };

                      context.read<CachedCartBloc>().add(CartAddItem(productItem));

                      // Reset controller to 1
                      try {
                        final quantityBloc = context.read<ProductQuantityBloc>();
                        quantityBloc.add(QuantityChanged('1'));
                      } catch (e) {
                        // Ignore if can't reset
                      }
                    } else {
                      // Product already exists, add controller quantity to existing quantity
                      int controllerQuantity = 1;
                      try {
                        // Get quantity from parent ProductQuantityBloc
                        final quantityBloc = context.read<ProductQuantityBloc>();
                        controllerQuantity = int.tryParse(quantityBloc.state.quantity) ?? 1;
                      } catch (e) {
                        controllerQuantity = 1;
                      }

                      // Get current quantity from cart
                      final cartState = context.read<CachedCartBloc>().state;
                      final productKey = 'product_${widget.productVsId}';
                      final currentQuantity = cartState.productQuantities?[productKey] ?? 1;
                      final newQuantity = currentQuantity + controllerQuantity;

                      final productItem = {
                        'id': widget.productVsId,
                        'name': widget.productName ?? 'Product ${widget.productVsId}',
                        'price': widget.price,
                        'fromFavorite': false,
                        'quantity': newQuantity, // Use new total quantity
                      };

                      // Update with new total quantity
                      context.read<CachedCartBloc>().add(CartUpdateQuantity(productItem, newQuantity));

                      // Reset controller to 1
                      try {
                        final quantityBloc = context.read<ProductQuantityBloc>();
                        quantityBloc.add(QuantityChanged('1'));
                      } catch (e) {
                        // Ignore if can't reset
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Product already in cart. Quantity updated to $newQuantity.'),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
                rightOnTap: () {
                  Navigator.pop(dialogContext);
                },
                leftTtile:AppLocalizations.of(context)!.confirm,
                rightTitle:AppLocalizations.of(context)!.cancel,
                itemAAdedToCart: true,
              ),
            );
          },
          child: Icon(
            Icons.add,
            size: widget.height * .025,
            color: AppColors.primary,
          ),
        )
            : InkWell(
          onTap: () async {
            if (_isToggling) return;
            _isToggling = true;

            final oldValue = isFavourite;

            setState(() => isFavourite = !isFavourite);

            final favoritesController = _favoritesController ?? context.read<FavoritesController>();

            try {
              if (isFavourite) {
                await favoritesController.makeProductFavorite(widget.productVsId);
                debugPrint('✅ API: Product added to favorites');
              } else {
                await favoritesController.removeProductFavorite(widget.productVsId);
                debugPrint('✅ API: Product removed from favorites');
              }

              // ✅ Refresh ALL favorites
              await favoritesController.refresh();
              debugPrint('🔄 Favorites refreshed (products + vendors)');

              // ✅ sync UI with controller result (guaranteed)
              final isNowFav = favoritesController.isFavoritedVsId(widget.productVsId);
              setState(() => isFavourite = isNowFav);
              debugPrint('💡 UI synced, isFavourite = $isNowFav');

            } catch (e) {
              debugPrint('❌ API ERROR: $e');
              setState(() => isFavourite = oldValue);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.unexpectedError),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } finally {
              _isToggling = false;
            }
          },


          child: Icon(
            isFavourite ? Icons.favorite : Icons.favorite_border,
            color: isFavourite ? AppColors.redColor : AppColors.primary,
            size: widget.height * .025,
          ),
        ),
      ),
    );
  }
}





Widget BuildRoundedIconOnProduct({
  required BuildContext context,
  required double width,
  required double height,
  required bool isPlus,
  int price = 0,
  required VoidCallback onIncrease,
  required VoidCallback onDecrease,
  required TextEditingController quantityCntroller,
  ValueChanged<String>? onTextfieldChanged,
  VoidCallback? onDone,
  bool fromDetailedScreen = false,
  bool fromCartScreen = false,
}) {
  return Container(
    padding: fromDetailedScreen || fromCartScreen
        ? EdgeInsets.symmetric(horizontal: width * .02)
        : EdgeInsets.zero,
    width: fromDetailedScreen
        ? width * .55
        : isPlus
        ? fromCartScreen
        ? width * .26
        : width * .21
        : width * .15,
    // الحجم العرض
    height: height * .045,
    // الحجم الارتفاع
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: AppColors.backgrounHome, // لون الخلفية
      shape: BoxShape.rectangle, // يجعله دائري
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Center(
      child:
      //  isPlus?
      Row(
        mainAxisAlignment: fromDetailedScreen || fromCartScreen
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onDecrease,
            child: Icon(
              Icons.remove,
              size: height * .03,
              color: AppColors.redColor,
            ),
          ),
          // Center(
          //   child: Padding(
          //     padding:  EdgeInsets.symmetric(horizontal: width*.014),
          //     child: Text('$quantity',style: TextStyle(fontWeight: FontWeight.w700),),
          //   ),
          // ),
          Container(
            width: width * 0.07,
            height: height * 0.04,
            alignment: Alignment.center,
            child: TextField(
              controller: quantityCntroller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: width * 0.034,
                overflow: TextOverflow.ellipsis,
              ),
              onChanged: onTextfieldChanged,
              onEditingComplete: onDone,
              onSubmitted: (value) {
                FocusScope.of(context).unfocus();
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          GestureDetector(
            onTap: onIncrease,
            child: Icon(
              Icons.add, // استبدلها بالأيقونة اللي تحبها
              size: height * .03,
              color: AppColors.greenColor,
            ),
          ),
        ],
      ),
      //:
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //
      //     Center(
      //       child: Padding(
      //         padding:  EdgeInsets.symmetric(horizontal: width*.01),
      //         child: Text('$price',style: TextStyle(fontWeight: FontWeight.w700),),
      //       ),
      //     ),
      //
      //
      //   ],
      // )
    ),
  );
}