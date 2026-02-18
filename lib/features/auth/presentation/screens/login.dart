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
import '../../../../l10n/app_localizations.dart';

import '../../../../core/utils/components/background_logo.dart';
import '../../../Delivery_Man/home/presentation/screens/home_delivery.dart';
import '../bloc/login_state.dart';
import '../widgets/build_title_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool('remember_me') ?? false;

    debugPrint('🔵 remember_me: $remember');

    if (!mounted) return;

    if (remember) {
      setState(() {
        checkedValue = true;
        _emailController.text = prefs.getString('saved_email') ?? '';
        _passwordController.text = prefs.getString('saved_password') ?? '';
      });

      debugPrint(
        '✅ Loaded email: ${_emailController.text}, password: ${_passwordController.text}',
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    context.read<AuthBloc>().add(
      PerformLogin(_emailController.text.trim(), _passwordController.text),
    );
  }

  Future<void> _handleRememberMeOnSuccess() async {
    final prefs = await SharedPreferences.getInstance();

    if (checkedValue) {
      await prefs.setBool('remember_me', true);
      await prefs.setString('saved_email', _emailController.text.trim());
      await prefs.setString('saved_password', _passwordController.text);

      debugPrint('✅ Saved remember_me + credentials');
    } else {
      await prefs.remove('remember_me');
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');

      debugPrint('🧹 Cleared saved credentials');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    const dividerColor = AppColors.BorderAnddividerAndIconColor;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocConsumer<AuthBloc, AuthState>(
        // 👈 خليه async عشان نقدر نـ await
        listener: (context, state) async {
          if (state is LoginSuccess) {
            // ✅ استنى لما يحفظ الأول
            await _handleRememberMeOnSuccess();

            // Check if user has Delivery role
            if (state.roles.contains('Delivery')) {
              debugPrint(
                '✅ User has Delivery role, navigating to delivery home',
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainScreenDelivery()),
              );
            } else {
              // Regular client navigation
              Navigator.pushReplacementNamed(context, '/home');
            }
          }

          if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is LoginLoading;

          return Stack(
            children: [
              Scaffold(
                body: Padding(
                  padding: EdgeInsets.only(
                    right: width * 0.04,
                    left: width * 0.04,
                    bottom: height * 0.06,
                  ),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        BuildBackgroundLogo(width, height),

                        SizedBox(height: height * 0.03),

                        CustomeTextField(
                          iconPath: 'assets/images/auth/icon with bg.png',
                          hintText: AppLocalizations.of(context)!.enterEmail,
                          controller: _emailController,
                        ),

                        SizedBox(height: height * 0.03),

                        CustomeTextField(
                          iconPath: 'assets/images/auth/iconwithbgpassword.png',
                          hintText: AppLocalizations.of(context)!.enterPassword,
                          label: AppLocalizations.of(context)!.password,
                          controller: _passwordController,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: checkedValue,
                                    activeColor: AppColors.primary,
                                    onChanged: (newValue) {
                                      setState(() => checkedValue = newValue!);
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.rememberMe,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff7B7B7B),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/forgetPassword',
                                  );
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.forgotPassword,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        AuthButton(width, height, AppLocalizations.of(context)!.login, () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _handleLogin();
                          }
                        }),
                        SizedBox(height: height * .02),

                        //        _buildDivider('Or Login With', dividerColor),

                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //     vertical: height * 0.01,
                        //   ),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Image.asset(
                        //         "assets/images/auth/google.png",
                        //         height: height * 0.051,
                        //       ),
                        //       Padding(
                        //         padding: EdgeInsets.symmetric(
                        //           horizontal: width * 0.08,
                        //         ),
                        //         child: Image.asset(
                        //           "assets/images/auth/ios.png",
                        //           height: height * 0.051,
                        //         ),
                        //       ),
                        //       Image.asset(
                        //         "assets/images/auth/facebook.png",
                        //         height: height * 0.051,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        _buildDivider(AppLocalizations.of(context)!.orContinueAs, dividerColor),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.1,
                            vertical: height * 0.01,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomLoginButtons(
                                width,
                                height,
                                AppLocalizations.of(context)!.guest,
                                () {}, //  _handleLogin,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: height * 0.02),

                        buildFooterInfo(
                          context,
                          AppLocalizations.of(context)!.dontHaveAccount,
                          AppLocalizations.of(context)!.signUp,
                          () {
                            Navigator.pushNamed(context, '/signUp');
                          },
                        ),

                        SizedBox(height: height * 0.02),
                      ],
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
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            SelectionContainer.disabled(
                              child: Text(
                                AppLocalizations.of(context)!.loggingIn,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  decoration: TextDecoration.none,
                                  // لا underline
                                  decorationColor: Colors.transparent,
                                  backgroundColor:
                                      Colors.transparent, // لو في أي هايلايت
                                ),
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

  Widget _buildDivider(String text, Color color) {
    return Row(
      children: <Widget>[
        Expanded(child: Divider(color: color, thickness: 1.0)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
        Expanded(child: Divider(color: color, thickness: 1.0)),
      ],
    );
  }
}
