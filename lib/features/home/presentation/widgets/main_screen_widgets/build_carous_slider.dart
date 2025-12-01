  import 'package:flutter/material.dart';
  import 'package:carousel_slider/carousel_slider.dart';
  import 'package:dots_indicator/dots_indicator.dart';
import 'package:newwwwwwww/features/coupons/presentation/screens/coupons_screen.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../coupons/presentation/widgets/latest_coupon_tracker.dart';
import '../../../../coupons/presentation/widgets/latest_soupon_tracker_carous_slider.dart';

  class BuildCarousSlider extends StatefulWidget {
    @override
    _BuildCarousSliderState createState() => _BuildCarousSliderState();
  }

  class _BuildCarousSliderState extends State<BuildCarousSlider> {
    int _currentIndex = 0;
    final List<String> _imageList = [
      'assets/images/home/main_page/Coupon.png',
      'assets/images/home/main_page/Coupon.png',
      'assets/images/home/main_page/Coupon.png',
    ];

    @override
    Widget build(BuildContext context) {
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;

      /// كل slide بياخد نفس الارتفاع بالظبط
      double slideHeight = screenHeight * .18;//.15 edit

      /// هنا بنحط tracker + الصور جوه Containers بنفس الارتفاع
      final List<Widget> sliderItems = [
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CouponsScreen()));

          },
          child: Container(
            height: slideHeight,
            alignment: Alignment.center,
            padding: EdgeInsets.zero,
            // padding: EdgeInsets.only(
            //     left: screenWidth * .02,
            //     right: screenWidth * .02,
            //     top: screenHeight * .008
            // ),
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: latestCouponTrackerCarousSlider(screenWidth, screenHeight,(){
                // buy new coupon from same supplier ans same quantity
                setState(() {
                  //newCoupon=true;
                });
              }),
            ),
          ),
        ),

        ..._imageList.map((item) {
          return Container(
            height: slideHeight,
            alignment: Alignment.center,
            child: Image.asset(
            //  height: screenHeight*.12,
              item,
              fit: BoxFit.contain,
            ),
          );
        }).toList(),
      ];

      return Container(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * .01,
          horizontal: screenWidth * .04,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.secondaryColorWithOpacity8,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              offset: Offset(0, 2),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            CarouselSlider(
              items: sliderItems,
              options: CarouselOptions(
                height: slideHeight,
          //k      autoPlay: true,
                viewportFraction: 1.0,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
            SizedBox(height: screenHeight * .02), //05 edit
            DotsIndicator(
              dotsCount: sliderItems.length,
              position: _currentIndex.toDouble(),
              decorator: DotsDecorator(
                activeColor: AppColors.secondary,
                color: AppColors.Secondary48,
                size: const Size.square(8.0),
                spacing: EdgeInsets.symmetric(horizontal: screenWidth * .01),
                activeSize: const Size(8.0, 8.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
