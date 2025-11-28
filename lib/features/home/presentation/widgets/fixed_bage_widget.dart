import 'package:flutter/material.dart';

Widget buildFixedBadge({
  required double size,
  required String text,
  required Color color,
  required double fontSize,
}) {
  return SizedBox(
    width: size,
    height: size,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(2), // 👈 padding ثابت لكل البادجات
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    ),
  );
}