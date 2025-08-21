import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/healthicons.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/components/coupon_status_widget.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';
import '../bloc/notification_bloc/bloc.dart';
import '../bloc/notification_bloc/event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notification_bloc/state.dart';

class NotificationCard extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final NotificationItem notification;

  const NotificationCard({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: screenWidth * .04,
        left: screenWidth * .04,
        bottom: screenHeight * .01,
      ),
      child: Stack(
        children: [
          // Main card container
          Container(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * .02,
              horizontal: screenWidth * .03,
            ),
            decoration: BoxDecoration(
              color: notification.isRead
                  ? AppColors.BorderAnddividerAndIconColor.withValues(alpha: 0.16)
                  : AppColors.secondaryColorWithOpacity8,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(
                color: notification.isRead
                    ? AppColors.BorderAnddividerAndIconColor
                    : AppColors.blueBorder,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: screenWidth * .04),
                Padding(
                  padding: EdgeInsets.only(right: screenWidth * .03),
                  child: SizedBox(
                    width: screenWidth * .03,
                    height: screenHeight * .03,
                    child: Transform.scale(
                      scale: .9,
                      child: Checkbox(
                        value: notification.isChecked,
                        activeColor: notification.isRead
                            ? AppColors.textLight
                            : AppColors.secondary,
                        onChanged: (value) {
                          context.read<NotificationBloc>().add(
                            ToggleNotificationCheck(
                              notification.id,
                              value ?? false,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Iconify(
                  Healthicons.award_trophy_outline,
                  size: screenWidth * .06,
                  color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                ),
                SizedBox(width: screenWidth * .02),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customCouponAlertTitle(
                        notification.title,
                        screenWidth,
                        screenHeight,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * .01,
                        ),
                        child: Text(
                          notification.description,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: screenWidth * .034,
                            color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Yesterday at 10:44 AM',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: screenWidth * .034,
                              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                            ),
                          ),
                          CouponStatus(
                            screenHeight,
                            screenWidth,
                            notification.isRead ? 'Read' : 'New',
                            fromNotification: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Colored left strip
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: Container(
              width: 7,
              decoration: BoxDecoration(
                color: notification.isRead
                    ? AppColors.greyDarktextIntExtFieldAndIconsHome.withValues(alpha: .35)
                    : AppColors.secondary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
