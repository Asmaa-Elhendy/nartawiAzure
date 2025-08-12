import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/home/presentation/screens/suppliers/product_details.dart';
import '../../features/auth/presentation/screens/forget_password.dart';
import '../../features/auth/presentation/screens/login.dart';
import '../../features/auth/presentation/screens/reset_password.dart';
import '../../features/auth/presentation/screens/sign_up.dart';
import '../../features/auth/presentation/screens/verification_screen.dart';
import '../../features/coupons/presentation/screens/coupons_screen.dart';
import '../../features/home/presentation/screens/all_product_screen.dart';
import '../../features/home/presentation/screens/popular_categories_screen.dart';
import '../../features/home/presentation/screens/suppliers/all_suppliers_screen.dart';
import '../../features/home/presentation/screens/home.dart';
import '../../features/home/presentation/screens/mainscreen.dart';
import '../../features/home/presentation/screens/suppliers/supplier_detail.dart';
import '../../features/orders/presentation/screens/order_details.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/splash/onboarding.dart';
import '../../features/splash/splash_screen.dart';
// Import other screens as needed

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
        return MaterialPageRoute(builder: (_) => const PopularCategoriesScreen());
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
