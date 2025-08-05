import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/forget_password.dart';
import '../../features/auth/presentation/screens/login.dart';
import '../../features/auth/presentation/screens/reset_password.dart';
import '../../features/auth/presentation/screens/sign_up.dart';
import '../../features/auth/presentation/screens/verification_screen.dart';
import '../../features/home/presentation/screens/suppliers/all_suppliers_screen.dart';
import '../../features/home/presentation/screens/home.dart';
import '../../features/home/presentation/screens/mainscreen.dart';
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
