import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';
import 'event.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final List<NotificationItem> initialNotifications;

  NotificationBloc({required this.initialNotifications})
      : super(NotificationState(notifications: initialNotifications)) {

    on<LoadNotifications>((event, emit) {
      // Instead of hardcoding, use the parameter list
      emit(NotificationState(notifications: initialNotifications));
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

    on<SetAllAsRead>((event, emit) {
      final updated = state.notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();
      emit(state.copyWith(notifications: updated));
    });

    on<SetSelectedAsRead>((event, emit) {
      final updatedNotifications = state.notifications.map((n) {
        if (n.isChecked) {
          return n.copyWith(isRead: true, isChecked: false);
        }
        return n;
      }).toList();

      emit(state.copyWith(notifications: updatedNotifications));
    });

    on<ClearSelection>((event, emit) {
      final updatedNotifications = state.notifications.map((n) {
        return n.copyWith(isChecked: false);
      }).toList();

      emit(state.copyWith(notifications: updatedNotifications));
    });
  }
}
