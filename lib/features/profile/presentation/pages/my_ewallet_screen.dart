import 'package:calendar_date_picker2/calendar_date_picker2.dart';
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
   DateTime? selectedFromDate;
  DateTime? selectedToDate;
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
            bottom: screenHeight*.05,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * .03,//04 handle design shimaa
                bottom: screenHeight * .1,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(//
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
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customCouponAlertTitle(
                                'From',
                                screenWidth,
                                screenHeight,
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    final now = DateTime.now();

                                    final results = await showCalendarDatePicker2Dialog(
                                      context: context,
                                      value: [
                                        selectedFromDate ?? DateTime(now.year , now.month, now.day),
                                      ],
                                      dialogSize: Size(screenWidth * 0.9, screenHeight * 0.55), // 👈 وسّعنا الـ dialog
                                      borderRadius: BorderRadius.circular(16),
                                      config: CalendarDatePicker2WithActionButtonsConfig(
                                        calendarType: CalendarDatePicker2Type.single,

                                        // 🎨 ألوان الـ Calendar
                                        selectedDayHighlightColor: AppColors
                                            .primary, // بدل الموف استخدم اللون الأساسي بتاعك (تقدر تغيّره)
                                        selectedDayTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * .035,
                                        ),
                                        dayTextStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: screenWidth * .034,
                                        ),
                                        weekdayLabelTextStyle: TextStyle(
                                          color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenWidth * .03,
                                        ),
                                        yearTextStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: screenWidth * .032,
                                        ),
                                        controlsTextStyle: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenWidth * .035,
                                        ),

                                        // لو حابب تتحكم في padding
                                        //    daySplashRadius: 18,
                                      ),
                                    );


                                  },
                                  child: buildFilterDateWidget(screenHeight, screenWidth,)),
                            ],
                          ),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customCouponAlertTitle(//ks
                                'To',
                                screenWidth,
                                screenHeight,
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    final now = DateTime.now();

                                    final results = await showCalendarDatePicker2Dialog(
                                      context: context,
                                      value: [
                                        selectedToDate ?? DateTime(now.year , now.month, now.day),
                                      ],
                                      dialogSize: Size(screenWidth * 0.9, screenHeight * 0.55), // 👈 وسّعنا الـ dialog
                                      borderRadius: BorderRadius.circular(16),
                                      config: CalendarDatePicker2WithActionButtonsConfig(
                                        calendarType: CalendarDatePicker2Type.single,

                                        // 🎨 ألوان الـ Calendar
                                        selectedDayHighlightColor: AppColors
                                            .primary, // بدل الموف استخدم اللون الأساسي بتاعك (تقدر تغيّره)
                                        selectedDayTextStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * .035,
                                        ),
                                        dayTextStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: screenWidth * .034,
                                        ),
                                        weekdayLabelTextStyle: TextStyle(
                                          color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenWidth * .03,
                                        ),
                                        yearTextStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: screenWidth * .032,
                                        ),
                                        controlsTextStyle: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenWidth * .035,
                                        ),

                                        // لو حابب تتحكم في padding
                                        //    daySplashRadius: 18,
                                      ),
                                    );


                                  },
                                  child: buildFilterDateWidget(screenHeight, screenWidth)),
                            ],
                          ),

                        ],
                      ),
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
