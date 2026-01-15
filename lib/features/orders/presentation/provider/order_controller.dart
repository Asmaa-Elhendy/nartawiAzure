import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../../core/services/auth_service.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';
import '../../domain/models/create_order_req.dart';
import '../../domain/models/order_model.dart';

class OrdersQuery {
  final int? statusId;
  final DateTime? fromDate;
  final DateTime? toDate;

  final int? issuedByAccountId;
  final int? terminalId;
  final bool? isPaid;

  final String? orderReference;
  final String? searchTerm;

  final String? sortBy; // date_asc | status | total | null(default newest)
  final bool? isDescending;

  const OrdersQuery({
    this.statusId,
    this.fromDate,
    this.toDate,
    this.issuedByAccountId,
    this.terminalId,
    this.isPaid,
    this.orderReference,
    this.searchTerm,
    this.sortBy,
    this.isDescending,
  });

  Map<String, dynamic> toQueryParams({
    required int pageIndex,
    required int pageSize,
    bool isDeliveryRole = false,
  }) {
    String? dt(DateTime? d) => d?.toUtc().toIso8601String();

    return {
      if (statusId != null) 'statusId': statusId,
      if (fromDate != null) 'fromDate': dt(fromDate),
      if (toDate != null) 'toDate': dt(toDate),

      if (issuedByAccountId != null) 'issuedByAccountId': issuedByAccountId,
      if (terminalId != null) 'terminalId': terminalId,
      if (isPaid != null) 'isPaid': isPaid,

      if (orderReference != null && orderReference!.trim().isNotEmpty)
        'orderReference': orderReference,

      if (searchTerm != null && searchTerm!.trim().isNotEmpty)
        'searchTerm': searchTerm,

      if (sortBy != null && sortBy!.trim().isNotEmpty) 'sortBy': sortBy,
      if (isDescending != null) 'isDescending': isDescending,

      // pagination - use correct param name based on role
      if (isDeliveryRole)
        'page': pageIndex
      else
        'pageIndex': pageIndex,
      'pageSize': pageSize,
    };
  }
}

class OrdersController extends ChangeNotifier {
  final Dio dio;
  final String? userRole; // 'Delivery' or null/other for client

  OrdersController({required this.dio, this.userRole}) {
    debugPrint('🔥 OrdersController created for role: ${userRole ?? "Client"}');
  }
  
  /// Determine endpoint based on user role
  String get _ordersEndpoint {
    if (userRole == 'Delivery') {
      return '$base_url/v1/delivery/orders';
    }
    return '$base_url/v1/client/orders';
  }

