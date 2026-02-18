import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:dio/dio.dart';
import 'package:newwwwwwww/core/services/dio_service.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/login_bloc.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/build_title_widget.dart';
import '../../../../../../l10n/app_localizations.dart';


class VerificationScreen extends StatefulWidget {
  final String email;
  
  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String _otpCode = '';
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _verifyOTP() async {
    if (_otpCode.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseEnter4DigitOTP),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final dio = DioService.dio;
      final response = await dio.post(
        '$base_url/v1/auth/verify-otp',
        data: {
          'email': widget.email,
          'otp': _otpCode,
        },
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.otpVerifiedSuccess),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushNamed(
          context,
          '/resetPassword',
          arguments: {
            'email': widget.email,
            'verificationToken': response.data['verificationToken'],
          },
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.invalidOTP),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleSend() {
    _verifyOTP();
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitleWidget(context,width,AppLocalizations.of(context)!.verification),
                SizedBox(height:height*.04,),
                Text(AppLocalizations.of(context)!.enterVerificationCode,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textLight,
                )),
                buildFooterInfo(context,AppLocalizations.of(context)!.ifDidntReceiveCode,AppLocalizations.of(context)!.resend, (){
                  Navigator.pop(context);

                }),
                SizedBox(height: height*.07,),
                Center(
                  child: Pinput(
                    defaultPinTheme: PinTheme(
                      width: width*.12,
                      height: height*.065,
                      textStyle: TextStyle(fontSize: 20, color: AppColors.textLight, fontWeight: FontWeight.w500),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    length: 4,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    onChanged: (pin) => setState(() => _otpCode = pin),
                    onCompleted: (pin) => setState(() => _otpCode = pin),
                  ),
                ),
                SizedBox(height:height*.08,),
                AuthButton(width,height,AppLocalizations.of(context)!.send,_handleSend),

              ],
            ),
          ),
        ),
      ),
    );
  }

}
