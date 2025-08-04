  import 'package:flutter/material.dart';
  import 'package:carousel_slider/carousel_slider.dart';
  import 'package:dots_indicator/dots_indicator.dart';

import '../../../../core/theme/colors.dart';

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
    ]; // Example image list

    @override
    Widget build(BuildContext context) {
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;
      return  Container(
        padding:  EdgeInsets.symmetric(vertical: screenHeight*.01,horizontal: screenWidth*.04),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.secondaryColorWithOpacity8,
            boxShadow: [
              BoxShadow(
                color:AppColors.shadowColor, // ظل خفيف
                offset: Offset(0, 2),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],

          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CarouselSlider(
                items: _imageList.map((item,) {
                  return Builder(
                    builder: (BuildContext context) {
                      return  Image.asset(item,);
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: screenHeight*.15,
                  autoPlay: true,
                  viewportFraction: 1.0, // يخلي العنصر الحالي فقط هو الظاهر
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
              SizedBox(height: screenHeight*.05),
              DotsIndicator(
                dotsCount: _imageList.length,
                position: _currentIndex.toDouble(),
                decorator: DotsDecorator(
                  activeColor:AppColors.secondary,
                  color: AppColors.Secondary48,
                  size: const Size.square(9.0),
                  spacing:  EdgeInsets.symmetric(horizontal: screenWidth*.01), // <--- This controls the space between dots
                  activeSize: const Size(9.0, 9.0),
                  activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
              ),

            ],
          ),
      )
      ;
    }
  }