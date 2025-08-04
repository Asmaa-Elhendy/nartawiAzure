import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Correct import
import '../../core/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
       Navigator.pushReplacementNamed(context, '/onBording');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand, // Makes the stack fill the screen
        children: [
          Image.asset(
            "assets/images/splash/background.png",
            fit: BoxFit.cover, // Make the image fill the entire screen
          ),
          Center(
            child: Image.asset(
              "assets/images/splash/nartawi_logo.png",color: AppColors.whiteColor,
              width: 200,
              height: 150,
            ),
          ),

        ],
      ),
    );
  }
}
