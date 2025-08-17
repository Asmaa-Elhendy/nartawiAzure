import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/custom_text.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/cancel_order_buttons.dart';
import '../../../../core/theme/colors.dart';

class ShowDeliveryPhotos extends StatefulWidget {
  const ShowDeliveryPhotos({super.key});

  @override
  State<ShowDeliveryPhotos> createState() =>
      _ShowDeliveryPhotosState();
}

class _ShowDeliveryPhotosState
    extends State<ShowDeliveryPhotos> {
  String imageUrl='';
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      backgroundColor: AppColors.backgroundAlert,
      insetPadding: EdgeInsets.all(16), // controls distance from screen edges
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.94, // 90% screen width
        height: MediaQuery.of(context).size.height * 0.75, // adjust height
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * .02,
            horizontal: screenWidth * .05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customCouponPrimaryTitle(
                    'Show Delivery Photos',
                    screenWidth,
                    screenHeight,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      size: screenWidth * .05,
                      color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                    ),
                  ),
                ],
              ),
              Text(
                'Proof Of Order Delivery',
                style: TextStyle(
                  color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                  fontWeight: FontWeight.w400,
                  fontSize: screenWidth * .036,
                ),
              ),
              SizedBox(height: screenHeight * .01),

              Container(
                width: screenWidth,
                height: screenHeight*.45,
                margin: EdgeInsets.only(bottom: screenHeight * .015),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xffECEBEA), // 👈 Border color
                    width: 1, // 👈 Optional: Border thickness
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child:   imageUrl==null||imageUrl==''?
                Image.asset(
                  'assets/images/coupons/dlivery.png',
                  fit: BoxFit.cover,
                )
                    :
                Image.network(
                  imageUrl! ,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                        'assets/images/coupons/dlivery.png',
                        fit: BoxFit.cover,
                    );
                  },
                ),
                ),
              ),
             Padding(
               padding:  EdgeInsets.symmetric(vertical: screenHeight*.01),
               child: Text(''
                   'portsaid,23july',style: TextStyle(fontSize: screenWidth*.032,fontWeight: FontWeight.w700),),
             ),
              Text('23 dec ,2025  at 6:00 pm',style: TextStyle(fontSize: screenWidth*.032,fontWeight: FontWeight.w500),),
            SizedBox(height: screenHeight*.01,),

              CancelOrderWidget(
                  context,
                  screenWidth,
                  screenHeight,
                  'Done',
                  'Dispute',
                      (){
                    Navigator.pop(context);

                  },(){
                Navigator.pop(context);
              }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
