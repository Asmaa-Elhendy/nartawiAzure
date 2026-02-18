import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/services/language_service.dart';
import '../../../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, String>> get onboardingData => [
    {
      'image': 'assets/images/onboaring/illastorator-man.png',
      'description': AppLocalizations.of(context)!.onboarding1,
    },
    {
      'image': 'assets/images/onboaring/illastorator-phone.png',
      'description': AppLocalizations.of(context)!.onboarding2,
    },
    {
      'image': 'assets/images/onboaring/illastorator-woman.png',
      'description': AppLocalizations.of(context)!.onboarding3,
    },
  ];

  @override
  void initState() {
    super.initState();
    
    // Add language change listener using ValueNotifier
    LanguageService.localeNotifier.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    _pageController.dispose();
    LanguageService.localeNotifier.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-cache images for smoother onboarding experience
    for (var data in onboardingData) {
      precacheImage(AssetImage(data['image']!), context);
    }
    // Also pre-cache the logo and background
    precacheImage(const AssetImage('assets/images/onboaring/Logo.png'), context);
    precacheImage(const AssetImage('assets/images/splash/background.png'), context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        Image.asset(
          "assets/images/splash/background.png",
          fit: BoxFit.cover,
        ),

        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingData.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return OnboardingContent(
                        imagePath: onboardingData[index]['image']!,
                        description: onboardingData[index]['description']!,
                        width: width,
                        height: height,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.01),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/login');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: height * 0.02),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.letsGetStarted,
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                          (index) => buildDot(index, height, width),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDot(int index, double height, double width) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: height * 0.009,
      width: _currentPage == index ? width * 0.1 : width * 0.06,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(_currentPage != index ? 1 : 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String imagePath;
  final String description;
  final double width;
  final double height;

  const OnboardingContent({
    super.key,
    required this.imagePath,
    required this.description,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: height * 0.05,
        left: width * 0.03,
        right: width * 0.03,
        bottom: height * 0.05,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset("assets/images/onboaring/Logo.png", width: width * 0.18),
          const SizedBox(height: 15),
          SizedBox(height: height*.16,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style:  TextStyle(
                  fontSize: width*.05,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.05),
          Image.asset(imagePath, height: 200, width: 250),
        ],
      ),
    );
  }
}
