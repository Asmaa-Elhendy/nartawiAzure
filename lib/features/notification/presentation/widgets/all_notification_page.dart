import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    return BlocProvider(
      create: (_) => NotificationBloc()..add(LoadNotifications()),
      child: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Select All
              SelectAllRow(
                isChecked: state.notifications.every((n) => n.isChecked),
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                onChanged: (value) {
                  context.read<NotificationBloc>().add(ToggleSelectAll(value ?? false));
                },
              ),


              /// List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: state.notifications.length,
                  itemBuilder: (context, index) {
                    final item = state.notifications[index];
                    return NotificationCard(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      notification: item,  // <-- pass the full notification here
                    );

                  },
                ),
              ),
              SizedBox(height: screenHeight*.06,)
            ],
          );
        },
      ),
    );
  }
}
