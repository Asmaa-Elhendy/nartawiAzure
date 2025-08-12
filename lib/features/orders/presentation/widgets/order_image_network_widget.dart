import 'package:flutter/material.dart';

Widget BuildNetworkOrderImage(double screenWidth,double screenHeight,String imageUrl,String localUrl){
  return   Container(
    //    width: screenWidth*.1,
    height: screenHeight * .09,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent
    ),
    child: ClipOval(
      child:
      imageUrl==null||imageUrl==''?
      Image.asset(
       localUrl,
        fit: BoxFit.cover,
      )
          :
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
  );
}