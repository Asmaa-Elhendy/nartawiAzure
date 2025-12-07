  import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
  import 'core/routing/app_router.dart';
  import 'core/theme/app_theme.dart';
import 'features/notification/presentation/bloc/notification_bloc/bloc.dart';
import 'features/notification/presentation/bloc/notification_bloc/event.dart';
import 'features/home/presentation/bloc/cart/cart_bloc.dart';
import 'injection_container.dart';

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown, // لو عايزة تقفيل كامل للعرض
    ]);
    await init();
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<NotificationBloc>(
            create: (_) => sl<NotificationBloc>()..add(LoadNotifications()),
          ),
          BlocProvider<CartBloc>(
            create: (_) => sl<CartBloc>(),
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

