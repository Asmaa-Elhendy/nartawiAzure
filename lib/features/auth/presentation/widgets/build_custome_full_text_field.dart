import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/auth/presentation/widgets/signup_textfield.dart';

import '../../../../core/theme/text_styles.dart';

buildCustomeFullTextField(String label,String hintText,TextEditingController controller,bool required,double height,{bool fromEditProfile=false}){
  return Padding(
    padding:  EdgeInsets.only(top:height*.01 ),
    child: Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,style: AppTextStyles.LabelInTextField,),
            if(required)
              Image.asset("assets/images/auth/required.png")


          ],),SizedBox(height: height*.01,),
        SignUpTextField(hintText:hintText,label: label,controller: controller,required:required,fromEditProfile: fromEditProfile,),
      ],
    ),
  );
}
