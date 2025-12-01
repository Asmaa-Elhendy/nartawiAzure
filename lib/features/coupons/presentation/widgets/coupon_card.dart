import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/prefered_days_grid.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/refill_outline_button.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/snack_bar_warnning.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/view_Consumption_history_alert.dart';
import '../../../../core/theme/colors.dart';
import '../../../cart/presentation/widgets/change_address_alert.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_bloc.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_event.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_state.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import '../../../orders/presentation/widgets/order_image_network_widget.dart';
import '../../../profile/presentation/widgets/quantity_increase_Decrease.dart';
import '../../../../core/components/coupon_status_widget.dart';
import 'calender_dialog.dart';
import 'custom_text.dart';
import 'latest_coupon_tracker.dart';


class CouponeCard extends StatefulWidget {
  bool disbute;
  Function onReorder;


  CouponeCard({Key? key, this.disbute = false,required this.onReorder}) : super(key: key);

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
  /// الأيام اللي المستخدم اختارها كـ Preferred days
  /// 0 = Sunday, 1 = Monday, ... 6 = Saturday
  final Set<int> _selectedPreferredDays = {};

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

  @override
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
          /// Header: title + status
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

          /// Purchase date
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

          /// Company + image
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
                          color:
                          AppColors.greyDarktextIntExtFieldAndIconsHome,
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

          /// Coupon balance + status
          latestCouponTracker(screenWidth,screenHeight,widget.onReorder),
          /// Auto-Renewal
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
                  scale: .65,
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

          /// Auto-renewal description
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

          /// Address
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Address',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * .036,
                ),
              ),
              GestureDetector(
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (ctx) =>
                        ChangeAddressAlert(fromCouponCard:true),
                  );
                  // choose address for that coupon only
                },
                child: ShaderMask(
                  shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                  child: Text(
                    'Change Address',
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * .034,
                    ),
                  ),
                ),
              ),
            ],
          ),SizedBox(height: screenHeight*.01,),
          Text(
            'Zone abc, Street 20, Building 21, Flat 22',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: screenWidth * .032,
              color: AppColors.BorderAnddividerAndIconColor,
            ),
          ),

          SizedBox(height: screenHeight * .03),

          /// Weekly Sent Bundles
          customCouponPrimaryTitle(
            'Weekly Deliver frequency',
            screenWidth,
            screenHeight,
          ),

          /// Quantity: Days
          BlocProvider.value(
            value: _quantityBloc,
            child: BlocBuilder<ProductQuantityBloc, ProductQuantityState>(
              builder: (context, state) {
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

          /// Bottles For Once
          customCouponPrimaryTitle(
            'Bottles Per Delivery',
            screenWidth,
            screenHeight,
          ),

          BlocProvider.value(
            value: _quantityTwoBloc,
            child: BlocBuilder<ProductQuantityBloc, ProductQuantityState>(
              builder: (context, state) {
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

          /// Preferred Refill Times / Week
          customCouponPrimaryTitle(
            'Preferred Refill Times /Week',
            screenWidth,
            screenHeight,
          ),
          Text(
            'Used As A Guide, Not Mandatory',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: screenWidth * .032,
              color: AppColors.BorderAnddividerAndIconColor,
            ),
          ),

          SizedBox(height: screenHeight * .03),

          /// DaySelectionGrid مرتبطة بعدد الأيام (Days)
          BlocProvider.value(
            value: _quantityBloc,
            child: BlocBuilder<ProductQuantityBloc, ProductQuantityState>(
              builder: (context, state) {
                final int maxPreferredDays =
                    int.tryParse(state.quantity) ?? 0;

                return DaySelectionGrid(
                  // لازم تعدلي DaySelectionGrid في prefered_days_grid.dart
                  // عشان يستقبل selectedDays و onDayTapped
                  selectedDays: _selectedPreferredDays,
                  onDayTapped: (int dayIndex) {
                    setState(() {
                      if (_selectedPreferredDays.contains(dayIndex)) {
                        _selectedPreferredDays.remove(dayIndex);
                      } else {
                        if (maxPreferredDays > 0 &&
                            _selectedPreferredDays.length >=
                                maxPreferredDays) {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(backgroundColor: AppColors.primary,
                          //     content: Text(
                          //       'You can select up to $maxPreferredDays preferred days only.',
                          //     ),
                          //   ),
                          // );
                          showSnackBarWarning(context, screenWidth, screenHeight,  'You can select up to $maxPreferredDays preferred days only.');

                        } else {
                          _selectedPreferredDays.add(dayIndex);
                        }
                      }
                    });
                  },
                );
              },
            ),
          ),

          /// View Last Consumption button
          BuildInfoAndAddToCartButton(
            screenWidth,
            screenHeight,
            'View Last Consumption',
            false,
                () {
              showDialog(
                context: context,
                builder: (ctx) =>
                    ViewConsumptionHistoryAlert(disbute: widget.disbute),
              );
            },
            fromCouponsScreen: true,
          ),

          /// Next refill button - بياخد الأيام المفضلة المختارة
          NextRefillButton(
            selectedDays: _selectedPreferredDays.toList(),
          ),
        ],
      ),
    );
  }
}
