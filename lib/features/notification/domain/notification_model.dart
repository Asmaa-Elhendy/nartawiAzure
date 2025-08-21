class NotificationModel {
  final int id;
  final String title;
  final String description;
  bool isChecked;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    this.isChecked = false,
    this.isRead = false,
  });
}