  /// Normalize delivery API response to match client API format
  Map<String, dynamic> _normalizeResponse(Map<String, dynamic> data) {
    // If already in client format, return as-is
    if (data.containsKey('pageIndex')) return data;

    // Convert delivery format to client format
    final normalized = Map<String, dynamic>.from(data);
    
    // Map: page → pageIndex
    if (data.containsKey('page')) {
      normalized['pageIndex'] = data['page'];
    }
    
    // Map items: orderId → id, totalAmount → total for each order
    if (data['items'] is List) {
      normalized['items'] = (data['items'] as List).map((item) {
        if (item is Map<String, dynamic>) {
          final orderMap = Map<String, dynamic>.from(item);
          
          // Map: orderId → id
          if (item.containsKey('orderId') && !item.containsKey('id')) {
            orderMap['id'] = item['orderId'];
          }
          
          // Map: totalAmount → total
          if (item.containsKey('totalAmount') && !item.containsKey('total')) {
            orderMap['total'] = item['totalAmount'];
          }
          
          // Map: issueTime
          if (item.containsKey('issueTime')) {
            orderMap['issueTime'] = item['issueTime'];
          }
          
          // Normalize nested items array (order items/products)
          if (item['items'] is List) {
            orderMap['items'] = (item['items'] as List).map((orderItem) {
              if (orderItem is Map<String, dynamic>) {
                final normalizedItem = Map<String, dynamic>.from(orderItem);
                
                // Delivery API: price → Client API: unitPrice
                if (orderItem.containsKey('price') && !orderItem.containsKey('unitPrice')) {
                  normalizedItem['unitPrice'] = orderItem['price'];
                }
                
                // Calculate totalPrice if not present
                if (!orderItem.containsKey('totalPrice')) {
                  final qty = orderItem['quantity'] ?? 0;
                  final price = orderItem['price'] ?? 0;
                  normalizedItem['totalPrice'] = qty * price;
                }
                
                // Add name alias for productName (order_summary_card compatibility)
                if (orderItem.containsKey('productName') && !orderItem.containsKey('name')) {
                  normalizedItem['name'] = orderItem['productName'];
                }
                
                // Add missing fields with defaults
                normalizedItem['productId'] ??= 0;
                normalizedItem['notes'] ??= '';
                normalizedItem['categoryName'] ??= '';
                normalizedItem['imageUrl'] ??= '';
                
                return normalizedItem;
              }
              return orderItem;
            }).toList();
          }
          
          // Normalize nested deliveryAddress fields
          if (item['deliveryAddress'] is Map<String, dynamic>) {
            final deliveryAddr = item['deliveryAddress'] as Map<String, dynamic>;
            final normalizedAddr = Map<String, dynamic>.from(deliveryAddr);
            
            // buildingNum → building
            if (deliveryAddr.containsKey('buildingNum')) {
              normalizedAddr['building'] = deliveryAddr['buildingNum'];
            }
            
            // streetNum → address
            if (deliveryAddr.containsKey('streetNum')) {
              normalizedAddr['address'] = deliveryAddr['streetNum'];
            }
            
            // floorNum → floor
            if (deliveryAddr.containsKey('floorNum')) {
              normalizedAddr['floor'] = deliveryAddr['floorNum'];
            }
            
            // doorNumber → apartment
            if (deliveryAddr.containsKey('doorNumber')) {
              normalizedAddr['apartment'] = deliveryAddr['doorNumber'];
            }
            
            // geoLocation → latitude & longitude
            if (deliveryAddr.containsKey('geoLocation')) {
              final geoStr = deliveryAddr['geoLocation'].toString();
              final parts = geoStr.split(',');
              if (parts.length == 2) {
                normalizedAddr['latitude'] = double.tryParse(parts[0].trim()) ?? 0;
                normalizedAddr['longitude'] = double.tryParse(parts[1].trim()) ?? 0;
              }
            }
            
            // Add missing client-only fields with defaults
            normalizedAddr['id'] ??= 0;
            normalizedAddr['title'] ??= '';
            normalizedAddr['areaId'] ??= 0;
            normalizedAddr['isDefault'] ??= false;
            normalizedAddr['isActive'] ??= true;
            
            orderMap['deliveryAddress'] = normalizedAddr;
          }
          
          // Add missing arrays with empty defaults
          orderMap['vendors'] ??= [];
          orderMap['eventLogs'] ??= [];
          
          // Add missing client-only fields
          orderMap['confirmation'] ??= null;
          
          return orderMap;
        }
        return item;
      }).toList();
    }
    
    return normalized;
  }

  // ---------------- ORDERS ----------------
  final List<ClientOrder> orders = [];

  bool isLoading = false;
  bool isLoadingMore = false;
  String? error;

  int pageIndex = 1;
  int pageSize = 10;

  int totalPages = 1;
  int totalCount = 0;

  OrdersQuery _query = const OrdersQuery();

  bool get hasMore => pageIndex < totalPages;

  void setQuery(OrdersQuery query) {
    _query = query;
  }

