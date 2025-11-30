import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../auth/presentation/widgets/build_custome_full_text_field.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import '../widgets/custom_check_box.dart';
import '../widgets/date_of_birth_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  DateTime? _selectedDob; // 👈 هنا هنخزّن تاريخ الميلاد

  late TabController _tabController;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emergencyphonenumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool checkedValue = false;
  bool checkedValue2=false;
  // 👇 متغيّر الجندر المختار
  String _selectedGender = 'Male';

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _firstNameController.dispose();
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
            is_returned: true,
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            bottom:screenHeight*.05,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * .03,//.03),//04 handle design shimaa
                bottom: screenHeight * .1,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * .04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight * .7,
                        child: ListView(
                          padding: EdgeInsets.only(
                            bottom: screenHeight * .06,
                            left: 0,
                            right: 0,
                          ),
                          children: [
                            buildCustomeFullTextField(
                              'First Name',
                              'Enter First Name',
                              _firstNameController,
                              false,
                              screenHeight,
                              fromEditProfile: true,
                            ),


                            SizedBox(height: screenHeight * .01),
                            buildCustomeFullTextField(
                              'Last Name',
                              'Enter Last Name',
                              _lastNameController,
                              false,
                              screenHeight,
                              fromEditProfile: true,
                            ),
                            SizedBox(height: screenHeight * .01),
                          //  buildDateOfBirthWidget(screenHeight, screenWidth),
                            buildDateOfBirthWidget(
                              context,
                              screenHeight,
                              screenWidth,
                              selectedDate: _selectedDob,
                              onDateSelected: (date) {
                                setState(() {
                                  _selectedDob = date;
                                });
                              },
                            ),
                            SizedBox(height: screenHeight * .01),
                            buildCustomeFullTextField(
                              'Email Address',
                              'Ex: abc@example.com',
                              _emailController,
                              false,
                              screenHeight,
                              fromEditProfile: true,
                            ),
                            SizedBox(height: screenHeight * .01),
                            buildCustomeFullTextField(
                              'Phone Number',
                              'Enter Phone Number',
                              _phoneNumberController,
                              false,
                              screenHeight,
                              fromEditProfile: true,
                            ),
                            SizedBox(height: screenHeight * .01),
                            buildCustomeFullTextField(
                              'Alternative Phone Number',
                              'Enter Alternative phone number',
                              _emergencyphonenumberController,
                              false,
                              screenHeight,
                              fromEditProfile: true,
                            ),
                            SizedBox(height: screenHeight * .02),

                            // 👇 Label الجندر
                            Text(
                              'Gender',
                              style: AppTextStyles.LabelInTextField,
                            ),
                            SizedBox(height: screenHeight * .01),

                            // 👇 الراديوهات (Male / Female) بنفس ستايل الـ dialog
                            Padding(
                              padding:  EdgeInsets.only(left:screenWidth*.03 ,top: screenHeight*.01),
                              child: Row(
                                children: [
                                  _buildGenderRadio(
                                    label: 'Male',
                                    screenWidth: screenWidth,
                                    screenHeight: screenHeight,
                                  ),
                                  SizedBox(width: screenWidth * .08),
                                  _buildGenderRadio(
                                    label: 'Female',
                                    screenWidth: screenWidth,
                                    screenHeight: screenHeight,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * .04),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               CustomRowCheckBox(checkedValue: checkedValue, screenWidth: screenWidth,
                                   screenHeight: screenHeight, onChanged:  (newValue) {
                                 setState(() => checkedValue = newValue);
                               },title:  "Yes, I Want To Receive Offers And Discounts",)

                              ],
                            ),
                            SizedBox(height: screenHeight * .03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomRowCheckBox(checkedValue: checkedValue2, screenWidth: screenWidth,
                                  screenHeight: screenHeight, onChanged:  (newValue) {
                                    setState(() => checkedValue2 = newValue);
                                  },title:  "Subscribe To Newsletter",)

                              ],
                            ),
                            SizedBox(height: screenHeight * .03),

                            BuildInfoAndAddToCartButton(
                              screenWidth,
                              screenHeight,
                              'Save',
                              false,
                                  () {
                                // هنا تستعملي _selectedGender مع باقي البيانات
                                // مثلا تبعتيه للـ API
                              },
                              fromDelivery: true,
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

  // 👇 نفس شكل الراديو المستخدم في الـ TimePeriodSelectionDialog
  Widget _buildGenderRadio({
    required String label,
    required double screenWidth,
    required double screenHeight,
  }) {
    final bool isSelected = _selectedGender == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = label;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(

            width: screenWidth * 0.045,
            height: screenWidth * 0.045,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.greyDarktextIntExtFieldAndIconsHome,
                width: isSelected ? 2 : 1.5,
              ),
            ),
            child: isSelected
                ? Center(
              child: Container(
                width: screenWidth * 0.023,
                height: screenWidth * 0.023,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
            )
                : null,
          ),
          SizedBox(width: screenWidth * 0.02),
          Text(
            label,
              style: AppTextStyles.LabelInTextField
          ),
        ],
      ),
    );
  }
}

