import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/game_icons.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:newwwwwwww/features/coupons/presentation/screens/coupons_screen.dart';
import 'package:newwwwwwww/features/notification/presentation/pages/notification_screen.dart';
import '../../../../core/theme/colors.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import 'dart:io' show Platform;
import 'fixed_bage_widget.dart';

class BuildForegroundappbarhome extends StatefulWidget {
  double screenHeight;
  double screenWidth;
  String title;
  bool is_returned;
  String disabledCart;
  String disabledNotification;
  String disabledGallon;
  GestureTapCallback? onReturnFromSupplierDetail;

  BuildForegroundappbarhome({
    required this.screenHeight,
    required this.screenWidth,
    required this.title,
    required this.is_returned,
    this.disabledCart = '',
    this.disabledNotification = '',
    this.disabledGallon='',
    this.onReturnFromSupplierDetail=null
  });

  @override
  State<BuildForegroundappbarhome> createState() =>
      _BuildForegroundappbarhomeState();
}

class _BuildForegroundappbarhomeState extends State<BuildForegroundappbarhome> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Positioned(
      top:Platform.isAndroid ?  MediaQuery.of(context).padding.top + widget.screenHeight * .04:MediaQuery.of(context).padding.top + widget.screenHeight * .02, //05 handle design shimaa
      left: widget.screenWidth*.04,
      right:  widget.screenWidth*.04,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.is_returned
                  ? GestureDetector(
                onTap: widget.onReturnFromSupplierDetail == null
                    ? () {
                  Navigator.pop(context);
                }
                    : widget.onReturnFromSupplierDetail!,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: screenWidth * .02,
                    left: screenWidth * .02,
                  ),
                  child: Iconify(
                    MaterialSymbols.arrow_back_ios,
                    size: screenWidth * .05,
                    color: AppColors.whiteColor,
                  ),
                ),
              )
                  : const SizedBox(),

              /// 👇 هنا بقى بنقيّد عرض العنوان + نخليه ellipsis
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: widget.screenWidth * 0.45, // حوالي نص المساحة الشمال
                ),
                child: Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w400,
                    fontSize: widget.screenWidth * .042,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(
            width: widget.screenWidth * .36,// edit *0.38
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    widget.disabledGallon == 'Coupons'
                        ? null
                        : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CouponsScreen(fromViewButton: true,),
                      ),
                    );
                  },
                  child:
                  badges.Badge(
                    badgeContent: buildFixedBadge(
                      size: screenWidth * .048,
                      text: '25',
                      color: AppColors.whiteColor,
                      fontSize: screenWidth * .028,
                    ),
                    badgeStyle: badges.BadgeStyle(
                      shape: badges.BadgeShape.circle,
                      badgeColor: AppColors.redColor,
                      padding: EdgeInsets.zero,
                    ),
                    child: Iconify(
                      GameIcons.water_gallon,
                      size: widget.screenWidth * .05,
                      color: AppColors.whiteColor,
                    ),
                  ),


                ),
                InkWell(
                  onTap: () {
                    widget.disabledNotification == 'notifications'
                        ? null
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationScreen(),
                            ),
                          );
                  },
                  child: Icon(
                    Icons.notifications,
                    color: AppColors.whiteColor,
                    size: widget.screenWidth * .05,
                  ),
                ),
                InkWell(
                  onTap: () {
                    widget.disabledCart == 'cart'
                        ? null
                        : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: context.read<CartBloc>(),
                          child: CartScreen(),
                        ),
                      ),
                    );
                  },
                  child:badges.Badge(
                    position: badges.BadgePosition.topEnd(top: -8, end: -4),
                    badgeContent: buildFixedBadge(
                      size: screenWidth * .048,
                      text: context.select<CartBloc, String>((b) => b.state.cartProducts.length.toString()),
                      color: AppColors.whiteColor,
                      fontSize: screenWidth * .028,
                    ),
                    badgeStyle: badges.BadgeStyle(
                      shape: badges.BadgeShape.circle,
                      badgeColor: AppColors.redColor,
                      padding: EdgeInsets.zero,
                    ),
                    child: Padding(
                      padding:  EdgeInsets.only(right: screenWidth*.02),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: AppColors.whiteColor,
                        size: widget.screenWidth * .05,
                      ),
                    ),
                  ),


                ),

                SvgPicture.asset(
                  "assets/images/home/Language.svg",
                  width: widget.screenWidth * .05,
                ),
                SvgPicture.asset(
                  "assets/images/home/headphone.svg",
                  width: widget.screenWidth * .05,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
