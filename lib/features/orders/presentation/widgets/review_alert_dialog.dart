import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../core/theme/colors.dart';
import 'cancel_order_buttons.dart';
import 'custom_text_field_alert.dart';

class ReviewAlertDialog extends StatefulWidget {
  const ReviewAlertDialog({super.key});

  @override
  State<ReviewAlertDialog> createState() => _ReviewAlertDialogState();
}

class _ReviewAlertDialogState extends State<ReviewAlertDialog> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      // Use Dialog instead of AlertDialog
      backgroundColor: AppColors.backgroundAlert,
      insetPadding: EdgeInsets.all(16), // controls distance from screen edges
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.94, // 90% screen width
        height: MediaQuery.of(context).size.height * 0.7, // adjust height
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * .02,
            horizontal: screenWidth * .05,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Leave Review',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * .04,
                      ),
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
                SizedBox(height: screenHeight * .01),

                buildReviewCard(
                  context,
                  screenWidth,
                  screenHeight,
                  'Order Experience',
                ),
                // SizedBox(height:screenHeight*.01 ),
                buildReviewCard(
                  context,
                  screenWidth,
                  screenHeight,
                  'Seller Experience',
                ),

                // SizedBox(height:screenHeight*.01 ),
                buildReviewCard(
                  context,
                  screenWidth,
                  screenHeight,
                  'Delivery Experience',
                ),
                // SizedBox(height:screenHeight*.01 ),
                CancelOrderWidget(
                  context,
                  screenWidth,
                  screenHeight,
                  'Leave Review',
                  'Cancel',(){    Navigator.pop(context);},
                    (){
                      Navigator.pop(context);
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildReviewCard(
  BuildContext context,
  double screenWidth,
  double screenHeight,
  String title,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: screenWidth * .04,
        ),
      ),
      RatingBar(
        initialRating: 3,
        maxRating: 5,glow: false,
        allowHalfRating: true,
        itemSize: screenWidth*.07,
        itemPadding: EdgeInsetsGeometry.symmetric(horizontal: screenWidth*.01,vertical: screenHeight*.01),
        ratingWidget: RatingWidget(
            full: Icon( Icons.star,color: Colors.amber,),
            half: Icon( Icons.star_half,color:Colors.amber,),
            empty: Icon( Icons.star_border,color:Colors.amber,)),
            onRatingUpdate: (value) => debugPrint('$value'),
      ),
      CustomTextFieldAlert('Write Your Review Here'),
    ],
  );
}
