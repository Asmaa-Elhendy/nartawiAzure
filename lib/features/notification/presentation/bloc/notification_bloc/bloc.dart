import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';
import 'event.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    on<LoadNotifications>((event, emit) {
      // Mock data with title and description
      emit(NotificationState(
        notifications: [
          NotificationItem(
            id: 1,
            title: "Welcome!",
            description: "Welcome to our app. Enjoy your experience.",
            isRead: false,
          ),
          NotificationItem(
            id: 2,
            title: "Update Available",
            description: "A new update is ready to install.",
            isRead: false,
          ),
          NotificationItem(
            id: 3,
            title: "Reminder",
            description: "Don't forget to check your tasks today.",
            isRead: true,
          ),
        ],
      ));
    });

    on<MarkAllAsRead>((event, emit) {
      final updated = state.notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();
      emit(state.copyWith(notifications: updated));
    });

    on<ToggleSelectAll>((event, emit) {
      final updatedNotifications = state.notifications
          .map((n) => n.copyWith(isChecked: event.isChecked))
          .toList();
      emit(state.copyWith(notifications: updatedNotifications));
    });

    on<ToggleNotificationCheck>((event, emit) {
      final updatedNotifications = state.notifications.map((n) {
        if (n.id == event.id) {
          return n.copyWith(isChecked: event.isChecked);
        }
        return n;
      }).toList();
      emit(state.copyWith(notifications: updatedNotifications));
    });
  }
}
