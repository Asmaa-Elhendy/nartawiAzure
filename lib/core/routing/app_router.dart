import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/forget_password.dart';
import '../../features/auth/presentation/screens/login.dart';
import '../../features/auth/presentation/screens/reset_password.dart';
import '../../features/auth/presentation/screens/sign_up.dart';
import '../../features/auth/presentation/screens/verification_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/coupons/presentation/screens/coupons_screen.dart';
import '../../features/favourites/pesentation/screens/favourites_screen.dart';
import '../../features/home/presentation/pages/all_product_screen.dart';
import '../../features/home/presentation/pages/home.dart';
import '../../features/home/presentation/pages/mainscreen.dart';
import '../../features/home/presentation/pages/popular_categories_main_screen.dart';
import '../../features/home/presentation/pages/popular_category_screen.dart';
import '../../features/home/presentation/pages/suppliers/all_suppliers_screen.dart';
import '../../features/home/presentation/pages/suppliers/product_details.dart';
import '../../features/home/presentation/pages/suppliers/supplier_detail.dart';
import '../../features/notification/presentation/pages/notification_screen.dart';
import '../../features/orders/presentation/pages/order_details.dart';
import '../../features/orders/presentation/pages/orders_screen.dart';
import '../../features/profile/presentation/pages/delivery_address.dart';
import '../../features/profile/presentation/pages/edit_profile.dart';
import '../../features/profile/presentation/pages/my_ewallet_screen.dart';
import '../../features/profile/presentation/pages/my_impact.dart';
import '../../features/profile/presentation/pages/profile.dart';
import '../../features/profile/presentation/pages/scan_qr.dart';
import '../../features/profile/presentation/pages/settings.dart';
import '../../features/splash/onboarding.dart';
import '../../features/splash/splash_screen.dart';
// Import other pages as needed

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/onBording':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/signUp':
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case '/forgetPassword':
        return MaterialPageRoute(builder: (_) => const ForgetPasswordScreen());
      case '/verification':
        return MaterialPageRoute(builder: (_) => const VerificationScreen());
      case '/resetPassword':
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/main':
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case '/allSuppliers':
        return MaterialPageRoute(builder: (_) => const AllSuppliersScreen());
      case '/supplierDetail':
        return MaterialPageRoute(builder: (_) => const SupplierDetails());
      case '/popularCategories':
        return MaterialPageRoute(builder: (_) => const PopularCategoriesMainScreen());
      case '/allProducts':
        return MaterialPageRoute(builder: (_) => const AllProductScreen());
      case '/productDetail':
        return MaterialPageRoute(builder: (_) => const ProductDetailScreen());
      case '/ordersScreen':
        return MaterialPageRoute(builder: (_) => const OrdersScreen());
      case '/orderDetail':
        return MaterialPageRoute(builder: (_) =>  OrderDetailScreen(orderStatus: '', paymentStatus: '',));
      case '/couponsScreen':
        return MaterialPageRoute(builder: (_) =>  CouponsScreen());
      case '/favouritesScreen':
        return MaterialPageRoute(builder: (_) =>  FavouritesScreen());
      case '/profileScreen':
        return MaterialPageRoute(builder: (_) =>  ProfileScreen());
      case '/editProfileScreen':
        return MaterialPageRoute(builder: (_) =>  EditProfileScreen());
      case '/deliveryAddress':
        return MaterialPageRoute(builder: (_) =>  DeliveryAddressScreen());
      case '/settingsScreen':
        return MaterialPageRoute(builder: (_) =>  SettingsScreen());
      case '/myImpactScreen':
        return MaterialPageRoute(builder: (_) =>  MyImpactScreen());
      case '/myeWalletScreen':
        return MaterialPageRoute(builder: (_) =>  MyeWalletScreen());
      case '/cartScreen':
        return MaterialPageRoute(builder: (_) =>  CartScreen());
      case '/notificationScreen':
        return MaterialPageRoute(builder: (_) =>  NotificationScreen());
      case '/scanQr':
        return MaterialPageRoute(builder: (_) =>  QRViewExample());

    // Add more routes here
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined')),
          ),
        );
    }
  }
}
