import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../orders/presentation/widgets/cancel_order_buttons.dart';
import '../bloc/notification_bloc/bloc.dart';
import '../bloc/notification_bloc/event.dart';
import '../bloc/notification_bloc/state.dart';
import '../widgets/select_all_row.dart';
import 'notification_card.dart';

class AllNotificationPage extends StatelessWidget {
  const AllNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show CancelOrderWidget only if all notifications are selected
            if (state.notifications.isNotEmpty &&
                state.notifications.every((n) => n.isChecked))
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * .04),
                child: CancelOrderWidget(
                  context,
                  screenWidth,
                  screenHeight,
                  'Set All As Read',
                  'Clear Selection',
                      () {
                    // Set all as read
                    context.read<NotificationBloc>().add(SetAllAsRead());
                  },
                      () {
                    // Clear selection
                    context
                        .read<NotificationBloc>()
                        .add(ToggleSelectAll(false));
                  },
                ),
              ),

            // Select All row
            SelectAllRow(
              isChecked: state.notifications.every((n) => n.isChecked),
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              onChanged: (value) {
                context
                    .read<NotificationBloc>()
                    .add(ToggleSelectAll(value ?? false));
              },
            ),

            // Notification list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final item = state.notifications[index];
                  return NotificationCard(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    notification: item,
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * .06)
          ],
        );
      },
    );
  }
}
