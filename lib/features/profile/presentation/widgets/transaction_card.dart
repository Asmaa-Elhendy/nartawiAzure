import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/models/wallet_transaction.dart';

Widget TransactionCard(
    double screenHeight,
    double screenWidth,
    WalletTransaction transaction,
    ) {
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.linkedAccountName ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: screenWidth * .036,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/images/orders/calendar.svg",
                            width: screenWidth * .038,
                            color: AppColors.textLight,
                          ),
                          SizedBox(width: screenWidth * .01),
                          Text(
                            formatTransactionDate(
                              transaction.completedAt ?? transaction.issuedAt,
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: screenWidth * .036,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'QAR ${transaction.amount}',
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

  // ✅ 12-hour format
  int hour = localDate.hour % 12;
  if (hour == 0) hour = 12;

  final minute = localDate.minute.toString().padLeft(2, '0');
  final period = localDate.hour >= 12 ? 'PM' : 'AM';

  final time = '$hour:$minute $period';

  if (txDay == today) {
    return 'Today at $time';
  }

  if (txDay == yesterday) {
    return 'Yesterday at $time';
  }

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




