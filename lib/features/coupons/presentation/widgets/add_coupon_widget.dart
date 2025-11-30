import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/home/presentation/pages/all_product_screen.dart';
import '../../../../core/theme/colors.dart';

Widget AddCoupon(BuildContext context,double screenWidth,double screenHeight){
  return  InkWell(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>AllProductScreen()));//where filter=coupons

    },
    child: Container(
      width: screenWidth*.1, // Set the desired width
     // height: screenHeight*.1, // Set the desired height
      decoration: BoxDecoration(
          shape: BoxShape.circle, // Makes the container circular
          border: Border.all(
            color: AppColors.primary, // Background color of the circle

          )),
      child: Center(
        child:Icon(Icons.add,color: AppColors.primary,size: screenWidth*.065,),
      ),
    ),
  );
}