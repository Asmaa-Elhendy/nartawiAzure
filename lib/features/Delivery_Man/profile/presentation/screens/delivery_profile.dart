import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/profile/presentation/pages/edit_profile.dart';
import 'package:newwwwwwww/features/profile/presentation/widgets/profile_card.dart';
import 'package:newwwwwwww/features/profile/presentation/widgets/single_settings_profile.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../../../profile/presentation/provider/profile_controller.dart';
class DeliveryProfile extends StatefulWidget {
  const DeliveryProfile({super.key});

  @override
  State<DeliveryProfile> createState() => _DeliveryProfileState();
}

class _DeliveryProfileState extends State<DeliveryProfile> {
  late ProfileController profileController;

  @override
  void initState() {
    super.initState();
    profileController = ProfileController(dio: Dio());
    profileController.fetchProfile();
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
          BuildForegroundappbarhome(fromDeliveryMan: true,
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
                        // Loading state
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

                        // Error state
                        if (profileController.error != null) {
                          return SizedBox(
                            height: screenHeight * .6,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    profileController.error!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _handleRefresh,
                                    child: Text('Retry'),
                                  ),
                                ],
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
                                      profile.enName ?? profile.arName ?? 'Driver',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: screenWidth * .044,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      profile.mobile ?? '',
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
                                    builder: (_) => EditProfileScreen(fromDeliveryman:true),
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
                              'assets/images/profile/logout.svg',
                              'Log Out',
                                  () {
                                // TODO: logout
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
