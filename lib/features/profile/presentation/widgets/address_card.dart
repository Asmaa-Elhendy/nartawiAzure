import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:newwwwwwww/features/home/presentation/screens/suppliers/supplier_detail.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/build_row_raing.dart';

import '../../../../../../core/theme/colors.dart';


Widget BuildCardAddress(BuildContext context,double screenHeight,double screenWidth,{bool work=false}){
  return  GestureDetector(
    onTap: (){

    },
    child: Padding(
      padding:  EdgeInsets.symmetric(vertical: screenHeight*.02),
      child: Container(
      //  height: screenHeight*.133,//ss
        padding:  EdgeInsets.symmetric(vertical: screenHeight*.03,horizontal: screenWidth*.04),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: work?Border.all(
            color: AppColors.BorderAnddividerAndIconColor, // 👈 Border color
            width:0.5,               // 👈 Optional: Border thickness
          ):Border.all(color: Colors.transparent, width: 0),
          color: work?Colors.transparent:AppColors.whiteColor,
          // boxShadow: [
          //   BoxShadow(
          //     color:AppColors.shadowColor, // ظل خفيف
          //     offset: Offset(0, 2),
          //     blurRadius: 8,
          //     spreadRadius: 0,
          //   ),
          // ],

        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(work?'Work':'Home',style: TextStyle(
                fontWeight: FontWeight.w600,fontSize: screenWidth*.04,color:work?AppColors.textLight: AppColors.primary),),
            SizedBox(height: screenHeight*.02,),
            Row(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

              SvgPicture.asset(
              'assets/images/profile/delivery/home.svg',
              height: screenHeight * .055,
            ),
              SizedBox(width: screenWidth*.04),
               Column(crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Text('Delivering to Home',style: TextStyle(fontWeight: FontWeight.w700,fontSize: screenWidth*.032),),

                   Text('portsaid,23july',style: TextStyle(fontWeight: FontWeight.w400,fontSize: screenWidth*.032,color: AppColors.greyDarktextIntExtFieldAndIconsHome),),

                 ],
               ),
                SizedBox(width: screenWidth*.3,),
           work?SizedBox():     Iconify(
                  MaterialSymbols.star,  // This uses the Material Symbols "star" icon
                  size: screenHeight*.038,
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
