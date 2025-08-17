import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newwwwwwww/features/profile/presentation/widgets/filter_date_widget.dart';
import 'package:newwwwwwww/features/profile/presentation/widgets/transaction_card.dart';
import '../../../../core/theme/colors.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../widgets/e_wallet_card.dart';

class MyeWalletScreen extends StatefulWidget {
  const MyeWalletScreen({super.key});

  @override
  State<MyeWalletScreen> createState() => _MyeWalletScreenState();
}

class _MyeWalletScreenState extends State<MyeWalletScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? imageUrl = null;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      // 🔥 يخلي الجسم يبدأ من أعلى الشاشة خلف الـ AppBar
      backgroundColor: Colors.transparent,
      // في حالة الصورة في الخلفية
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            color: AppColors.backgrounHome,
          ),
          buildBackgroundAppbar(screenWidth),
          BuildForegroundappbarhome(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            title: 'My e-Wallet',
            is_returned: true, //edit back from orders
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * .04,
                bottom: screenHeight * .1,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * .06,
                    bottom: screenHeight * .04,
                    right: screenWidth * .06,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      eWalletCard(context, screenWidth, screenHeight),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * .02,
                        ),
                        child: customCouponAlertTitle(
                          'Transaction History',
                          screenWidth,
                          screenHeight,
                        ),
                      ),
                      buildFilterDateWidget(screenHeight, screenWidth),
                      SizedBox(height:screenHeight*.01),
                      TransactionCard(screenHeight, screenWidth),
                      TransactionCard(screenHeight, screenWidth),
                      TransactionCard(screenHeight, screenWidth)

                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
