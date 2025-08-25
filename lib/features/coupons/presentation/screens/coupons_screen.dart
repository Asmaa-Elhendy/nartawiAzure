import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/add_coupon_widget.dart';
import '../../../../core/theme/colors.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_bloc.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../widgets/coupon_card.dart';

class CouponsScreen extends StatefulWidget {
  final bool fromViewButton;

  CouponsScreen({this.fromViewButton=false});

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final ProductQuantityBloc _quantityBloc;

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
            title: 'Coupons',
            is_returned:widget.fromViewButton , //edit back from orders
            disabledGallon: 'Coupons',

          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * .04,
                bottom: screenHeight * .1,
              ),
              child: SingleChildScrollView(
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
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Coupons',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth * .045,
                                ),
                              ),
                              AddCoupon(context, screenWidth, screenHeight)
                            ],
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * .01,
                            ),
                            child: Text(
                              'Manage your water coupon bundles and delivery preferences',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth * .036,
                                color: AppColors
                                    .greyDarktextIntExtFieldAndIconsHome,
                              ),
                            ),
                          ),
                          CouponeCard(),

                          CouponeCard(disbute:true),
                          SizedBox(height: screenHeight * .04),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
