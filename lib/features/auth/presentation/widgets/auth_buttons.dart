import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theme/colors.dart';

Widget AuthButton(
  double width,
  double height,
  String title,
  void Function()? fun,
) {
  return InkWell(
    onTap: fun,
    child: Padding(
      padding: EdgeInsets.symmetric(
        //   horizontal: widget.width * .04,
        vertical: height * .02,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              //  width:  widget.width * .38,
              height: height * .07,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget CustomLoginButtons(
  double width,
  double height,
  String title,
  void Function()? fun,
) {
  return Row(
    children: [
      InkWell(
        onTap: fun,
        child: Container(
          width: width * .23,
          height: height * .05,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.blueBorder, // Border color
              width: 2, // Border width
            ),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget OutlineAuthButton(
  double width,
  double height,
  String title,
  void Function()? fun, {
  bool fromDelivery = false,
  String icon = '',
}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      //   horizontal: widget.width * .04,
      vertical: height*.01,//fromDelivery ? height * .01 : height * .02,
    ),
    child: InkWell(
      onTap: fun,
      child: Container(
        //   width:  width,
        height: height*.06,//fromDelivery ? height * .06 : height * .07,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.blueBorder, // 👈 Border color
            width: 1.5, // 👈 Optional: Border thickness
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              fromDelivery
                  ? SvgPicture.asset(
                      icon,
                      // height: screenHeight*.1,
                    )
                  : SizedBox(),
              SizedBox(width: fromDelivery ? width * .02 : 0),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: width * .036,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
