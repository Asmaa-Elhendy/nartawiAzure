import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/cart/presentation/widgets/payment_radio_card.dart';
import '../../../../core/theme/colors.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';
import '../../../orders/presentation/widgets/cancel_order_buttons.dart';

class PaymentMethodAlert extends StatefulWidget {
  const PaymentMethodAlert({super.key});

  @override
  State<PaymentMethodAlert> createState() => _PaymentMethodAlertState();
}

class _PaymentMethodAlertState extends State<PaymentMethodAlert> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    return Dialog(
      backgroundColor: AppColors.backgroundAlert,
      insetPadding: const EdgeInsets.all(16),
      child: SizedBox(
        width: screenWidth * 0.94,
     //   height: screenHeight * 0.68,
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * .04,
            bottom: screenHeight * .02,
            left: screenWidth * .05,
            right: screenWidth * .05,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// العنوان مع زر الإغلاق
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customCouponPrimaryTitle(
                      'Payment Method',
                      screenWidth,
                      screenHeight,
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        size: screenWidth * .05,
                        color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                      ),
                    ),
                  ],
                ),

                /// الوصف
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * .01),
                  child: Text(
                    'eWallet Or Cash On Delivery',
                    style: TextStyle(
                      color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                      fontWeight: FontWeight.w300,
                      fontSize: screenWidth * .036,
                    ),
                  ),
                ),

                /// كروت الاختيار
                const RadioPaymentCard(),
                CancelOrderWidget(
                  context,
                  screenWidth,
                  screenHeight,
                  'Confirm',
                  'Cancel',
                      () {
                    Navigator.pop(context); //send dispute to api
                  },
                      () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
