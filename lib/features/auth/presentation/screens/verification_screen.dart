import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/theme/colors.dart';
import '../widgets/auth_buttons.dart';
import '../widgets/build_title_widget.dart';


class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {





  @override
  void dispose() {
    super.dispose();
  }

  void _handleSend() {
    Navigator.pushNamed(context, '/resetPassword');

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitleWidget(context,width,'Verification'),
                SizedBox(height:height*.04,),
                Text("Enter Verification Code",style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textLight,
                )),
                buildFooterInfo(context,"If You Didn’t Receive A Code,"," Resend", (){
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
                        borderRadius: BorderRadius.circular(28), // Makes it circular
                      ),
                    ),
                    length: 4, // Number of OTP digits
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 👈 evenly stretch the fields
                    onCompleted: (pin) => print(pin),
                    //separatorBuilder: (index) => SizedBox(width: width * 0.07), // Adjust as needed

                  ),
                ),
                SizedBox(height:height*.08,),
                AuthButton(width,height,'Send',_handleSend),

              ],
            ),
          ),
        ),
      ),
    );
  }

}
