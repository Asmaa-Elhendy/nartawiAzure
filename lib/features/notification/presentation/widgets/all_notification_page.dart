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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Show CancelOrderWidget if at least one notification is selected
          //  if (state.notifications.any((n) => n.isChecked))
              state.notifications.any((n) => n.isChecked)?
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * .04),
                child: CancelOrderWidget(
                  context,
                  screenWidth,
                  screenHeight,
                  'Set As Read',
                  'Clear Selection',
                      () {
                    // Set as read for selected notifications
                        context.read<NotificationBloc>().add(SetSelectedAsRead());
                  },
                      () {
                    // Clear selection
                        context.read<NotificationBloc>().add(ClearSelection());
                  },
                ),
              ):SizedBox(),

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
