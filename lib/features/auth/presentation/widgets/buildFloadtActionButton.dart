
import 'package:flutter/material.dart';
Widget BuildFloatActionButton(int _tabCount,onTabTapped,Widget logoCenter){
  return FloatingActionButton(
    //backgroundColor: AppColors.primary,
    backgroundColor: Colors.transparent,
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(40)),
    ),
    onPressed: () {
      final middleTab = (_tabCount / 2).floor(); // 🧠 احسبي النص
      onTabTapped(middleTab);
    },
    child: logoCenter,
  );
}