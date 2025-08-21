import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class NotificationState extends Equatable {
  final List<NotificationItem> notifications;

  const NotificationState({this.notifications = const []});

  NotificationState copyWith({List<NotificationItem>? notifications}) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [notifications];
}

class NotificationItem {
  final int id;
  final String title;
  final String description;
  final bool isRead;
  final bool isChecked;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    this.isRead = false,
    this.isChecked = false,
  });

  NotificationItem copyWith({
    int? id,
    String? title,
    String? description,
    bool? isRead,
    bool? isChecked,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isRead: isRead ?? this.isRead,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}