  Future<void> fetchOrders({OrdersQuery? query, bool executeClear = true}) async {
    if (isLoading) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      if (query != null) _query = query;

      if (executeClear) {
        orders.clear();
        pageIndex = 1;
        totalPages = 1;
        totalCount = 0;
      }

      final token = await AuthService.getToken();
      if (token == null) {
        error = 'Authentication required';
        return;
      }

      final url = _ordersEndpoint;

      final response = await dio.get(
        url,
        queryParameters: _query.toQueryParams(
          pageIndex: pageIndex,
          pageSize: pageSize,
          isDeliveryRole: userRole == 'Delivery',
        ),
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : <String, dynamic>{};

        // Normalize delivery API response to match client format
        final normalized = _normalizeResponse(data);
        final parsed = ClientOrdersResponse.fromJson(normalized);

        totalCount = parsed.totalCount;
        totalPages = parsed.totalPages;

        orders.addAll(parsed.items);
      } else {
        error = 'Failed to load orders (status: ${response.statusCode})';
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Failed to load orders';

      if (data is Map && data['title'] != null) {
        msg = data['title'].toString();
      } else if (data is Map && data['message'] != null) {
        msg = data['message'].toString();
      } else if (e.message != null) {
        msg = e.message!;
      }

      error = msg;
    } catch (e) {
      error = 'An unexpected error occurred: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh({OrdersQuery? query}) async {
    pageIndex = 1;
    await fetchOrders(query: query ?? _query, executeClear: true);
  }

  Future<void> loadMore() async {
    if (isLoadingMore || isLoading) return;
    if (!hasMore) return;

    isLoadingMore = true;
    error = null;
    notifyListeners();

    try {
      pageIndex += 1;

      final token = await AuthService.getToken();
      if (token == null) {
        error = 'Authentication required';
        return;
      }

      final url = _ordersEndpoint;

      final response = await dio.get(
        url,
        queryParameters: _query.toQueryParams(
          pageIndex: pageIndex,
          pageSize: pageSize,
          isDeliveryRole: userRole == 'Delivery',
        ),
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : <String, dynamic>{};

        // Normalize delivery API response to match client format
        final normalized = _normalizeResponse(data);
        final parsed = ClientOrdersResponse.fromJson(normalized);

        totalCount = parsed.totalCount;
        totalPages = parsed.totalPages;

        orders.addAll(parsed.items);
      } else {
        error = 'Failed to load more orders (status: ${response.statusCode})';
      }
    } on DioException catch (e) {
      error = e.message ?? 'Failed to load more orders';
    } catch (e) {
      error = 'An unexpected error occurred: $e';
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  /// ✅ POST /api/v1/client/orders/{id}/cancel
  /// Cancel a pending order (STATUS_ID=1)
  /// Returns true if canceled successfully.
  Future<bool> cancelOrder({
    required int id,
    required String reason,
    bool refreshAfter = true,
  }) async {
    error = null;
    notifyListeners();

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        error = 'Authentication required';
        notifyListeners();
        return false;
      }

      final url = '$base_url/v1/client/orders/$id/cancel';

      final response = await dio.post(
        url,
        data: {
          'reason': reason, // ✅ swagger schema
        },
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          // ✅ مهم: 204 يعتبر success، فبنسمح بكل الأكواد < 500
          validateStatus: (code) => code != null && code < 500,
        ),
      );

      // ✅ Success: 204 No Content
      if (response.statusCode == 204) {
        debugPrint('✅ Order #$id canceled successfully');

        if (refreshAfter) {
          await refresh(); // يرجّع أول صفحة بنفس query الحالية
        }
        return true;
      }

      // ✅ Failed (مثل 400)
      final data = response.data;
      String msg = 'Order cannot be canceled';

      // Swagger error ممكن ييجي بصيغ مختلفة
      if (data is Map && data['title'] != null) {
        msg = data['title'].toString();
      } else if (data is Map && data['detail'] != null) {
        msg = data['detail'].toString();
      } else if (data is Map && data['message'] != null) {
        msg = data['message'].toString();
      } else if (data is String && data.trim().isNotEmpty) {
        msg = data;
      } else {
        msg = 'Order cannot be canceled (status: ${response.statusCode})';
      }

      error = msg;
      notifyListeners();
      return false;
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Failed to cancel order';

      if (data is Map && data['title'] != null) {
        msg = data['title'].toString();
      } else if (data is Map && data['detail'] != null) {
        msg = data['detail'].toString();
      } else if (data is Map && data['message'] != null) {
        msg = data['message'].toString();
      } else if (e.message != null) {
        msg = e.message!;
      }

      error = msg;
      notifyListeners();
      return false;
    } catch (e) {
      error = 'An unexpected error occurred: $e';
      notifyListeners();
      return false;
    }
  }
  /// ✅ POST /api/v1/client/orders
  /// Create a new water delivery order.
  /// Returns the created order (if API returns JSON), otherwise returns null.
  /// If your API returns 201 with body => parsed.
  /// If it returns 204 => success without body.
  Future<ClientOrder?> createOrder({
    required CreateOrderRequest request,
    bool refreshAfter = true,
  }) async {
    error = null;
    notifyListeners();

    // Basic validation (client-side)
    if (request.items.isEmpty) {
      error = 'Please add at least one item';
      notifyListeners();
      return null;
    }
    for (final it in request.items) {
      if (it.quantity <= 0) {
        error = 'Quantity must be greater than 0';
        notifyListeners();
        return null;
      }
    }

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        error = 'Authentication required';
        notifyListeners();
        return null;
      }

