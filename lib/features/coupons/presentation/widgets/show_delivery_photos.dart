import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newwwwwwww/features/coupons/domain/models/coupons_models.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/custom_text.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/cancel_order_buttons.dart';
import '../../../../core/theme/colors.dart';

class ShowDeliveryPhotos extends StatefulWidget {
  WalletCoupon currentCoupon;
  ShowDeliveryPhotos(this.currentCoupon);

  @override
  State<ShowDeliveryPhotos> createState() =>
      _ShowDeliveryPhotosState();
}

class _ShowDeliveryPhotosState
    extends State<ShowDeliveryPhotos> {
  String imageUrl='';
  String formatDeliveredAt(DateTime? deliveredAt) {
    if (deliveredAt == null) return '';

    final localDate = deliveredAt.toLocal();

    final datePart = DateFormat('d MMM, yyyy').format(localDate);
    final timePart = DateFormat('h:mm a').format(localDate);

    return '$datePart at $timePart';
  }

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
                  child:   widget.currentCoupon.proofOfDelivery?.photoUrl==null||widget.currentCoupon.proofOfDelivery?.photoUrl==''?
                Image.asset(
                  'assets/images/coupons/dlivery.png',
                  fit: BoxFit.cover,
                )
                    :
                Image.network(
                  widget.currentCoupon.proofOfDelivery!.photoUrl! ,
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
                   '${widget.currentCoupon.proofOfDelivery!.location}',style: TextStyle(fontSize: screenWidth*.032,fontWeight: FontWeight.w700),),
             ),
              Text(  formatDeliveredAt(widget.currentCoupon.proofOfDelivery?.deliveredAt),
                  style: TextStyle(fontSize: screenWidth*.032,fontWeight: FontWeight.w500),),
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
