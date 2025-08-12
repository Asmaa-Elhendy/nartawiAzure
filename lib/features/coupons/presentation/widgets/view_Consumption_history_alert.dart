import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/custom_text.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/cancel_order_buttons.dart';
import '../../../../core/theme/colors.dart';
import 'coupon_status_widget.dart';
import 'oulined_icon_button.dart';

class ViewConsumptionHistoryAlert extends StatefulWidget {
  const ViewConsumptionHistoryAlert({super.key});

  @override
  State<ViewConsumptionHistoryAlert> createState() =>
      _ViewConsumptionHistoryAlertState();
}

class _ViewConsumptionHistoryAlertState
    extends State<ViewConsumptionHistoryAlert> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      backgroundColor: AppColors.backgroundAlert,
      insetPadding: EdgeInsets.all(16), // controls distance from screen edges
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.94, // 90% screen width
        height: MediaQuery.of(context).size.height * 0.48, // adjust height
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * .02,
            horizontal: screenWidth * .05,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customCouponPrimaryTitle(
                      'Coupon Details',
                      screenWidth,
                      screenHeight,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        size: screenWidth * .05,
                        color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * .01),
                Container(
                  width: screenWidth,
                  // height: screenHeight*.1,
                  margin: EdgeInsets.only(bottom: screenHeight * .015),
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * .02,
                    horizontal: screenWidth * .03,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xffECEBEA), // 👈 Border color
                      width: 1, // 👈 Optional: Border thickness
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '1 Coupon Marked Used',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth * .036,
                        ),
                      ),
                      SizedBox(height: screenHeight * .01),
                      Text(
                        'Marked On March 5, 2025',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: screenWidth * .036,
                        ),
                      ),
                      SizedBox(height: screenHeight * .02),
                      Text(
                        'Marked By',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth * .036,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * .01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Company 1',
                              style: TextStyle(
                                fontSize: screenWidth * .036,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            CouponStatus(screenHeight, screenWidth, 'Vendor'),
                          ],
                        ),
                      ),
                      BuildOutlinedIconButton(
                        screenWidth,
                        screenHeight,
                        'Show Delivery Photos',
                        () {},
                      ),
                    ],
                  ),
                ),

                CancelOrderWidget(
                  context,
                  screenWidth,
                  screenHeight,
                  'Done',
                  'Dispute',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
