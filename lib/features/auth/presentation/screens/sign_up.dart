// ============================
// File: signup_screen.dart  (COMPLETED)
// ============================
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newwwwwwww/core/theme/colors.dart';
import 'package:newwwwwwww/core/theme/text_styles.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_bloc.dart';
import 'package:newwwwwwww/features/auth/presentation/bloc/login_event.dart';
import 'package:newwwwwwww/features/auth/presentation/widgets/auth_buttons.dart';
import 'package:newwwwwwww/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:newwwwwwww/features/splash/splash_screen.dart';
import 'package:newwwwwwww/features/splash/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../../core/utils/components/background_logo.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../Delivery_Man/home/presentation/screens/home_delivery.dart';
import '../bloc/login_state.dart';
import '../widgets/build_custome_full_text_field.dart';
import '../widgets/build_info_phone.dart';
import '../widgets/build_title_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emergencyphonenumberController =
  TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Field keys (validate per-field only)
  final _userNameKey = GlobalKey<FormFieldState>();
  final _firstNameKey = GlobalKey<FormFieldState>();
  final _lastNameKey = GlobalKey<FormFieldState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _phoneKey = GlobalKey<FormFieldState>();
  final _altPhoneKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  final _confirmPasswordKey = GlobalKey<FormFieldState>();



  void _onLanguageChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _userNameController.dispose();
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

  // --------- validators ----------
  String? _required(String? v, String label) {
    if ((v ?? '').trim().isEmpty) return '$label ${     AppLocalizations.of(context)!.fieldIsRequired}';
    return null;
  }

  String? _emailValidator(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return      AppLocalizations.of(context)!.emailAddressRequired;
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) return AppLocalizations.of(context)!.enterValidEmail;
    return null;
  }

  String? _passwordValidator(String? v) {
    final value = (v ?? '');
    if (value.trim().isEmpty) return AppLocalizations.of(context)!.passwordRequired;
    if (value.length < 6) return AppLocalizations.of(context)!.passwordMinLength;
    return null;
  }

  String? _confirmPasswordValidator(String? v) {
    final confirm = (v ?? '');
    if (confirm.trim().isEmpty) return AppLocalizations.of(context)!.confirmPasswordRequired;
    if (confirm != _passwordController.text) return AppLocalizations.of(context)!.passwordMismatch;
    return null;
  }

  void _handleSignUp() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final fullName =
    '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
        .trim();

    context.read<AuthBloc>().add(
      PerformRegister(
        username: _userNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: fullName,
        phoneNumber: _phoneNumberController.text.trim(),
        confirmPassword: _confirmPasswordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }

          if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is RegisterLoading;

          return Stack(
            children: [
              Scaffold(
                body: Padding(
                  padding: EdgeInsets.only(
                    top: height * .08,
                    left: width * .04,
                    right: width * .04,
                  ),
                  child: Form(
                    key: _formKey,

                    // ✅ IMPORTANT: stop validating all fields while typing
                    autovalidateMode: AutovalidateMode.disabled,

                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BuildBackgroundLogo(width, height),

                          buildCustomeFullTextField(
                            AppLocalizations.of(context)!.userName,
                            AppLocalizations.of(context)!.enterUsername,
                            _userNameController,
                            true,
                            height,
                            fieldKey: _userNameKey,
                            validator: (v) => _required(v, AppLocalizations.of(context)!.userName),
                          ),

                          buildCustomeFullTextField(
                            AppLocalizations.of(context)!.firstName,
                            AppLocalizations.of(context)!.enterFirstName,
                            _firstNameController,
                            true,
                            height,
                            fieldKey: _firstNameKey,
                            validator: (v) => _required(v, AppLocalizations.of(context)!.firstName),
                          ),

                          buildCustomeFullTextField(
                            AppLocalizations.of(context)!.lastName,
                            AppLocalizations.of(context)!.enterLastName,
                            _lastNameController,
                            true,
                            height,
                            fieldKey: _lastNameKey,
                            validator: (v) => _required(v, AppLocalizations.of(context)!.lastName),
                          ),

                          buildCustomeFullTextField(
                            AppLocalizations.of(context)!.emailAddress,
                            AppLocalizations.of(context)!.exEmail,
                            _emailController,
                            true,
                            height,
                            fieldKey: _emailKey,
                            validator: _emailValidator,
                          ),

                          buildCustomeFullTextField(
                            AppLocalizations.of(context)!.phone,
                            AppLocalizations.of(context)!.enterPhone,
                            _phoneNumberController,
                            true,
                            height,
                            isNumberKeyboard: true,
                            fieldKey: _phoneKey,
                            validator: (v) => _required(v, AppLocalizations.of(context)!.phone),
                          ),
                          buildInfoPhoneInfo(width,context),

                          buildCustomeFullTextField(
                            AppLocalizations.of(context)!.alternativePhoneNumber,
                            AppLocalizations.of(context)!.enterAlternativePhone,
                            _emergencyphonenumberController,
                            false,
                            height,
                            isNumberKeyboard: true,
                            fieldKey: _altPhoneKey,
                          ),
                          buildInfoPhoneInfo(width,context),

                          // ✅ Password: validate itself + revalidate confirm if typed
                          buildCustomeFullTextField(
                            AppLocalizations.of(context)!.password,
                            AppLocalizations.of(context)!.enterPassword,
                            _passwordController,
                            true,
                            height,
                            fieldKey: _passwordKey,
                            validator: _passwordValidator,
                            onChanged: (_) {
                              _passwordKey.currentState?.validate();
                              if (_confirmPasswordController.text.isNotEmpty) {
                                _confirmPasswordKey.currentState?.validate();
                              }
                            },
                          ),

                          // ✅ Confirm Password: validate live mismatch only
                          buildCustomeFullTextField(
                            AppLocalizations.of(context)!.confirmPassword,
                            AppLocalizations.of(context)!.enterConfirmedPassword,
                            _confirmPasswordController,
                            true,
                            height,
                            fieldKey: _confirmPasswordKey,
                            validator: _confirmPasswordValidator,
                            onChanged: (_) {
                              _confirmPasswordKey.currentState?.validate();
                            },
                          ),

                          AuthButton(
                            width,
                            height,
                            AppLocalizations.of(context)!.signUp,
                            isLoading ? null : _handleSignUp,
                          ),

                          buildFooterInfo(
                            context,
                            AppLocalizations.of(context)!.alreadyHaveAccount,
                            AppLocalizations.of(context)!.login,
                                () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(height: height * .02),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              AppLocalizations.of(context)!.creatingAccount,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                decoration: TextDecoration.none,
                                decorationColor: Colors.transparent,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
