import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:newwwwwwww/features/home/presentation/bloc/suppliers_bloc/suppliers_bloc.dart';
import 'package:newwwwwwww/features/favourites/pesentation/provider/favourite_controller.dart';
import 'package:newwwwwwww/features/home/presentation/provider/supplier_reviews_controller.dart';
import 'package:newwwwwwww/features/orders/presentation/provider/order_controller.dart';
import 'features/auth/presentation/bloc/login_bloc.dart';
import 'features/home/presentation/bloc/cart/cart_bloc.dart';
import 'features/home/presentation/bloc/product_categories_bloc/product_categories_bloc.dart';
import 'features/home/presentation/bloc/products_bloc/products_bloc.dart';
import 'package:newwwwwwww/core/services/dio_service.dart';
import 'features/notification/presentation/bloc/notification_bloc/bloc.dart';
import 'features/profile/presentation/provider/address_controller.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton<Dio>(() => Dio());

  // Blocs
  sl.registerFactory(() => ProductCategoriesBloc(dio: DioService.dio));

  sl.registerFactory(() => SuppliersBloc());
  sl.registerFactory(() => ProductsBloc(dio: DioService.dio));



  sl.registerFactory<CartBloc>(() => CartBloc());
  sl.registerFactory<NotificationBloc>(() => NotificationBloc(initialNotifications: []));



  sl.registerFactory<AuthBloc>(() => AuthBloc(dio: DioService.dio));

  // Favorites Controller
  sl.registerFactory<FavoritesController>(() => FavoritesController(dio: DioService.dio));

  // Address Controller - Use singleton to share same instance
  sl.registerLazySingleton<AddressController>(() => AddressController(dio: DioService.dio));

  sl.registerFactory<SupplierReviewsController>(() => SupplierReviewsController(dio: DioService.dio));
  sl.registerFactory<OrdersController>(() => OrdersController(dio: DioService.dio));
}