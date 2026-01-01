import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:newwwwwwww/features/coupons/presentation/screens/coupons_screen.dart';
import 'package:dio/dio.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../coupons/presentation/widgets/latest_soupon_tracker_carous_slider.dart';

class BuildCarousSlider extends StatefulWidget {
  const BuildCarousSlider({super.key});

  @override
  BuildCarousSliderState createState() => BuildCarousSliderState();
}

class BuildCarousSliderState extends State<BuildCarousSlider> {
  int _currentIndex = 0;

  final List<String> _imageList = [
    'assets/images/home/main_page/Coupon.png',
    'assets/images/home/main_page/Coupon.png',
    'assets/images/home/main_page/Coupon.png',
  ];

  // ✅ trigger rebuild for FutureBuilder
  int _reloadTick = 0;

  // ✅ Call this from MainScreen refresh
  void refresh() {
    setState(() => _reloadTick++);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    double slideHeight = screenHeight * .18;

    final List<Widget> sliderItems = [
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CouponsScreen()),
          );
        },
        child: Container(
          height: slideHeight,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: LatestCouponTrackerFromApi(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              reloadTick: _reloadTick, // ✅ changes when refresh
            ),
          ),
        ),
      ),

      ..._imageList.map((item) {
        return Container(
          height: slideHeight,
          alignment: Alignment.center,
          child: Image.asset(
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
            offset: const Offset(0, 2),
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
              viewportFraction: 1.0,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() => _currentIndex = index);
              },
            ),
          ),
          SizedBox(height: screenHeight * .02),
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
