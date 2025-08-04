import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/onboaring/illastorator-man.png',
      'description':
      'pick your favorite water brand, coupon bundle, and delivery address',
    },
    {
      'image': 'assets/images/onboaring/illastorator-phone.png',
      'description':
      'confirm your order and checkout-all in few taps',
    },
    {
      'image': 'assets/images/onboaring/illastorator-woman.png',
      'description':
      'stay refreshed.your water arrives straight to your door every week,stay goodbye to paper coupons',
    },
  ];

  void _goToNextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    return Stack(
      fit: StackFit.expand,
      children: [
        // ✅ Background Image
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
                ),  Padding(
                  padding:  EdgeInsets.symmetric(horizontal: width*.04,vertical: height*.01),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _goToNextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding:  EdgeInsets.symmetric(vertical: height*.02),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                             'Let\'s Get Started'
                               ,
                            style: const TextStyle(
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
                          (index) => buildDot(index,height,width),
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

  Widget buildDot(int index,double height,double width) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: height*.009,
      width: _currentPage == index ? width*.1 : width*.06,
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
    required this.height
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top:this.height*.05, left: width*.02, right: width*.02, bottom: height*.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset("assets/images/onboaring/Logo.png", width: width*.2),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
           SizedBox(height: height*.03),
          Image.asset(imagePath, height: 200, width: 250),
        ],
      ),
    );
  }
}
