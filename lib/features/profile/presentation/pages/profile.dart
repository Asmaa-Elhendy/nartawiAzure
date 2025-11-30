import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/profile/presentation/pages/edit_profile.dart';
import 'package:newwwwwwww/features/profile/presentation/pages/my_ewallet_screen.dart';
import 'package:newwwwwwww/features/profile/presentation/pages/my_impact.dart';
import 'package:newwwwwwww/features/profile/presentation/pages/settings.dart';
import 'package:newwwwwwww/features/profile/presentation/widgets/impact_wallet_widget.dart';
import 'package:newwwwwwww/features/profile/presentation/widgets/profile_card.dart';
import 'package:newwwwwwww/features/profile/presentation/widgets/single_settings_profile.dart';
import '../../../../core/theme/colors.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import 'delivery_address.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String? imageUrl = null;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      // 🔥 يخلي الجسم يبدأ من أعلى الشاشة خلف الـ AppBar
      backgroundColor: Colors.transparent,
      // في حالة الصورة في الخلفية
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            color: AppColors.backgrounHome,
          ),
          buildBackgroundAppbar(screenWidth),
          BuildForegroundappbarhome(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            title: 'Profile',
            is_returned: false, //edit back from orders
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            child: Padding(
              padding: EdgeInsets.only(
              //  top: screenHeight * .03,//04 handle design shimaa
                bottom: screenHeight * .1,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: screenWidth*.06),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [


                      SizedBox(height: screenHeight*.7,
                        child: ListView(
                          padding: EdgeInsetsGeometry.only(bottom: screenHeight*.06,left: 0,right: 0),
                          children: [
                            BuildFullCardProfile(),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * .02,
                              ),
                              child: Column(
                                children: [
                                  Center(
                                    child: Text(
                                      'Ahmed Mohamed',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: screenWidth * .044,
                                      ),
                                    ),
                                  ),

                                  Center(
                                    child: Text(
                                      '+0020121212121212',
                                      style: TextStyle(
                                        color: AppColors
                                            .greyDarktextIntExtFieldAndIconsHome,
                                        fontWeight: FontWeight.w600,
                                        fontSize: screenWidth * 0.036,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsets.symmetric(vertical: screenHeight*.01),
                              child: ImpactWalletWidget(screenWidth, screenHeight,(){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyImpactScreen()));
                              },(){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyeWalletScreen()));

                              }),
                            ),
                            BuildSingleSeetingProfile(screenWidth, screenHeight,'assets/images/profile/edit.svg','Edit Profile',(){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfileScreen()));
                            }),
                            BuildSingleSeetingProfile(screenWidth, screenHeight,'assets/images/profile/gps.svg','Delivery Address',(){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>DeliveryAddressScreen()));

                            }),
                            BuildSingleSeetingProfile(screenWidth, screenHeight,'assets/images/profile/settings.svg','Settings',(){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsScreen()));
                            }),
                            BuildSingleSeetingProfile(screenWidth, screenHeight,'assets/images/profile/logout.svg','Log Out',(){})

                          ],),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
