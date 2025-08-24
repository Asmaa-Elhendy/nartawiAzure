
import 'dart:developer';

import 'package:flutter/material.dart';
Widget BuildFloatActionButton(int _tabIndex,Widget logoCenter,List<GlobalKey<NavigatorState>> _navigatorKeys){
  return FloatingActionButton(
    //backgroundColor: AppColors.primary,
    backgroundColor: Colors.transparent,
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(40)),
    ),
    onPressed: () {
      final middleTab = (_tabIndex / 2).floor(); // 🧠 احسبي النص

    log(_tabIndex.toString());

        _navigatorKeys[_tabIndex].currentState!.popUntil((route) => route.isFirst);


    },
    child: logoCenter,
  );
}