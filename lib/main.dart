import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'package:newwwwwwww/features/home/presentation/provider/supplier_reviews_controller.dart';
import 'package:newwwwwwww/features/orders/presentation/provider/order_controller.dart';
import 'package:provider/provider.dart';
import 'package:newwwwwwww/features/home/presentation/bloc/product_categories_bloc/product_categories_bloc.dart';
import 'package:newwwwwwww/features/home/presentation/bloc/suppliers_bloc/suppliers_bloc.dart';
import 'package:newwwwwwww/features/favourites/pesentation/provider/favourite_controller.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/language_service.dart';
import 'features/auth/presentation/bloc/login_bloc.dart';
import 'features/home/presentation/bloc/products_bloc/products_bloc.dart';
import 'features/notification/presentation/bloc/notification_bloc/bloc.dart';
import 'features/notification/presentation/bloc/notification_bloc/event.dart';
import 'features/cart/presentation/bloc/cached_cart_bloc.dart';
import 'injection_container.dart';
import 'core/interceptors/auth_interceptor.dart';
import 'l10n/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize logging
  Logger.root.level = kDebugMode ? Level.ALL : Level.WARNING;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      print('${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
    }
  });
  
  // Initialize language service
  await LanguageService.init();
  
  // Lock orientation (portrait only)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown, // uncomment if you want both portraits
  ]);
  
  await init();
  
  // Set global navigator key for 401 handling
  if (kDebugMode) {
    print('Setting navigatorKey: $navigatorKey');
  }
  AuthInterceptor.setNavigatorKey(navigatorKey);
  
  runApp(
    ValueListenableBuilder<Locale?>(
      valueListenable: LanguageService.localeNotifier,
      builder: (context, locale, _) {
        return MultiProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (_) => sl<AuthBloc>(),
            ),
            BlocProvider<NotificationBloc>(
              create: (_) => sl<NotificationBloc>()..add(LoadNotifications()),
            ),
            BlocProvider<CachedCartBloc>(
              create: (_) => sl<CachedCartBloc>(),
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
            ChangeNotifierProvider<SupplierReviewsController>(
              create: (_) => sl<SupplierReviewsController>(),
            ),
            ChangeNotifierProvider<OrdersController>(
              create: (_) => sl<OrdersController>(),
            ),
          ],
          child: const MyApp(),
        );
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: LanguageService.localeNotifier,
      builder: (context, locale, _) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          
          // ✅ reactive locale
          locale: locale,

          // ✅ supported locales
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],

          // ✅ localization delegates
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // ✅ simple + safe resolution
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            if (locale != null) return locale; // if user picked manually
            
            final code = deviceLocale?.languageCode.toLowerCase();
            if (code == 'ar') return const Locale('ar');
            if (code == 'en') return const Locale('en');
            return const Locale('en');
          },

          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: '/',
        );
      },
    );
  }
}
