import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/dio_service.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../auth/presentation/widgets/build_custome_full_text_field.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import '../provider/profile_controller.dart';
import '../widgets/custom_check_box.dart';
import '../widgets/date_of_birth_widget.dart';

class EditProfileScreen extends StatefulWidget {
bool fromDeliveryman;
EditProfileScreen({this.fromDeliveryman=false});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  DateTime? _selectedDob;

  late TabController _tabController;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emergencyphonenumberController =
  TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  bool checkedValue = false;
  bool checkedValue2 = false;

  String _selectedGender = 'Male';

  late ProfileController profileController;

  bool _isSaving = false;

  // ✅ Prefill only once
  bool _didPrefill = false;

  // ✅ NEW: Country code (dynamic)
  String _countryCode = '+974'; // default fallback

  // ✅ Helper model
  // Returns: countryCode="+974", number="12345678"
  // Works with: "+97412345678", "0097412345678", "+1 202-555-0123", etc.
  PhoneParts? splitPhoneGeneric(String? input) {
    if (input == null) return null;

    var v = input.trim();
    if (v.isEmpty) return null;

    // remove spaces and common separators
    v = v.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // convert 00 prefix to +
    if (v.startsWith('00')) {
      v = '+${v.substring(2)}';
    }

    // if starts with +, split country code (1-3 digits) + rest
    if (v.startsWith('+')) {
      final match = RegExp(r'^\+(\d{1,3})(\d+)$').firstMatch(v);
      if (match != null) {
        return PhoneParts(
          countryCode: '+${match.group(1)}',
          number: match.group(2) ?? '',
        );
      }
    }

    // fallback: treat as local number
    return PhoneParts(
      countryCode: '',
      number: v.replaceAll(RegExp(r'\D'), ''),
    );
  }

  // ✅ Prefill only once
  @override
  void initState() {
    profileController = ProfileController(dio: DioService.dio);
    _tabController = TabController(length: 2, vsync: this);

    super.initState();



    // ✅ fetch then prefill
    Future.microtask(() async {
      await profileController.fetchProfile();
      if (!mounted) return;
      setState(() {
        _prefillFromProfile();
      });
    });
  }

  void _prefillFromProfile() {
    if (_didPrefill) return;

    final p = profileController.profile;
    if (p == null) return;

    // API: { id, enName, arName, email, mobile }

    final fullName = (p.enName ?? '').trim();
    final parts =
    fullName.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();

    _firstNameController.text = parts.isNotEmpty ? parts.first : '';
    _lastNameController.text =
    parts.length > 1 ? parts.sublist(1).join(' ') : '';

    _emailController.text = (p.email ?? '').trim();

    // ✅ NEW: split + fill country code + number
    final phone = splitPhoneGeneric(p.mobile);

    _countryCode = (phone != null && phone.countryCode.isNotEmpty)
        ? phone.countryCode
        : '+974';

    _phoneNumberController.text = phone?.number ?? '';

    _didPrefill = true;
  }

