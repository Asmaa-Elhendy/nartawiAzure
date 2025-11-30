import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import '../../../../core/theme/colors.dart';
import '../../../auth/presentation/widgets/auth_buttons.dart';
import '../../../auth/presentation/widgets/build_custome_full_text_field.dart';
import '../../../coupons/presentation/widgets/dispute_alert.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../widgets/add_new_address_alert.dart';
import '../widgets/address_card.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emergencyphonenumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    _emergencyphonenumberController.dispose();
    _emailController.dispose();
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
            title: 'Delivery Addresses',
            is_returned: true, //edit back from orders
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            bottom: screenHeight*.05,
            child: Padding(
              padding: EdgeInsets.only(
           //     top: screenHeight * .03, // edit top height under appbar.03),//04 handle design shimaa
                bottom: screenHeight * .1,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * .04),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight * .7,
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsetsGeometry.only(
                            bottom: screenHeight * .06,
                            left: 0,
                            right: 0,
                          ),
                          children: [
                            BuildInfoAndAddToCartButton(
                              screenWidth,
                              screenHeight,
                              'Add New Address',
                              false,
                              () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AddAddressAlertDialog(),
                                );
                              },
                              fromDelivery: true,
                            ),
                            OutlineAuthButton(
                              screenWidth,
                              screenHeight,
                              'Use Current Location',
                              () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) =>
                                      AddAddressAlertDialog(useGps: true),
                                );
                              },
                              fromDelivery: true,
                              icon:
                                  'assets/images/profile/delivery/current_location.svg',
                            ),
                            OutlineAuthButton(
                              screenWidth,
                              screenHeight,
                              'Open Google Map',
                              () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) =>
                                      AddAddressAlertDialog(useGps: true),
                                );
                              },
                              fromDelivery: true,
                              icon:
                                  'assets/images/profile/delivery/google maps.svg',
                            ),
                            BuildCardAddress(context, screenHeight, screenWidth),
                            BuildCardAddress(
                              context,
                              screenHeight,
                              screenWidth,
                              work: true,
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
