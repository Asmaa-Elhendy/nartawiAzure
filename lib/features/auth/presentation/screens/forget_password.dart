import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/build_custome_full_text_field.dart';
import '../widgets/build_title_widget.dart';
import '../../../../../../l10n/app_localizations.dart';


class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();




  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pushNamed(context, '/verification');
      print('Password: ${_emailController.text}');

      context.read<AuthBloc>().add(
        SendOtp(email: _emailController.text.trim()),
      );

    }
  }
  void _handleBackToLogin() {
    if (_formKey.currentState?.validate() ?? false) {
   Navigator.pop(context);
      print('Password: ${_emailController.text}');
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
                  buildTitleWidget(context,width,AppLocalizations.of(context)!.forgetPassword),
                  SizedBox(height:height*.04,),
                  buildCustomeFullTextField(AppLocalizations.of(context)!.enterMobileOrEmail, AppLocalizations.of(context)!.enterMobileOrEmailHint, _emailController, true,height),
                  SizedBox(height:height*.08,),
                  AuthButton(width,height,AppLocalizations.of(context)!.send,_handleSend),
                  OutlineAuthButton(width,height, AppLocalizations.of(context)!.backToLogin, _handleBackToLogin)

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
