import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/components/background_logo.dart';
import '../widgets/build_title_widget.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/auth_buttons.dart';
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  void _handleLogin() {
   // if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushNamed(context, '/home');
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
  //  }
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
                  CustomeTextField(
                    iconPath: 'assets/images/auth/icon with bg.png',
                    hintText: 'Enter Email',
                    controller: _emailController,
                  ),SizedBox(height: height*.03,),
                  CustomeTextField(
                    iconPath: 'assets/images/auth/iconwithbgpassword.png',
                    hintText: 'Enter Password',
                    label: 'password',
                    controller: _passwordController,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: checkedValue,
                              onChanged: (newValue) {
                                setState(() {
                                  checkedValue = newValue!;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const Text(
                              "Remember Me",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff7B7B7B),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, '/forgetPassword');
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff7B7B7B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AuthButton(width,height,'Login',_handleLogin),
                  buildDivider('Or Login With'),
                  Padding(
                    padding:  EdgeInsets.symmetric(vertical: height*.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/auth/google.png",height: height*.051,),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: width*.08),
                          child: Image.asset("assets/images/auth/ios.png",height: height*.051),
                        ),
                        Image.asset("assets/images/auth/facebook.png",height: height*.051),
                      ],
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(vertical: height*.01),
                    child: buildDivider('Or Continue As')
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: width*.1),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomLoginButtons(width,  height,  'Guest',  (){}),

                        CustomLoginButtons(width,  height,  'Vendor',  (){}),
                      ],
                    ),
                  ),
                  SizedBox(height: height*.02,),
                  buildFooterInfo(context,'Don’t have an account?'," Sign Up",(){
                    Navigator.pushNamed(context, '/signUp');

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
