import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theme/colors.dart';
import '../../../orders/presentation/widgets/order_status_widget.dart';
import '../../domain/models/wallet_transaction.dart';

Widget TransactionCard(
    double screenHeight,
    double screenWidth,
    WalletTransaction transaction, {
      bool fromDeliveryMan = false,
    }) {
  // ✅ FIX فقط للـ status بدون تغيير UI
  String _normalizedStatus(String raw) {
    final s = raw.toLowerCase().trim();

    if (s.contains('completed')) return 'Delivered';
    if (s.contains('delivered')) return 'Delivered';

    if (s.contains('cancel')) return 'Cancelled'; // cancelled/canceled
    if (s.contains('dispute')) return 'Disputed';

    return raw; // Pending / etc...
  }

  return Padding(
    padding: EdgeInsets.symmetric(vertical: screenHeight * .01),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: screenHeight * .06,
              decoration: BoxDecoration(
                color: AppColors.backgrounHome,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Image.asset(
                "assets/images/home/main_page/company.png",
                height: screenHeight * .03,
              ),
            ),
            SizedBox(width: screenWidth * .03),

            // ✅ ده الجزء اللي كان بيعمل overflow
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        transaction.linkedAccountName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: screenWidth * .036,
                        ),
                      ),
                      if (fromDeliveryMan)
                        Padding(
                          padding: EdgeInsets.only(left: screenWidth * .02),
                          child: BuildOrderStatus(
                            fromDeliveryMan: fromDeliveryMan,
                            screenHeight,
                            screenWidth, //hj
                            _normalizedStatus(transaction.status), // ✅ هنا بس التعديل
                            fromOrderDetail: false,
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: screenHeight * .004),

                  Row(
                    children: [
                      // ✅ التاريخ ياخد المساحة ويعمل ellipsis
                      Expanded(
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/orders/calendar.svg",
                              width: screenWidth * .038,
                              color: AppColors.textLight,
                            ),
                            SizedBox(width: screenWidth * .01),
                            Expanded(
                              child: Text(
                                formatTransactionDate(
                                  transaction.completedAt ?? transaction.issuedAt,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: screenWidth * .036,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ✅ مسافة بسيطة بين التاريخ والسعر
                      if (!fromDeliveryMan) SizedBox(width: screenWidth * .02),

                      // ✅ السعر ثابت يمين
                      if (!fromDeliveryMan)
                        Text(
                          'QAR ${transaction.amount}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: screenWidth * .036,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        Divider(
          color: AppColors.BorderAnddividerAndIconColor,
          thickness: 1,
        ),
      ],
    ),
  );
}

String formatTransactionDate(DateTime? date) {
  if (date == null) return '';

  final localDate = date.toLocal();
  final now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final txDay = DateTime(localDate.year, localDate.month, localDate.day);

  int hour = localDate.hour % 12;
  if (hour == 0) hour = 12;

  final minute = localDate.minute.toString().padLeft(2, '0');
  final period = localDate.hour >= 12 ? 'PM' : 'AM';
  final time = '$hour:$minute $period';

  if (txDay == today) return 'Today at $time';
  if (txDay == yesterday) return 'Yesterday at $time';

  return '${localDate.day.toString().padLeft(2, '0')} '
      '${_monthName(localDate.month)} '
      '${localDate.year} at $time';
}

String _monthName(int month) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return months[month - 1];
}
