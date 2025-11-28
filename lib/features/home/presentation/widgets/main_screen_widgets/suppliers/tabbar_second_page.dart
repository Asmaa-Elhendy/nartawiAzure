import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/build_row_of_stars_ratings.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/supplier_reaings_card.dart';

import '../../../../../../core/theme/colors.dart';
import '../../../../../../core/theme/text_styles.dart';
import 'build_info_button.dart';
import 'build_row_raing.dart';
import 'build_verified_widget.dart';

class TabBarSecondPage extends StatefulWidget {
  @override
  State<TabBarSecondPage> createState() => _TabBarSecondPageState();
}

class _TabBarSecondPageState extends State<TabBarSecondPage> {
  List<int> items = [1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.02,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          BuildSupplierRatingCard(screenWidth, screenHeight, items,'Rating Summary'),
          Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0.02,
            ),
            child: Text('Customer Reviews',style: TextStyle(color: AppColors.textLight,fontWeight: FontWeight.w600,fontSize:screenWidth * .04,),),
          ),
          Center(
            child: SvgPicture.asset(
              'assets/images/home/main_page/supplier_detail/empty-state.svg',
             // height: screenHeight*.1,
            ),
          ),
     //   SizedBox(height: screenHeight*.2,)
        ],
      ),
    );
  }
}
