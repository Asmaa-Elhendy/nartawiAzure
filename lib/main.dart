import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:newwwwwwww/features/home/presentation/bloc/product_categories_bloc/product_categories_bloc.dart';
import 'package:newwwwwwww/features/home/presentation/bloc/suppliers_bloc/suppliers_bloc.dart';
import 'package:newwwwwwww/features/home/presentation/bloc/suppliers_bloc/suppliers_bloc.dart';
import 'package:newwwwwwww/features/favourites/pesentation/provider/favourite_controller.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/bloc/products_bloc/products_bloc.dart';
import 'features/notification/presentation/bloc/notification_bloc/bloc.dart';
import 'features/notification/presentation/bloc/notification_bloc/event.dart';
import 'features/home/presentation/bloc/cart/cart_bloc.dart';
import 'injection_container.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // لو لسه عايزة تقفلي الـ orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown, // سيبيها أو شيليها براحتك
  ]);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown, // لو عايزة تقفيل كامل للعرض
  ]);
  await init();
  runApp(
    MultiProvider(
      providers: [
        BlocProvider<NotificationBloc>(
          create: (_) => sl<NotificationBloc>()..add(LoadNotifications()),
        ),
        BlocProvider<CartBloc>(
          create: (_) => sl<CartBloc>(),
        ),
        BlocProvider<ProductCategoriesBloc>(
          create: (_) => sl<ProductCategoriesBloc>(),
        ),
        BlocProvider<SuppliersBloc>(
          create: (_) => sl<SuppliersBloc>(),
        ),
        BlocProvider<ProductsBloc>(
          create: (_) => sl<ProductsBloc>(),
        ),
        ChangeNotifierProvider<FavoritesController>(
          create: (_) => sl<FavoritesController>(),
        ),
        

      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NARTAWI',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: '/',
    );
  }
}