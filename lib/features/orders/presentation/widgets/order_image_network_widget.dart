import 'package:flutter/material.dart';

Widget BuildNetworkOrderImage(double screenWidth,double screenHeight,String imageUrl,String localUrl){
  // Validate imageUrl - check if it's null, empty, or invalid
  bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    
    // Check for common test/placeholder values
    if (url.contains('TEST_') || 
        url.contains('test_') || 
        url.contains('PLACEHOLDER') ||
        url.contains('placeholder') ||
        url.contains('LOGO_URL') ||  
        url.startsWith('file:///TEST_') ||
        url.startsWith('file:///TEST_LOGO_') ||  
        !url.startsWith('http') && !url.startsWith('https')) {
      return false;
    }
    
    return true;
  }
  
  return   Container(
    //    width: screenWidth*.1,
    height: screenHeight * .09,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent
    ),
    child: ClipOval(
      child:
      !isValidImageUrl(imageUrl)?
      Image.asset(
       localUrl,
        fit: BoxFit.cover,
      )
          :
      Image.network(
        imageUrl ,
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