
import 'dart:developer';

import 'package:flutter/material.dart';
Widget BuildFloatActionButton(
    int tabIndex,
    Widget logoCenter,
    List<GlobalKey<NavigatorState>> navigatorKeys,
    ) {
  return FloatingActionButton(
    backgroundColor: Colors.transparent,
    elevation: 0,
    shape: const CircleBorder(), // 👈 دايرة نضيييفة
    onPressed: () {
      final middleTab = (tabIndex / 2).floor();
      log(tabIndex.toString());

      navigatorKeys[tabIndex]
          .currentState!
          .popUntil((route) => route.isFirst);
    },
    child: logoCenter,
  );
}
