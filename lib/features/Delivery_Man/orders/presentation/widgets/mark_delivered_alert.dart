import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/theme/colors.dart';

class GpsRequiredAlert extends StatelessWidget {
  final VoidCallback onOpenCamera;
  final VoidCallback onCancel;

  const GpsRequiredAlert({
    super.key,
    required this.onOpenCamera,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: screenWidth * 0.94,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * .04,
          vertical: screenHeight * .018,
        ),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ================= Header =================
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Confirm delivery',
                    style: TextStyle(
                      fontSize: screenWidth * .042,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    onCancel();
                  },
                  child: Icon(
                    Icons.close,
                    size: screenWidth * .055,
                    color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                  ),
                ),
              ],
            ),

            SizedBox(height: screenHeight * .012),

            // ================= Message =================
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * .02),
              child: Text(
                '“GPS Required To Confirm Order.”',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * .036,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),

            SizedBox(height: screenHeight * .02),

            // ================= Buttons =================
            Row(
              children: [
                // ===== Open Camera (GRADIENT) =====
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.pop(context);
                      onOpenCamera();
                    },
                    child: Container(
                      height: screenHeight * .055,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient, // ✅ نفس Mark As Delivered
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_camera_outlined,
                            size: screenWidth * .05,
                            color: AppColors.whiteColor,
                          ),
                          SizedBox(width: screenWidth * .02),
                          Text(
                            'Open Camera',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: screenWidth * .034,
                              fontWeight: FontWeight.w700,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(width: screenWidth * .03),

                // ===== Cancel (Outlined) =====
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.pop(context);
                      onCancel();
                    },
                    child: Container(
                      height: screenHeight * .055,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.BorderAnddividerAndIconColor,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: screenWidth * .034,
                            fontWeight: FontWeight.w700,
                            color:
                            AppColors.greyDarktextIntExtFieldAndIconsHome,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
