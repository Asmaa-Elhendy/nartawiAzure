import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newwwwwwww/features/coupons/domain/models/coupons_models.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/custom_text.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/show_delivery_photos.dart';
import 'package:newwwwwwww/features/orders/presentation/widgets/cancel_order_buttons.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/components/coupon_status_widget.dart';
import 'dispute_alert.dart';
import 'oulined_icon_button.dart';

class ViewConsumptionHistoryAlert extends StatefulWidget {
  final bool disbute;

  /// ✅ دايمًا list (ممكن فاضية)
  final List<WalletCoupon> currentCoupon;

  const ViewConsumptionHistoryAlert({
    super.key,
    required this.disbute,
    required this.currentCoupon,
  });

  @override
  State<ViewConsumptionHistoryAlert> createState() =>
      _ViewConsumptionHistoryAlertState();
}

class _ViewConsumptionHistoryAlertState extends State<ViewConsumptionHistoryAlert> {
  String _formatMarkedOn(String? iso) {
    if (iso == null || iso.trim().isEmpty) return '-';
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '-';
    return DateFormat('MMMM d, yyyy').format(dt.toLocal()); // March 5, 2025
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final bool hasCoupons = widget.currentCoupon.isNotEmpty;
    final WalletCoupon? first = hasCoupons ? widget.currentCoupon.first : null;

    return Dialog(
      backgroundColor: AppColors.backgroundAlert,
      insetPadding: const EdgeInsets.all(16),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.94,
        height: widget.disbute ? screenHeight * .6 : screenHeight * 0.5,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * .02,
            horizontal: screenWidth * .05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customCouponPrimaryTitle(
                    'Coupon Details',
                    screenWidth,
                    screenHeight,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      size: screenWidth * .05,
                      color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * .01),

              // ✅ لو مفيش Coupons: اعرض رسالة بدل ما تبوّظ
              if (!hasCoupons)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline,
                            size: screenWidth * .10,
                            color: AppColors.greyDarktextIntExtFieldAndIconsHome),
                        SizedBox(height: screenHeight * .015),
                        Text(
                          'No consumption history yet',
                          style: TextStyle(
                            fontSize: screenWidth * .04,
                            fontWeight: FontWeight.w600,
                            color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                          ),
                        ),
                        SizedBox(height: screenHeight * .008),
                        Text(
                          'This bundle has no marked-used coupons.',
                          style: TextStyle(
                            fontSize: screenWidth * .034,
                            fontWeight: FontWeight.w400,
                            color: AppColors.BorderAnddividerAndIconColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * .03),
                        CancelOrderWidget(
                          context,
                          screenWidth,
                          screenHeight,
                          'Done',
                          'Dispute',
                              () => Navigator.pop(context),
                              () {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (ctx) => DisputeAlertDialog(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                // ✅ Normal content (safe)
                Container(
                  width: screenWidth,
                  margin: EdgeInsets.only(bottom: screenHeight * .015),
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * .02,
                    horizontal: screenWidth * .03,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffECEBEA), width: 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.currentCoupon.length} Coupon Marked Used',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth * .036,
                        ),
                      ),
                      SizedBox(height: screenHeight * .01),

                      // ✅ Marked On formatted
                      customCouponAlertSubTitle(
                        'Marked On ${_formatMarkedOn(first?.markedUsedAt.toString())}',
                        screenWidth,
                        screenHeight,
                      ),

                      SizedBox(height: screenHeight * .02),
                      customCouponAlertTitle('Marked By', screenWidth, screenHeight),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * .01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customCouponAlertSubTitle(
                              first?.vendorName ?? '-',
                              screenWidth,
                              screenHeight,
                            ),
                            CouponStatus(screenHeight, screenWidth, 'Vendor'),
                          ],
                        ),
                      ),

                      widget.disbute
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(color: AppColors.backgrounHome),
                          customCouponAlertTitle(
                              'Dispute Reason', screenWidth, screenHeight),
                          SizedBox(height: screenHeight * .01),
                          customCouponAlertSubTitle(
                              'Never Received Water', screenWidth, screenHeight),
                          customCouponAlertTitle(
                              'Resolution', screenWidth, screenHeight),
                          SizedBox(height: screenHeight * .01),
                          customCouponAlertSubTitle(
                              'Returned', screenWidth, screenHeight),
                        ],
                      )
                          : BuildOutlinedIconButton(
                        screenWidth,
                        screenHeight,
                        'Show Delivery Photos',
                            () {
                          showDialog(
                            context: context,
                            builder: (ctx) => ShowDeliveryPhotos(first!),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Footer buttons
                widget.disbute
                    ? CancelOrderWidget(
                  context,
                  screenWidth,
                  screenHeight,
                  'Dispute Resolved',
                  'Dispute',
                      () => Navigator.pop(context),
                      () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (ctx) => DisputeAlertDialog(),
                    );
                  },
                )
                    : CancelOrderWidget(
                  context,
                  screenWidth,
                  screenHeight,
                  'Done',
                  'Dispute',
                      () => Navigator.pop(context),
                      () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (ctx) => DisputeAlertDialog(),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
