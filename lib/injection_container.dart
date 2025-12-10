import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:newwwwwwww/features/home/presentation/bloc/suppliers_bloc/suppliers_bloc.dart';
import 'features/auth/presentation/bloc/login_bloc.dart';
import 'features/home/presentation/bloc/cart/cart_bloc.dart';
import 'features/home/presentation/bloc/product_categories_bloc/product_categories_bloc.dart';
import 'features/home/presentation/bloc/products_bloc/products_bloc.dart';
import 'features/notification/presentation/bloc/notification_bloc/bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton<Dio>(() => Dio());

  // Blocs
  sl.registerFactory(() => ProductCategoriesBloc(dio: sl<Dio>()));

  sl.registerFactory(() => SuppliersBloc(dio: sl<Dio>()));
  sl.registerFactory(() => ProductsBloc(dio: sl<Dio>()));



  sl.registerFactory<CartBloc>(() => CartBloc());
  sl.registerFactory<NotificationBloc>(() => NotificationBloc(initialNotifications: []));



  sl.registerFactory<AuthBloc>(() => AuthBloc(dio: sl<Dio>()));

}