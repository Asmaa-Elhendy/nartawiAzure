import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String? relatedEntityType;
  final int? relatedEntityId;
  final DateTime createdAt;
  final DateTime? readAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    this.relatedEntityType,
    this.relatedEntityId,
    required this.createdAt,
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      isRead: json['isRead'] as bool? ?? false,
      relatedEntityType: json['relatedEntityType'] as String?,
      relatedEntityId: json['relatedEntityId'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      readAt: json['readAt'] != null 
          ? DateTime.parse(json['readAt'] as String) 
          : null,
    );
  }

  IconData get icon {
    switch (type) {
      case 'ORDER_UPDATE':
        return Icons.shopping_bag;
      case 'SCHEDULED_ORDER_REMINDER':
        return Icons.schedule;
      case 'DISPUTE_UPDATE':
        return Icons.report_problem;
      case 'MARKETING':
        return Icons.local_offer;
      case 'SYSTEM':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  Color get iconColor {
    switch (type) {
      case 'ORDER_UPDATE':
        return Colors.blue;
      case 'SCHEDULED_ORDER_REMINDER':
        return Colors.orange;
      case 'DISPUTE_UPDATE':
        return Colors.red;
      case 'MARKETING':
        return Colors.green;
      case 'SYSTEM':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 7) {
      return DateFormat('MMM d, yyyy').format(createdAt.toLocal());
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String get category {
    switch (type) {
      case 'ORDER_UPDATE':
        return 'Orders';
      case 'SCHEDULED_ORDER_REMINDER':
        return 'Coupons';
      case 'MARKETING':
        return 'Promos';
      default:
        return 'All';
    }
  }

  String get description => message;
}

class NotificationsPaginatedResponse {
  final List<NotificationModel> items;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final bool hasNextPage;

  NotificationsPaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.hasNextPage,
  });

  factory NotificationsPaginatedResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsPaginatedResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: json['pagination']['currentPage'] as int,
      totalPages: json['pagination']['totalPages'] as int,
      totalCount: json['pagination']['totalCount'] as int,
      hasNextPage: json['pagination']['hasNextPage'] as bool? ?? false,
    );
  }
}
