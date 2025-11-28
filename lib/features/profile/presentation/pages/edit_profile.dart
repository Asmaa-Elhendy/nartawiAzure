import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../auth/presentation/widgets/build_custome_full_text_field.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emergencyphonenumberController = TextEditingController();
  final TextEditingController  _emailController= TextEditingController();

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
            title: 'Profile',
            is_returned: true, //edit back from orders
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * .04,// edit top height under appbar
                bottom: screenHeight * .1,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: screenWidth*.04),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [


                      SizedBox(height: screenHeight*.7,
                        child: ListView(
                          padding: EdgeInsetsGeometry.only(bottom: screenHeight*.06,left: 0,right: 0),
                          children: [

                            buildCustomeFullTextField('First Name', 'Enter First Name', _firstNameController, false,screenHeight,fromEditProfile: true),
                            SizedBox(height: screenHeight*.01,),
                            buildCustomeFullTextField('Middle Name', 'Enter Middle Name', _middleNameController, false,screenHeight,fromEditProfile: true),
                            SizedBox(height: screenHeight*.01,),
                            buildCustomeFullTextField('Last Name', 'Enter Last Name', _lastNameController, false,screenHeight,fromEditProfile: true),
                            SizedBox(height: screenHeight*.01,),
                            buildCustomeFullTextField('Email Address', 'Ex: abc@example.com', _emailController, false,screenHeight,fromEditProfile: true),
                            SizedBox(height: screenHeight*.01,),
                            buildCustomeFullTextField('Phone Number', 'Enter Phone Number', _phoneNumberController, false,screenHeight,fromEditProfile: true),
                            SizedBox(height: screenHeight*.01,),
                            buildCustomeFullTextField('Alternative Phone Number', 'Enter Alternative phone number', _emergencyphonenumberController, false,screenHeight,fromEditProfile: true),
                            SizedBox(height: screenHeight*.01,),
                            BuildInfoAndAddToCartButton(screenWidth, screenHeight, 'Save', false, (){

                            },fromDelivery: true)
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