import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newwwwwwww/features/cart/presentation/widgets/delivery_address_cart.dart';
import 'package:newwwwwwww/features/cart/presentation/widgets/outline_buttons.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/delivery_information_report.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/order_summary_card.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/seller_information_widget.dart';
import '../../../../core/theme/colors.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import '../../../orders/presentation/widgets/cancel_alert_dialog.dart';
import '../../../profile/presentation/widgets/address_card.dart';

class CartScreen extends StatefulWidget {


  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>  with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
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
            title: 'Your Cart',
            is_returned: true,
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
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * .06,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            OrderSummaryCard(screenWidth,screenHeight),
                            OrderDeliveryCartWidget(context, screenWidth, screenHeight),
                            BuildInfoAndAddToCartButton(screenWidth, screenHeight, 'Proceed To Checkout', false, (){

                            }),
                            RowOutlineButtons(context, screenWidth, screenHeight,   'Continue Shopping','Clear Cart',(){},(){}),
                            SizedBox(height: screenHeight*.04)


                          ],
                        ),
                      ),
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
