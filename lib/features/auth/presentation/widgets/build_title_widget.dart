import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';

Widget buildTitleWidget(BuildContext context,double width,String title){
  return  Row(
    children: [
      GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Padding(
          padding:  EdgeInsets.only(right: width*.025),
          child: Iconify(
            MaterialSymbols.arrow_back_ios,
            size: 18,
            color: AppColors.textLight,
          ),
        ),
      ),
      Text(title,style:AppTextStyles.TitlePage,)
    ],
  );
}

Widget buildFooterInfo(BuildContext context,String leftText,String rightText,void Function()? fun,){
  return Row(
    mainAxisAlignment: rightText==" Resend"?MainAxisAlignment.start:MainAxisAlignment.center,
    children: [

      Text(leftText,style: TextStyle(fontSize: 15,color: AppColors.textLight),),
      GestureDetector(
          onTap:fun,
          child: Text(rightText,style: TextStyle(color: AppColors.primary,fontSize: 15),))
    ],
  );
}

