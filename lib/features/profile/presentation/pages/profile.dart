import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/auth/presentation/screens/login.dart';
import 'package:newwwwwwww/features/profile/presentation/pages/edit_profile.dart';
import 'package:newwwwwwww/features/profile/presentation/pages/my_ewallet_screen.dart';
import 'package:newwwwwwww/features/profile/presentation/pages/my_impact.dart';
import 'package:newwwwwwww/features/profile/presentation/pages/settings.dart';
import 'package:newwwwwwww/features/profile/presentation/widgets/impact_wallet_widget.dart';
import 'package:newwwwwwww/features/profile/presentation/widgets/profile_card.dart';
import 'package:newwwwwwww/features/profile/presentation/widgets/single_settings_profile.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/services/auth_service.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../provider/profile_controller.dart';
import 'delivery_address.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileController profileController;

  @override
  void initState() {
    super.initState();
    profileController = ProfileController(dio: Dio());
    profileController.fetchProfile(); // ✅ load profile
  }

  @override
  void dispose() {
    profileController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await profileController.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double topOffset =
        MediaQuery.of(context).padding.top + screenHeight * .1;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
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
            is_returned: false,
          ),
          Positioned.fill(
            top: topOffset,
            child: Padding(
              padding: EdgeInsets.only(bottom: screenHeight * .1),
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _handleRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * .06),
                    child: AnimatedBuilder(
                      animation: profileController,
                      builder: (context, _) {
                        // 🔄 Loading
                        if (profileController.isLoading) {
                          return SizedBox(
                            height: screenHeight * .6,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        }

                        // ❌ Error
                        if (profileController.error != null) {
                          return SizedBox(
                            height: screenHeight * .6,
                            child: Center(
                              child: Text(
                                profileController.error!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        }

                        final profile = profileController.profile;

                        if (profile == null) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * .01),

                            /// Profile Card (Avatar)
                            BuildFullCardProfile(),

                            /// Name + Mobile (FROM API)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * .02,
                              ),
                              child: Column(
                                children: [
                                  Center(
                                    child: Text(
                                      profile.enName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: screenWidth * .044,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      profile.mobile,
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

                            /// Impact + Wallet
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * .01,
                              ),
                              child: ImpactWalletWidget(
                                screenWidth,
                                screenHeight,
                                    () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MyImpactScreen(),
                                    ),
                                  );
                                },
                                    () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MyeWalletScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),

                            SizedBox(height: screenHeight * .01),

                            /// Settings
                            BuildSingleSeetingProfile(
                              screenWidth,
                              screenHeight,
                              'assets/images/profile/edit.svg',
                              'Edit Profile',
                                  () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditProfileScreen(),
                                  ),
                                );

                                // ✅ لو رجع true من شاشة Edit اعمل refresh
                                if (result == true) {
                                  _handleRefresh();
                                }
                              },
                            ),
                            BuildSingleSeetingProfile(
                              screenWidth,
                              screenHeight,
                              'assets/images/profile/gps.svg',
                              'Delivery Address',
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DeliveryAddressScreen(),
                                  ),
                                );
                              },
                            ),
                            BuildSingleSeetingProfile(
                              screenWidth,
                              screenHeight,
                              'assets/images/profile/settings.svg',
                              'Settings',
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SettingsScreen(),
                                  ),
                                );
                              },
                            ),
                            BuildSingleSeetingProfile(
                              screenWidth,
                              screenHeight,
                              'assets/images/profile/logout.svg',
                              'Log Out',
                                  () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Log Out'),
                                    content: Text('Are you sure you want to log out?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx, false),
                                        child: Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(ctx, true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: Text(
                                          'Log Out',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmed == true) {
                                  await AuthService.deleteToken();
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()),
                                      (context)=>true);
                                }
                              },
                            ),

                            SizedBox(height: screenHeight * .04),
                          ],
                        );
                      },
                    ),
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
