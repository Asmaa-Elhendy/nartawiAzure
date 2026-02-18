import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../../core/services/dio_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/components/background_logo.dart';
import '../bloc/login_bloc.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/build_custome_full_text_field.dart';
import '../../../../../../l10n/app_localizations.dart';
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.passwordsDoNotMatch),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.passwordMin8Chars),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final email = args['email'];
      final verificationToken = args['verificationToken'];

      final dio = DioService.dio; // Use DioService.dio for Dio initialization
      final response = await dio.post(
        '$base_url/v1/auth/reset-password',
        data: {
          'email': email,
          'verificationToken': verificationToken,
          'newPassword': _passwordController.text,
        },
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.passwordResetSuccess),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.passwordResetFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleSend() {
    _resetPassword();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                  BuildBackgroundLogo(width,height),
                  buildCustomeFullTextField(AppLocalizations.of(context)!.enterNewPassword, AppLocalizations.of(context)!.enterNewPasswordHint, _passwordController, true,height),
                  buildCustomeFullTextField(AppLocalizations.of(context)!.confirmNewPassword, AppLocalizations.of(context)!.enterConfirmedPassword, _confirmPasswordController, true,height),
                  SizedBox(height:height*.06,),
                  AuthButton(width,height,AppLocalizations.of(context)!.send,_handleSend),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  buildDivider(String text){
    return    Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            color:AppColors.BorderAnddividerAndIconColor, // Customize divider color
            thickness: 1.0,    // Customize divider thickness
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400,color: AppColors.BorderAnddividerAndIconColor,),
          ),
        ),
        Expanded(
          child: Divider(
            color:AppColors.BorderAnddividerAndIconColor,
            thickness: 1.0,
          ),
        ),
      ],
    );
  }
}
