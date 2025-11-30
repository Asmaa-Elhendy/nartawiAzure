import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/delivery_information_report.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/order_summary_card.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/payment_information_report.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/reason_for_cancelation.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/seller_information_widget.dart';
import '../../../../core/theme/colors.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../widgets/order_card.dart';
import '../widgets/order_status_widget.dart';
import '../widgets/review_alert_dialog.dart';

class OrderDetailScreen extends StatefulWidget {
String orderStatus;
String paymentStatus;
OrderDetailScreen({required this.orderStatus,required this.paymentStatus});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen>  with SingleTickerProviderStateMixin {
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
            title: 'Order Detail',
            is_returned: true,
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            bottom: screenHeight*.05,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * .03,//04 handle design shimaa
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
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order #3',
                                      style: TextStyle(fontWeight: FontWeight.w600,fontSize: screenWidth*.045),
                                    ),SizedBox(height: screenHeight*.01,),
                                    Row(
                                      children: [
                                        SvgPicture.asset("assets/images/orders/calendar.svg",
                                          width: screenWidth * .042,color: AppColors.textLight,),
                                        SizedBox(width: screenWidth*.02,),
                                        Text('May 3, 2025 At 10.00 AM',style: TextStyle(fontWeight: FontWeight.w400,fontSize: screenWidth*.036),)
                                      ],
                                    ),
                                  ],
                                ),
                                BuildOrderStatus(screenHeight, screenWidth, widget.orderStatus,fromOrderDetail: false)
                              ],
                            ),
                            SizedBox(height: screenHeight*.01,),
                            OrderSummaryCard(screenWidth,screenHeight),
                            OrderDeliveryCard(screenWidth, screenHeight),
                            OrderPaymentCard(screenWidth, screenHeight,widget.paymentStatus),
                            OrderSellerInformationCard(screenWidth, screenHeight),
                           widget.orderStatus=='Delivered'?
                           BuildInfoAndAddToCartButton(screenWidth, screenHeight, 'Leave Review', false, (){
                             showDialog(
                               context: context,
                               builder: (ctx) =>
                                   ReviewAlertDialog(),
                             );
                           },fromOrderDetail: true):
                           widget.orderStatus=='Canceled'?
                           ReasonForCancellationCard(screenWidth, screenHeight)
                          : SizedBox(),
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
