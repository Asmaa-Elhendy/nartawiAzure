import 'package:flutter/material.dart';
import '../../../../../../core/theme/colors.dart';


Widget BuildFullCardProfile(BuildContext context,double screenHeight,double screenWidth){
  String imageUrl='';
  //    padding:  EdgeInsets.symmetric(horizontal: screenWidth*.04),
  return  Container(
     height: screenHeight*.33,
    padding:  EdgeInsets.symmetric(vertical: screenHeight*.01,horizontal: screenWidth*.02),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: AppColors.whiteColor,
  

    ),
    child: Center(
      child: Container(
        //   width: widget.screenWidth * .04,
        // الحجم العرض
        height: screenHeight * .22,
        // الحجم الارتفاع
        decoration: BoxDecoration(
          color: AppColors.backgrounHome, // لون الخلفية
          shape: BoxShape.circle, // يجعله دائري
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: imageUrl==''?Image.asset(
          "assets/images/profile/img.png",
          height: screenHeight * .03,
          fit: BoxFit.cover,
        ):
        Image.network(
        imageUrl! ,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
              'assets/images/orders/order.jpg'
            //  fit: BoxFit.cover,
          );
        },
      ),
      ),
    ),
  );
}

