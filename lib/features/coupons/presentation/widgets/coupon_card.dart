import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/view_Consumption_history_alert.dart';
import '../../../../core/theme/colors.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_bloc.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_event.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_state.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import '../../../orders/presentation/widgets/order_image_network_widget.dart';
import '../../../profile/presentation/widgets/quantity_increase_Decrease.dart';
import '../../../../core/components/coupon_status_widget.dart';
import 'custom_text.dart';

class CouponeCard extends StatefulWidget {
bool disbute;
CouponeCard({this.disbute=false});
  @override
  State<CouponeCard> createState() => _CouponeCardState();
}

class _CouponeCardState extends State<CouponeCard> {
  String imageUrl = '';
  bool _isSwitched = false; // Initial state of the switch
  late final ProductQuantityBloc _quantityBloc;
  late final ProductQuantityBloc _quantityTwoBloc;
  late final TextEditingController _quantityController;
  late final TextEditingController _quantityTwoController;

  @override
  void initState() {
    _quantityBloc = ProductQuantityBloc(
      calculateProductPrice: CalculateProductPrice(),
      basePrice: 100.0,
    );
    _quantityTwoBloc = ProductQuantityBloc(
      calculateProductPrice: CalculateProductPrice(),
      basePrice: 100.0,
    );
    _quantityController = TextEditingController(text: '1');

    _quantityTwoController = TextEditingController(text: '1');

    super.initState();
  }

  void dispose() {
    _quantityController.dispose();
    _quantityBloc.close();
    _quantityTwoBloc.close();
    _quantityTwoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * .01),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * .02,
        horizontal: screenWidth * .03,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            offset: Offset(0, 2),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customCouponPrimaryTitle(
                '25 Coupon Bundle',
                screenWidth,
                screenHeight,
              ),
              CouponStatus(screenHeight, screenWidth, 'Active'),
            ],
          ),
          Row(
            children: [
              SvgPicture.asset(
                "assets/images/orders/calendar.svg",
                width: screenWidth * .042,
                color: AppColors.textLight,
              ),
              SizedBox(width: screenWidth * .02),
              Text(
                'Purchased On March 24, 2025',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: screenWidth * .036,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * .01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildNetworkOrderImage(
                  screenWidth,
                  screenHeight,
                  imageUrl,
                  'assets/images/home/main_page/company.png',
                ),
                SizedBox(width: screenWidth * .03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Company 1',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * .037,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * .01,
                      ),
                      child: Text(
                        'Total Order Value',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: screenWidth * .032,
                          color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                        ),
                      ),
                    ),
                    Text(
                      'QAR 200.00',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * .037,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              customCouponPrimaryTitle(
                'Coupon Balance',
                screenWidth,
                screenHeight,
              ),
              CouponStatus(screenHeight, screenWidth, '10 Left'),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
            child: LinearProgressIndicator(
              value: 0.4,
              // Represents 70% progress
              backgroundColor: AppColors.primaryLight,
              minHeight: screenHeight * .012,
              borderRadius: BorderRadius.circular(10),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customCouponSecondaryTitle('25 Total', screenWidth, screenHeight),
              customCouponSecondaryTitle('15 Used', screenWidth, screenHeight),
              customCouponSecondaryTitle(
                '10 Remaining',
                screenWidth,
                screenHeight,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight * .01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customCouponPrimaryTitle(
                  'Auto-Renewal',
                  screenWidth,
                  screenHeight,
                ),

                Transform.scale(
                  scale: .65, // Bigger (1.0 = default)
                  child: CupertinoSwitch(
                    activeColor: AppColors.primary,
                    value: _isSwitched,
                    onChanged: (value) {
                      setState(() {
                        _isSwitched = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(bottom: screenHeight * .02),
              child: Text(
                'Automatically Purchase New Coupons When This Bundle Runs Out',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: screenWidth * .036,
                ),
              ),
            ),
          ),
          Text(
            'Delivery Address',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: screenWidth * .036,
            ),
          ),
          Text(
            'Zone abc, Street 20, Building 21, Flat 22',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: screenWidth * .032,
              color: AppColors.BorderAnddividerAndIconColor,
            ),
          ),
          SizedBox(height: screenHeight * .03),
          customCouponPrimaryTitle(
            'Weekly Sent Bundles',
            screenWidth,
            screenHeight,
          ),

          BlocProvider.value(
            value: _quantityBloc,
            child: BlocBuilder<ProductQuantityBloc, ProductQuantityState>(
              builder: (context, state) {
                // Update controller when state changes
                if (_quantityController.text != state.quantity) {
                  _quantityController.text = state.quantity;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * .02,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: IncreaseDecreaseQuantity(
                              context: context,
                              width: screenWidth,
                              height: screenHeight,
                              isPlus: true,
                              price: 0,
                              // Not used for the controls
                              onIncrease: () => context
                                  .read<ProductQuantityBloc>()
                                  .add(IncreaseQuantity()),
                              onDecrease: () => context
                                  .read<ProductQuantityBloc>()
                                  .add(DecreaseQuantity()),
                              quantityCntroller: _quantityController,
                              onTextfieldChanged: (value) => context
                                  .read<ProductQuantityBloc>()
                                  .add(QuantityChanged(value)),
                              onDone: () => context
                                  .read<ProductQuantityBloc>()
                                  .add(QuantityEditingComplete()),
                              fromDetailedScreen: true,
                              title: 'Days',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          customCouponPrimaryTitle(
            'Bottles For Once',
            screenWidth,
            screenHeight,
          ),

          BlocProvider.value(
            value: _quantityTwoBloc,
            child: BlocBuilder<ProductQuantityBloc, ProductQuantityState>(
              builder: (context, state) {
                // Update controller when state changes
                if (_quantityTwoController.text != state.quantity) {
                  _quantityTwoController.text = state.quantity;
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * .02,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: IncreaseDecreaseQuantity(
                              context: context,
                              width: screenWidth,
                              height: screenHeight,
                              isPlus: true,
                              price: 0,
                              // Not used for the controls
                              onIncrease: () => context
                                  .read<ProductQuantityBloc>()
                                  .add(IncreaseQuantity()),
                              onDecrease: () => context
                                  .read<ProductQuantityBloc>()
                                  .add(DecreaseQuantity()),
                              quantityCntroller: _quantityTwoController,
                              onTextfieldChanged: (value) => context
                                  .read<ProductQuantityBloc>()
                                  .add(QuantityChanged(value)),
                              onDone: () => context
                                  .read<ProductQuantityBloc>()
                                  .add(QuantityEditingComplete()),
                              fromDetailedScreen: true,
                              title: 'Bottles',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          BuildInfoAndAddToCartButton(
            screenWidth,
            screenHeight,
            'View Consumption History',
            false,
            () {
              showDialog(
                context: context,
                builder: (ctx) => ViewConsumptionHistoryAlert(disbute:widget.disbute),
              );
            },
            fromCouponsScreen: true,
          ),
        ],
      ),
    );
  }
}
