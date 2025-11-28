import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/components/background_logo.dart';
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
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emergencyphonenumberController = TextEditingController();
  final TextEditingController  _emailController= TextEditingController();


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
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushNamed(context, '/home');
      print('user name: ${_userNameController.text}');
      print('Password: ${_passwordController.text}');
    }
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
                  BuildBackgroundLogo(width,height),//username
                  buildCustomeFullTextField('UserName', 'Enter Username', _userNameController, true,height),
                  buildCustomeFullTextField('First Name', 'Enter First Name', _firstNameController, true,height),
                  buildCustomeFullTextField('Middle Name', 'Enter Middle Name', _middleNameController, false,height),
                  buildCustomeFullTextField('Last Name', 'Enter Last Name', _lastNameController, true,height),
                  buildCustomeFullTextField('Email Address', 'Ex: abc@example.com', _emailController, true,height),
                  buildCustomeFullTextField('Phone', 'Enter Phone Number', _phoneNumberController, true,height),
                  buildInfoPhoneInfo(width),
                  buildCustomeFullTextField('Alternative Phone Number', 'Enter Alternative phone number', _emergencyphonenumberController, false,height),
                  buildInfoPhoneInfo(width),
                  buildCustomeFullTextField('Password', 'Enter Password ', _passwordController, true,height),
                  buildCustomeFullTextField('Confirm Password', 'Enter Confirmed Password', _confirmPasswordController, true,height),
                  AuthButton(width,height,'SignUp',_handleSignUp),


                  buildFooterInfo(context,'Already have an account?',"Login", (){
                    Navigator.pop(context);

                  }),
                  SizedBox(height: height*.02,),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
