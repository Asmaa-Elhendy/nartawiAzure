import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/supplier_full_card.dart';

Widget ViewDetailSupplierAlert(BuildContext context,double screenWidth,double screenHeight){

      return

          Center(
            child: Material(
              color: AppColors.backgroundAlert,
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.94,
                height: MediaQuery.of(context).size.height * 0.45,
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: screenWidth*.04),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customCouponPrimaryTitle(
                            'Supplier Detail',
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
                    ),                    Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: BuildFullCardSupplier(
                            screenHeight,
                            screenWidth,
                            false,
                            fromCartScreen:true
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )

      ;

}