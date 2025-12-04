import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/profile/presentation/widgets/generate_qr_alert.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/theme/colors.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';
import '../pages/scan_qr.dart';
import 'add_transfer_alert.dart';
import 'outline_button_e_wallet.dart';

Widget eWalletCard(
  BuildContext context,
  double screenWidth,
  double screenHeight,
) {
  return Container(
    width: screenWidth,
    padding: EdgeInsets.symmetric(
      vertical: screenHeight * .02,
      horizontal: screenWidth * .04,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: AppColors.whiteColor,
    ),
    child: Column(
      children: [
        buildRowButtons(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            leftTitle: 'Payment QR',
            rightTitle: 'Scan QR',
            leftIcon: 'assets/images/profile/e_wallet/Qr.svg',
            rightIcon: 'assets/images/profile/e_wallet/Qr.svg',
            fun1: (){
              showDialog(
                context: context,
                builder: (ctx) =>  GenerateQrAlert()
              );

            },
            fun2: ()async{
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QRViewExample()),
              );

              if (result != null) {
                print("Scanned Result: $result");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      backgroundColor: AppColors.backgrounHome,
                      content: Text("Scanned: $result",style:  TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w400,
                    fontSize: screenWidth * .035,
                  ),)),
                );
                showDialog(
                  context: context,
                  builder: (ctx) =>
                      TransferAlertDialog(),
                );
              }

            }
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight*.02,),
            customCouponAlertTitle('Total Balance', screenWidth, screenHeight),
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
              child: Text(
                'QAR 1000,00',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: .046 * screenWidth,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        buildRowButtons(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          leftTitle: 'Top-up',
          rightTitle: 'Transfer',
          leftIcon: 'assets/images/profile/e_wallet/top-up.svg',
          rightIcon: 'assets/images/profile/e_wallet/transfer.svg',
          fun1: (){},
          fun2: (){
            showDialog(
              context: context,
              builder: (ctx) =>
                  TransferAlertDialog(),
            );
          }
        ),
      ],
    ),
  );
}
