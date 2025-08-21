import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationEvent {}

class MarkAllAsRead extends NotificationEvent {}

class ToggleSelectAll extends NotificationEvent {
  final bool isChecked;

  const ToggleSelectAll(this.isChecked);

  @override
  List<Object?> get props => [isChecked];
}

class ToggleNotificationCheck extends NotificationEvent {
  final int id;
  final bool isChecked;

  const ToggleNotificationCheck(this.id, this.isChecked);

  @override
  List<Object?> get props => [id, isChecked];
}

// event.dart
class SetAllAsRead extends NotificationEvent {}

class SetSelectedAsRead extends NotificationEvent {}
class ClearSelection extends NotificationEvent {}

