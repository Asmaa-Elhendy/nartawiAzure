import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newwwwwwww/features/profile/presentation/widgets/quantity_increase_Decrease.dart';
import '../../../../core/theme/colors.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';
import '../../../coupons/presentation/widgets/label_rounded_icon.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_bloc.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_event.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_state.dart';


class SettingCard extends StatefulWidget {
  bool disbute;
  SettingCard({this.disbute=false});
  @override
  State<SettingCard> createState() => _SettingCardState();
}

class _SettingCardState extends State<SettingCard> {
  String imageUrl = '';
  bool _isSwitched = false; // Initial state of the switch
  late final ProductQuantityBloc _quantityBloc;
  late final TextEditingController _quantityController;

  @override
  void initState() {
    _quantityBloc = ProductQuantityBloc(
      calculateProductPrice: CalculateProductPrice(),
      basePrice: 100.0,
    );

    _quantityController = TextEditingController(text: '1');


    super.initState();
  }

  void dispose() {
    _quantityController.dispose();
    _quantityBloc.close();
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

          Padding(
            padding: EdgeInsets.only(top: screenHeight * .01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customCouponPrimaryTitle(
                  'Low Coupon Alerts',
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
          customCouponAlertSubTitle('Get notified when your coupon balance is running low', screenWidth, screenHeight),


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

        ],
      ),
    );
  }
}
