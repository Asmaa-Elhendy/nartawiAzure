import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:newwwwwwww/core/theme/colors.dart';

import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:newwwwwwww/core/utils/components/confirmation_alert.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/snack_bar_warnning.dart';
import '../../../../../../core/theme/colors.dart';
import '../../../bloc/cart/cart_bloc.dart';
import '../../../bloc/cart/cart_event.dart';
import '../../snack_bar_add_product.dart';

class BuildIconOnProduct extends StatefulWidget {
 final double width;
 final double height;
 final  bool isPlus;
 final  bool isFavourite;
 final bool isDelete;
 final double price;

 const BuildIconOnProduct(
     this.price,
     this.width,
     this.height,
     this.isPlus,
     this.isFavourite, {
       this.isDelete = false,   // ✅ default here
       Key? key,
     }) : super(key: key);

  @override
  _BuildIconOnProductState createState() => _BuildIconOnProductState();
}

class _BuildIconOnProductState extends State<BuildIconOnProduct> {
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
    isFavourite = widget.isFavourite; // البداية
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * .09,//handel design product shimaa .1
      height: widget.height * .045,
      decoration: BoxDecoration(
        color: AppColors.backgrounHome,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: widget.isDelete
            ? Iconify(
          MaterialSymbols.delete_outline_rounded,
          size: widget.height * .025,//03 handle design product shimaa
          color: AppColors.primary,
        )
            : widget.isPlus
            ? InkWell(
          onTap: (){
          //  showSnackBarAddProduct(context, widget.width, widget.height, 'You’ve added 1 item.Confirm to add to cart.');
            showDialog(
                context: context,
                builder: (dialogContext) =>
            ConfirmationAlert(
              price:widget.price,
              centerTitle: 'You\'ve added 1 item',leftOnTap: (){
              Navigator.pop(dialogContext);
              context.read<CartBloc>().add(CartAddItem('Hand Pump'));

            },
                rightOnTap: (){
              Navigator.pop(dialogContext);
                }

            ,leftTtile: 'Confirm',rightTitle: 'Cancel',  itemAAdedToCart:true,),

            );
          },
              child: Icon(
                        Icons.add,
                        size: widget.height * .025,//03 handle design product shimaa
                        color: AppColors.primary,
                      ),
            )
            : InkWell(
          onTap: () {
            setState(() {
              isFavourite = !isFavourite;
            });
          },
          child: Iconify(
            isFavourite ? Mdi.heart : Mdi.heart_outline,
            color: isFavourite
                ? AppColors.redColor
                : AppColors.primary,
            size: widget.height * .025,//03 handle design product shimaa
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
