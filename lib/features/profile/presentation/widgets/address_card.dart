import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:newwwwwwww/features/profile/domain/models/client_address.dart';
import '../../../../../../core/theme/colors.dart';


Widget BuildCardAddress(BuildContext context,double screenHeight,double screenWidth,{bool work=false,bool fromCart=false,bool fromCouponCard=false,ClientAddress? address=null}){
  return  GestureDetector(
    onTap: (){

    },
    child: Padding(
      padding:  EdgeInsets.symmetric(vertical: fromCart?screenHeight*.01:screenHeight*.02),
      child: Container(
      //  height: screenHeight*.133,//ss
        padding:  EdgeInsets.symmetric(vertical: screenHeight*.03,horizontal:screenWidth*.04),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: work?Border.all(
            color: AppColors.BorderAnddividerAndIconColor, // 👈 Border color
            width:0.5,               // 👈 Optional: Border thickness
          ):Border.all(color: Colors.transparent, width: 0),
          color: work?Colors.transparent:fromCart?AppColors.backgrounHome:AppColors.whiteColor,
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
          fromCouponCard?SizedBox():  Text(address!=null?address.title!:'Home',style: TextStyle(
                fontWeight: FontWeight.w600,fontSize: screenWidth*.04,color:work?AppColors.textLight: AppColors.primary),),
            SizedBox(height: fromCouponCard?0:screenHeight*.02,),
            Row(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

              Row(crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                  'assets/images/profile/delivery/home.svg',
                  height: screenHeight * .03,
                              ),
                  SizedBox(width: screenWidth*.04),
                   Column(crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Text(address!=null?'Delivering to ${address.title!}':'Delivering to Work',style: TextStyle(fontWeight: FontWeight.w700,fontSize: screenWidth*.032),),

                       Text(address!=null?address.address!:'',style: TextStyle(fontWeight: FontWeight.w400,fontSize: screenWidth*.032,color: AppColors.greyDarktextIntExtFieldAndIconsHome),),

                     ],
                   ),
                ],
              ),
              //  SizedBox(width:fromCart?screenWidth*.2: screenWidth*.3,),
               address!=null? address.isDefault!?  Iconify(
                  MaterialSymbols.star,  // This uses the Material Symbols "star" icon
                  size: screenHeight*.03,
                  color: AppColors.primary,
                ):SizedBox():SizedBox(),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
