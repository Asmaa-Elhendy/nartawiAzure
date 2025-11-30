import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/cart/presentation/widgets/delivery_address_cart.dart';
import 'package:newwwwwwww/features/cart/presentation/widgets/outline_buttons.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/order_summary_card.dart';
import '../../../../core/theme/colors.dart';
import '../../../favourites/pesentation/widgets/favourite_product_card.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import '../../../profile/presentation/widgets/add_new_address_alert.dart';
import '../widgets/cart_store_card.dart';
import '../widgets/payment_method_alert.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
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
  List<String> products = [
    'assets/images/home/main_page/product.jpg',
    'assets/images/home/main_page/product.jpg',
    'assets/images/home/main_page/product.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
              disabledCart: 'cart',
            ),
            Positioned.fill(
              top: MediaQuery.of(context).padding.top + screenHeight * .1,
              child: Padding(
                padding: EdgeInsets.only(
             //     top: screenHeight * .03,//04 handle design shimaa
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
                              CartStoreCard(context, screenWidth, screenHeight),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * .02,
                                ),
                                child: Column(
                                  children: products
                                      .map(
                                        (p) => FavouriteProductCard(
                                          screenWidth: screenWidth,
                                          screenHeight: screenHeight,
                                          icon: p,
                                          fromCartScreen: true,
                                        ),
                                      )
                                      .toList(),
                                ),

                                //
                                // SizedBox(
                                //               height:screenHeight*.45,
                                //               child:ListView(shrinkWrap: true,
                                //                 children: [
                                //                   FavouriteProductCard(screenWidth: screenWidth,screenHeight:  screenHeight,
                                //                     icon: 'assets/images/home/main_page/product.jpg',fromCartScreen:true
                                //                   ),
                                //                   FavouriteProductCard(screenWidth: screenWidth,screenHeight:  screenHeight,
                                //                       icon: 'assets/images/home/main_page/product.jpg',fromCartScreen:true
                                //                   ), FavouriteProductCard(screenWidth: screenWidth,screenHeight:  screenHeight,
                                //                       icon: 'assets/images/home/main_page/product.jpg',fromCartScreen:true
                                //                   ),
                                //
                                //
                                //                 ],),
                                //             ),
                              ),
                              OrderSummaryCard(screenWidth, screenHeight),
                              OrderDeliveryCartWidget(),
                              BuildInfoAndAddToCartButton(
                                screenWidth,
                                screenHeight,
                                'Proceed To Checkout',
                                false,
                                () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => PaymentMethodAlert(),
                                  );
                                },
                              ),
                              RowOutlineButtons(
                                context,
                                screenWidth,
                                screenHeight,
                                'Continue Shopping',
                                'Clear Cart',
                                () {},
                                () {},
                              ),
                              SizedBox(height: screenHeight * .04),
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
      ),
    );
  }
}
