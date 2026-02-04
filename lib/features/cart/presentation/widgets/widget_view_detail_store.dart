import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';
import '../../../home/domain/models/supplier_model.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/supplier_full_card.dart';

Widget ViewDetailSupplierAlert(
  BuildContext context,
  double screenWidth,
  double screenHeight, {
  Supplier? supplier,
}) {

      return

          Center(
            child: Material(
              color: AppColors.backgroundAlert,
              borderRadius: BorderRadius.circular(16),
              child: IntrinsicHeight(
              //  width: MediaQuery.of(context).size.width * 0.94,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.94,
               //height: MediaQuery.of(context).size.height * 0.45,
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
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: screenWidth*.04,),
                          child: BuildFullCardSupplier(
                              screenHeight,
                              screenWidth, supplier ??
                              Supplier(id: 0, arName: 'Unknown Supplier', enName: 'Unknown Supplier', isActive: true, isVerified: false),
                              false,
                              fromCartScreen:true
                          ),
                        ),//j
                      ),
                    ),SizedBox(height: screenHeight*.03,)
                  ],
                ),
              ),
            ),
          ))

      ;

}