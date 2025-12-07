import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/components/background_logo.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import '../widgets/auth_buttons.dart';
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

  void _handleSignUp() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password & Confirm Password do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final fullName =
    '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'
        .trim();

    debugPrint('📤 Register payload:'
        '\nusername: ${_userNameController.text.trim()}'
        '\nemail: ${_emailController.text.trim()}'
        '\nfullName: $fullName'
        '\nphone: ${_phoneNumberController.text.trim()}');

    context.read<AuthBloc>().add(
      PerformRegister(
        username: _userNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: fullName,
        phoneNumber: _phoneNumberController.text.trim(), confirmPassword: _confirmPasswordController.text,
        // role: 'Client', // مش لازم تبعتيها هنا لو ليها default في الـ event
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
            // ✅ رجوع لصفحة اللوجين بعد ما الأكاونت يتعمل
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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BuildBackgroundLogo(width, height),

                          // username (required = true)
                          buildCustomeFullTextField(
                            'UserName',
                            'Enter Username',
                            _userNameController,
                            true, // required
                            height,
                          ),

                          // first name (required)
                          buildCustomeFullTextField(
                            'First Name',
                            'Enter First Name',
                            _firstNameController,
                            true, // required
                            height,
                          ),

                          // last name (required)
                          buildCustomeFullTextField(
                            'Last Name',
                            'Enter Last Name',
                            _lastNameController,
                            true, // required
                            height,
                          ),

                          // email (required)
                          buildCustomeFullTextField(
                            'Email Address',
                            'Ex: abc@example.com',
                            _emailController,
                            true, // required
                            height,
                          ),

                          // phone (required)
                          buildCustomeFullTextField(
                            'Phone',
                            'Enter Phone Number',
                            _phoneNumberController,
                            true, // required
                            height,
                          ),
                          buildInfoPhoneInfo(width),

                          // alternative phone (optional)
                          buildCustomeFullTextField(
                            'Alternative Phone Number',
                            'Enter Alternative phone number',
                            _emergencyphonenumberController,
                            false, // NOT required
                            height,
                          ),
                          buildInfoPhoneInfo(width),

                          // password (required)
                          buildCustomeFullTextField(
                            'Password',
                            'Enter Password ',
                            _passwordController,
                            true, // required
                            height,
                          ),

                          // confirm password (required)
                          buildCustomeFullTextField(
                            'Confirm Password',
                            'Enter Confirmed Password',
                            _confirmPasswordController,
                            true, // required
                            height,
                          ),

                          // 🔵 زرار SignUp – يتقفل بس لو في Loading
                          AuthButton(
                            width,
                            height,
                            'SignUp',
                            isLoading ? null : _handleSignUp,
                          ),

                          buildFooterInfo(
                            context,
                            'Already have an account?',
                            " Login",
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

              // 🔥 overlay اللودينج
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
                          children: const [
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
                              'Creating account...',
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
