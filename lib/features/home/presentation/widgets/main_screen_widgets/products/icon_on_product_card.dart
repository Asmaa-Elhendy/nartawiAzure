import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:newwwwwwww/core/theme/colors.dart';

import 'package:newwwwwwww/core/utils/components/confirmation_alert.dart';
import '../../../../../favourites/pesentation/provider/favourite_controller.dart';
import '../../../../domain/models/product_model.dart';
import '../../../bloc/cart/cart_bloc.dart';
import '../../../bloc/cart/cart_event.dart';

class BuildIconOnProduct extends StatefulWidget {
  final bool fromFavouriteScreen;
  final int productVsId;

  final double width;
  final double height;
  final bool isPlus;

  /// ✅ start value from parent (for now you pass false always)
  final bool isFavourite;
  final bool isDelete;
  final double price;

  const BuildIconOnProduct(
      this.fromFavouriteScreen,
      this.productVsId,
      this.price,
      this.width,
      this.height,
      this.isPlus,{
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
            ? Iconify(
          MaterialSymbols.delete_outline_rounded,
          size: widget.height * .025,
          color: AppColors.primary,
        )
            : widget.isPlus
            ? InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (dialogContext) => ConfirmationAlert(
                price: widget.price,
                centerTitle: 'You\'ve added 1 item',
                leftOnTap: () {
                  Navigator.pop(dialogContext);
                  // For now, add a placeholder since we don't have ClientProduct
                  // In the future, you might want to fetch the product data or pass it differently
                  context.read<CartBloc>().add(CartAddItem('Product ${widget.productVsId}'));
                },
                rightOnTap: () {
                  Navigator.pop(dialogContext);
                },
                leftTtile: 'Confirm',
                rightTitle: 'Cancel',
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
                const SnackBar(
                  content: Text('Something went wrong, please try again'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } finally {
              _isToggling = false;
            }
          },


          child: Iconify(
            isFavourite ? Mdi.heart : Mdi.heart_outline,
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
                child: Iconify(
                  Ic.baseline_minus, // استبدلها بالأيقونة اللي تحبها
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
