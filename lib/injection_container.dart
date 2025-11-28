import 'package:get_it/get_it.dart';
import 'features/home/presentation/bloc/cart/cart_bloc.dart';
import 'features/notification/presentation/bloc/notification_bloc/bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory<CartBloc>(() => CartBloc());
  sl.registerFactory<NotificationBloc>(() => NotificationBloc(initialNotifications: []));

  // TODO: Register usecases, repositories, datasources here when available
}
