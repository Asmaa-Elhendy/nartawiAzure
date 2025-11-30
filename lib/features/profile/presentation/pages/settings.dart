import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/coupon_card.dart';
import '../../../../core/theme/colors.dart';
import '../../../auth/presentation/widgets/build_custome_full_text_field.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import '../widgets/add_new_address_alert.dart';
import '../widgets/change password.dart';
import '../widgets/setting_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

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
            title: 'Settings',
            is_returned: true, //edit back from orders
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            bottom: screenHeight*.05,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * .03,// edit top height under appbar.03),//04 handle design shimaa
                bottom: screenHeight * .1,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding:  EdgeInsets.only(left: screenWidth*.04,right: screenWidth*.04,bottom: screenHeight*.04),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Text(
                        'Notification Preferences',
                        style: TextStyle(fontWeight: FontWeight.w700,fontSize: screenWidth*.04),
                      ),
                      SettingCard(title: 'Low Coupon Alerts', description: 'Get notified when your coupon balance is running low', quantityLabel: 'Coupons'),

                      SettingCard(title: 'Wallet Balance Alerts', description: 'Get alerts when your wallet balance is low', quantityLabel: 'QAR'),

                      SettingCard(title: 'Order Updates', description: 'Receive notifications about your order status', quantityLabel: '',isIncrease: false,),

                      SettingCard(title: 'Refill Updates', description: 'Get notified when your bottles have been refilled', quantityLabel: '',isIncrease: false,),

                      SettingCard(title: 'Promotions & Offers', description: 'Receive notifications about promotions and special offers', quantityLabel: '',isIncrease: false,),
                     Padding(
                       padding:  EdgeInsets.symmetric(vertical: screenHeight*.01),
                       child: Text('Security',style: TextStyle(color: AppColors.primary,fontWeight: FontWeight.w700,fontSize: screenWidth*.036),),
                     ),
                      BuildInfoAndAddToCartButton(screenWidth, screenHeight, 'Change Password', false, (){
                          showDialog(
                            context: context,
                            builder: (ctx) => ChangePasswordAlert(),
                          );

                      },fromDelivery: true)


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