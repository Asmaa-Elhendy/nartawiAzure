import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import '../../../auth/presentation/widgets/auth_buttons.dart';
import '../provider/address_controller.dart';
import '../widgets/add_new_address_alert.dart';
import '../widgets/address_card.dart';
import '../../../../injection_container.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AddressController addressController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // ✅ Use shared AddressController from DI container
    addressController = sl<AddressController>();
    
    // ✅ Delay fetch to avoid build phase issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        addressController.fetchAddresses(); // ✅ أول تحميل
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    // Don't dispose shared AddressController - it's managed by DI container
    super.dispose();
  }

  String? imageUrl = null;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
            title: 'Delivery Addresses',
            is_returned: true,
          ),

          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            bottom: screenHeight * .05,
            child: Padding(
              padding: EdgeInsets.only(bottom: screenHeight * .1),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * .04),
                child: AnimatedBuilder(
                  animation: addressController,
                  builder: (context, _) {
                    // ✅ RefreshIndicator لازم يكون child بتاعه scrollable
                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async {
                        await addressController.refresh();
                      },
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: screenHeight * .06),
                        children: [
                          // ===== Buttons =====
                          BuildInfoAndAddToCartButton(
                            screenWidth,
                            screenHeight,
                            'Add New Address',
                            false,
                                () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AddAddressAlertDialog(),
                              ).then((_) {
                                // بعد إضافة عنوان جديد (لو الديالوج بيرجع true) ممكن تعملي refresh
                                addressController.refresh();
                              });
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
                              ).then((_) => addressController.refresh());
                            },
                            fromDelivery: true,
                            icon:
                            'assets/images/profile/delivery_man/current_location.svg',
                          ),
                          OutlineAuthButton(
                            screenWidth,
                            screenHeight,
                            'Open Google Map',
                                () {
                              showDialog(
                                context: context,
                                builder: (ctx) =>
                                    AddAddressAlertDialog(pickFromMap: true),
                              ).then((_) => addressController.refresh());
                            },
                            fromDelivery: true,
                            icon:
                            'assets/images/profile/delivery/google maps.svg',
                          ),

                          const SizedBox(height: 12),

                          // ===== Loading =====
                          if (addressController.isLoading)
                            Padding(
                              padding: EdgeInsets.only(top: screenHeight * .02),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),

                          // ===== Error =====
                          if (!addressController.isLoading &&
                              addressController.error != null)
                            Padding(
                              padding: EdgeInsets.only(top: screenHeight * .02),
                              child: Center(
                                child: Text(
                                  addressController.error!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ),

                          // ===== Empty =====
                          if (!addressController.isLoading &&
                              addressController.error == null &&
                              addressController.addresses.isEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: screenHeight * .02),
                              child: const Center(
                                child: Text('No addresses found'),
                              ),
                            ),

                          // ===== List =====
                          if (!addressController.isLoading &&
                              addressController.error == null &&
                              addressController.addresses.isNotEmpty)
                            ...addressController.addresses.map((a) {
                              // هنا هنحوّل الـ API Address إلى الكارد بتاعك
                              // لو BuildCardAddress عندك بياخد داتا مختلفة ابعتيلي signature وأنا أوصلها 100%
                              return BuildCardAddress(  controller: addressController, // ✅ PASS IT HERE

                                  context,
                                screenHeight,
                                screenWidth,
                                address: a
                                // لو عندك params:
                                // title: a.title,
                                // areaName: a.areaName,
                                // address: a.address,
                                // notes: a.notes,
                                // isDefault: a.isDefault,
                                // work: a.title?.toLowerCase() == 'work',
                              );
                            }).toList(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