  @override
  void dispose() {
    profileController.dispose();
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

  void _onLanguageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  String? imageUrl = null;

  @override
  Widget build(BuildContext context) {
    // ✅ if fetch finished after first build, fill once
    _prefillFromProfile();

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
          BuildForegroundappbarhome(fromDeliveryMan: widget.fromDeliveryman,
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            title:  AppLocalizations.of(context)!.editProfile,
            is_returned: true,
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            bottom: screenHeight * .05,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * .03,
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
                              widget.fromDeliveryman? AppLocalizations.of(context)!.userName:    AppLocalizations.of(context)!.firstName,
                              widget.fromDeliveryman? AppLocalizations.of(context)!.enterUserName: AppLocalizations.of(context)!.enterFirstName,
                              _firstNameController,
                              false,
                              screenHeight,
                              fromEditProfile: true,
                            ),
                            SizedBox(height: screenHeight * .01),
                            buildCustomeFullTextField(
                              widget.fromDeliveryman? AppLocalizations.of(context)!.lastName:   AppLocalizations.of(context)!.lastName,
                              widget.fromDeliveryman? AppLocalizations.of(context)!.enterName: AppLocalizations.of(context)!.enterLastName,
                              _lastNameController,
                              false,
                              screenHeight,
                              fromEditProfile: true,
                            ),
                            SizedBox(height: screenHeight * .01),
                            widget.fromDeliveryman?SizedBox():     buildDateOfBirthWidget(
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
                               AppLocalizations.of(context)!.emailAddress,
                               AppLocalizations.of(context)!.emailExample,
                              _emailController,
                              false,
                              screenHeight,
                              fromEditProfile: true,
                            ),
                            SizedBox(height: screenHeight * .01),

                            // ✅ Phone: controller contains number ONLY
                            // country code is stored in _countryCode
                            buildCustomeFullTextField(
                               AppLocalizations.of(context)!.phoneNumber,
                               AppLocalizations.of(context)!.enterPhoneNumber,
                              _phoneNumberController,
                              false,
                              screenHeight,
                              fromEditProfile: true,
                              countryCode:_countryCode
                              // NOTE: to render country code dynamically in UI,
                              // we must pass it down to SignUpTextField
                              // (we will modify build_custome_full_text_field.dart + signup_textfield.dart)
                            ),

                            SizedBox(height: screenHeight * .01),
                        widget.fromDeliveryman?SizedBox():
                        Column(children: [
                          buildCustomeFullTextField(
                               AppLocalizations.of(context)!.alternativePhoneNumber,
                               AppLocalizations.of(context)!.enterAlternativePhoneNumber,
                              _emergencyphonenumberController,
                              false,
                              screenHeight,
                              fromEditProfile: true,
                              countryCode:_countryCode

                          ),
                          SizedBox(height: screenHeight * .02),
                          Text(
                             AppLocalizations.of(context)!.gender,
                            style: AppTextStyles.LabelInTextField,
                          ),
                          SizedBox(height: screenHeight * .01),
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenWidth * .03,
                              top: screenHeight * .01,
                            ),
                            child: Row(
                              children: [
                                _buildGenderRadio(
                                  label:  AppLocalizations.of(context)!.male,
                                  screenWidth: screenWidth,
                                  screenHeight: screenHeight,
                                ),
                                SizedBox(width: screenWidth * .08),
                                _buildGenderRadio(
                                  label:  AppLocalizations.of(context)!.female,
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
                              CustomRowCheckBox(
                                checkedValue: checkedValue,
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                                onChanged: (newValue) {
                                  setState(() => checkedValue = newValue);
                                },
                                title:
                                "Yes, I Want To Receive Offers And Discounts",
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * .03),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomRowCheckBox(
                                checkedValue: checkedValue2,
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                                onChanged: (newValue) {
                                  setState(() => checkedValue2 = newValue);
                                },
                                title: "Subscribe To Newsletter",
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * .03),
                        ],),
                            BuildInfoAndAddToCartButton(
                              screenWidth,
                              screenHeight,
                              _isSaving ?  AppLocalizations.of(context)!.saving :  AppLocalizations.of(context)!.save,
                              false,
                                  () async {
                                if (_isSaving) return;

                                setState(() => _isSaving = true);

                                try {
                                  final enName =
                                  '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
                                      .trim();

                                  final mobileNumber =
                                  _phoneNumberController.text.trim();

                                  // ✅ Build full E.164 phone: +CODE + number
                                  final fullMobile = mobileNumber.isEmpty
                                      ? null
                                      : '$_countryCode$mobileNumber';

                                  final ok = await profileController.updateProfile(
                                    enName: enName.isEmpty ? null : enName,
                                    email: _emailController.text.trim().isEmpty
                                        ? null
                                        : _emailController.text.trim(),
                                    mobile: fullMobile,
                                  );

                                  if (ok) {
                                    await profileController.fetchProfile();
                                    if (!mounted) return;
                                    Navigator.pop(context, true);
                                  } else {
                                    debugPrint(
                                        'Update failed: ${profileController.updateError}');
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() => _isSaving = false);
                                  }
                                }
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
          Text(label, style: AppTextStyles.LabelInTextField),
        ],
      ),
    );
  }
}

// ✅ Simple model used by splitPhoneGeneric
class PhoneParts {
  final String countryCode;
  final String number;

  const PhoneParts({
    required this.countryCode,
    required this.number,
  });
}
