import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/colors.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';

class GenerateQrAlert extends StatefulWidget {
  @override
  State<GenerateQrAlert> createState() => _GenerateQrAlertState();
}

class _GenerateQrAlertState extends State<GenerateQrAlert> {
  String data = "https://example.com"; // البيانات اللي عايز تولدها كـ QR


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      backgroundColor: AppColors.backgroundAlert,
      insetPadding: EdgeInsets.all(16), // controls distance from screen edges
      child: SizedBox(
        width: screenWidth * 0.94,
        // 90% screen width
        height: screenHeight * 0.34,
        // adjust height
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
                      'My Payment QR ',
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

                Center(
                  child: QrImageView(
                    data: data,
                    version: QrVersions.auto,
                    size: screenWidth*.35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {

    super.dispose();
  }
}
