import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class SinglePaymentCard extends StatefulWidget {
  final int groupValue;
  final ValueChanged<int?> onChanged;
  final String mainTitle;
  final String firstText;
  final String secondText;
  final int value;

  const SinglePaymentCard({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.mainTitle,
    required this.firstText,
    required this.secondText,
    required this.value
  });

  @override
  State<SinglePaymentCard> createState() => _SinglePaymentCardState();
}

class _SinglePaymentCardState extends State<SinglePaymentCard> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth= MediaQuery.of(context).size.width;

    final textStyle = TextStyle(
      color: AppColors.greyDarktextIntExtFieldAndIconsHome,
      fontWeight: FontWeight.w300,
      fontSize: screenWidth*.036, // 👈 more consistent than screenWidth scaling
    );

    return Container(
      padding:  EdgeInsets.symmetric(vertical: screenHeight*.02, horizontal: screenWidth*.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.BorderAnddividerAndIconColor,
          width: 0.5,
        ),
        color: AppColors.whiteColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio<int>(
            value: widget.value,
            groupValue: widget.groupValue,
            activeColor: AppColors.primary,
            onChanged: widget.onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // 👈 يشيل الفراغ فوق وتحت
            visualDensity: VisualDensity.compact, // 👈 يصغر المسافة العمودية

          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Padding(
                   padding:  EdgeInsets.symmetric(vertical: screenHeight*.01),
                   child: Text(
                   widget.mainTitle,
                    style: TextStyle(fontSize: screenWidth*.034, fontWeight: FontWeight.w500),
                                   ),
                 ),
                Text(widget.firstText, style: textStyle),
               widget.secondText!=''?  Text(
                  widget.secondText,
                  style: textStyle,
                ):SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
