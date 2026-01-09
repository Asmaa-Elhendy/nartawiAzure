import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../domain/notification_model.dart';
import '../../data/datasources/notification_remote_datasource.dart';

class NotificationController extends ChangeNotifier {
  final NotificationRemoteDataSource _dataSource;

  NotificationController({required Dio dio})
      : _dataSource = NotificationRemoteDataSourceImpl(dio: dio);

  List<NotificationModel> _allNotifications = [];
  bool _isLoading = false;
  String? _error;
  int _unreadCount = 0;

  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMore = true;

  List<NotificationModel> get allNotifications => _allNotifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount => _unreadCount;
  bool get hasMore => _hasMore;

  List<NotificationModel> getNotificationsByTab(String tab) {
    if (tab == 'All') return _allNotifications;
    if (tab == 'New') return _allNotifications.where((n) => !n.isRead).toList();
    if (tab == 'Read') return _allNotifications.where((n) => n.isRead).toList();
    
    return _allNotifications.where((n) => n.category == tab).toList();
  }

  Future<void> fetchNotifications({bool loadMore = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    if (!loadMore) {
      _currentPage = 1;
      _allNotifications.clear();
    }
    notifyListeners();

    try {
      final response = await _dataSource.getNotifications(
        pageNumber: _currentPage,
        pageSize: 20,
      );

      _allNotifications.addAll(response.items);
      _totalPages = response.totalPages;
      _hasMore = response.hasNextPage;

      if (loadMore) _currentPage++;

      await refreshUnreadCount();
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error fetching notifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUnreadCount() async {
    try {
      _unreadCount = await _dataSource.getUnreadCount();
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error refreshing unread count: $e');
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await _dataSource.markAsRead(id);
      
      final index = _allNotifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _allNotifications[index] = NotificationModel(
          id: _allNotifications[index].id,
          title: _allNotifications[index].title,
          message: _allNotifications[index].message,
          type: _allNotifications[index].type,
          isRead: true,
          relatedEntityType: _allNotifications[index].relatedEntityType,
          relatedEntityId: _allNotifications[index].relatedEntityId,
          createdAt: _allNotifications[index].createdAt,
          readAt: DateTime.now(),
        );
      }

      _unreadCount = (_unreadCount - 1).clamp(0, 999);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error marking as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final count = await _dataSource.markAllAsRead();
      
      _allNotifications = _allNotifications.map((n) {
        return NotificationModel(
          id: n.id,
          title: n.title,
          message: n.message,
          type: n.type,
          isRead: true,
          relatedEntityType: n.relatedEntityType,
          relatedEntityId: n.relatedEntityId,
          createdAt: n.createdAt,
          readAt: DateTime.now(),
        );
      }).toList();

      _unreadCount = 0;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error marking all as read: $e');
    }
  }

  Future<void> registerFCMToken({
    required String token,
    required String deviceType,
    required String deviceId,
  }) async {
    await _dataSource.registerFCMToken(
      token: token,
      deviceType: deviceType,
      deviceId: deviceId,
    );
  }
}