      final url = '$base_url/v1/client/orders';
      debugPrint('🌍 FINAL URL: $url');

      final response = await dio.post(
        url,
        data: request.toJson(), // Use custom API format
        options: Options(
          headers: {
            'accept': 'application/json',
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          // allow 4xx to be handled gracefully
            validateStatus: (_) => true,

        ),
      );
      debugPrint('❗CREATE ORDER STATUS: ${response.statusCode}');
      debugPrint('❗CREATE ORDER BODY: ${response.data}');

      // ✅ Most APIs: 201 Created (with body)
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;

        ClientOrder? created;
        if (data is Map<String, dynamic>) {
          // if API returns the created order object
          created = ClientOrder.fromJson(data);
        } else if (data is Map) {
          created = ClientOrder.fromJson(Map<String, dynamic>.from(data));
        } else {
          created = null;
        }

        debugPrint('✅ Order created successfully (status: ${response.statusCode})');

        if (refreshAfter) {
          await refresh(); // reload orders list
        }

        return created;
      }

      // ✅ Some APIs: 204 No Content (success without body)
      if (response.statusCode == 204) {
        debugPrint('✅ Order created successfully (204 No Content)');

        if (refreshAfter) {
          await refresh();
        }

        return null;
      }

      // ❌ Failed
      final data = response.data;
      String msg = 'Failed to create order';

      if (data is Map && data['title'] != null) {
        msg = data['title'].toString();
      } else if (data is Map && data['detail'] != null) {
        msg = data['detail'].toString();
      } else if (data is Map && data['message'] != null) {
        msg = data['message'].toString();
      } else if (data is String && data.trim().isNotEmpty) {
        msg = data;
      } else {
        msg = 'Failed to create order (status: ${response.statusCode})';
      }

      error = msg;
      notifyListeners();
      return null;
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Failed to create order';

      if (data is Map && data['title'] != null) {
        msg = data['title'].toString();
      } else if (data is Map && data['detail'] != null) {
        msg = data['detail'].toString();
      } else if (data is Map && data['message'] != null) {
        msg = data['message'].toString();
      } else if (e.message != null) {
        msg = e.message!;
      }

      error = msg;
      notifyListeners();
      return null;
    } catch (e) {
      error = 'An unexpected error occurred: $e';
      notifyListeners();
      return null;
    }
  }

}
