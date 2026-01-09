import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:newwwwwwww/features/Delivery_Man/orders/presentation/widgets/custome_button.dart';
import '../../../../../core/services/maps_screen.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../auth/presentation/widgets/auth_buttons.dart';
import '../../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import 'delivery_confirmation_screen.dart';


class TrackOrderScreen extends StatefulWidget {



  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool confirmed=false;
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String? imageUrl = null;

  Future<void> _openGoogleMaps() async {
    // Hardcoded coordinates for now - should be passed from order data
    // TODO: Pass actual customer address coordinates when navigating to this screen
    const lat = 25.276987;
    const lng = 51.520008;

    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving'
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        await launchUrl(url);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open Google Maps: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
          BuildForegroundappbarhome(fromDeliveryMan: true,
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            title: 'Track Order',
            is_returned: true,
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            bottom: screenHeight * .05,
            child: Padding(
              padding: EdgeInsets.only(
               // top: screenHeight * .03, //04 handle design shimaa
                bottom: screenHeight * .1,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * .06,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            InkWell(
                              onTap:(){
                                setState(() {
                                  confirmed=!confirmed;
                                });
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                DeliveryConfirmationScreen(orderId: 0, orderDate: DateTime.now(), address: 'Zone abc, Street 20, Building 21, Flat 22',)));
                              },
                              child: CustomGradientButton('assets/images/delivery_man/orders/package-delivered.svg',
                                  .015, 'Confirm Delivered', screenWidth, screenHeight,ChangedColor: confirmed),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child:
                                  Container(
                                key: const ValueKey('map'),
                                height: screenHeight * .56,
                                width: double.infinity,
                                margin: EdgeInsets.only(top: screenHeight * .02),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.BorderAnddividerAndIconColor),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: OsmPickLocationScreen(fromDeliveryMan: true,
                                    initial: const LatLng(31.2653, 32.3019), // أو أي lat/lng
                                  ),
                                ),
                              )

                            ),

                            OutlineAuthButton(
                              screenWidth,
                              screenHeight,
                              'Open Google Map',
                              () async {
                                await _openGoogleMaps();
                              },
                              fromDelivery: true,
                              icon: 'assets/images/profile/delivery/google maps.svg',
                            ),
                          ],
                        ),
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
