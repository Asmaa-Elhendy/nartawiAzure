import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/components/background_logo.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/build_custome_full_text_field.dart';
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

  @override
  void dispose() {
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // Form is valid, proceed with login
      print('Email: ${_confirmPasswordController.text}');
      print('Password: ${_passwordController.text}');
    }
  }
  void _handleSend() {
    Navigator.pushNamed(context, '/home');

  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
                  buildCustomeFullTextField('Enter New Password', 'Enter NewPassword ', _passwordController, true,height),
                  buildCustomeFullTextField('Confirm Password', 'Enter Confirmed Password', _confirmPasswordController, true,height),
                  SizedBox(height:height*.06,),
                  AuthButton(width,height,'Send',_handleSend),

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
