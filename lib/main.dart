  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
  import 'core/routing/app_router.dart';
  import 'core/theme/app_theme.dart';
import 'features/notification/presentation/bloc/notification_bloc/bloc.dart';
import 'features/notification/presentation/bloc/notification_bloc/event.dart';

  void main() {
    runApp(
      BlocProvider(
        create: (_) => NotificationBloc(initialNotifications: [])..add(LoadNotifications()),
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
        title: 'Flutter Demo',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: '/',
      );
    }
  }

