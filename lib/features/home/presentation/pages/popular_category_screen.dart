import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/supplier_full_card.dart';
import '../../../../../core/theme/colors.dart';
import '../widgets/background_home_Appbar.dart';
import '../widgets/build_ForegroundAppBarHome.dart';
import '../widgets/main_screen_widgets/suppliers/tapBarfirstPage.dart';

class PopularCategoryScreen extends StatefulWidget {
  String CategoryName;
  PopularCategoryScreen({required this.CategoryName});

  @override
  State<PopularCategoryScreen> createState() =>
      _PopularCategoryScreenState();
}

class _PopularCategoryScreenState extends State<PopularCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final topPadding = mediaQuery.padding.top;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
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
            title: widget.CategoryName,
            is_returned: true,
          ),
          Positioned.fill(
            top: topPadding + screenHeight * .1,
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * .03,bottom: screenHeight*.09),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TabBarFirstPage(),
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
