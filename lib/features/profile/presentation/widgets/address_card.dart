import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:newwwwwwww/features/profile/domain/models/client_address.dart';
import '../../../../../../core/theme/colors.dart';

// Helper function to remove duplicate address parts
String _removeDuplicateAddress(String address) {
  // Split the address by comma and trim each part
  final parts = address.split(',').map((part) => part.trim()).toList();
  
  // Remove consecutive duplicates
  final uniqueParts = <String>[];
  for (int i = 0; i < parts.length; i++) {
    if (i == 0 || parts[i] != parts[i - 1]) {
      uniqueParts.add(parts[i]);
    }
  }
  
  // Join back with comma and space
  return uniqueParts.join(', ');
}

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
              children: [
                SvgPicture.asset(
                  'assets/images/profile/delivery/home.svg',
                  height: screenHeight * .03,
                ),
                SizedBox(width: screenWidth*.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        address!=null?'Delivering to ${address.title!}':'Delivering to Work',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth*.032
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        address!=null?_removeDuplicateAddress(address.address!):'',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: screenWidth*.032,
                          color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth*.02),
                address!=null && address.isDefault!? 
                  Iconify(
                    MaterialSymbols.star,  // This uses the Material Symbols "star" icon
                    size: screenHeight*.03,
                    color: AppColors.primary,
                  ) : SizedBox(),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
