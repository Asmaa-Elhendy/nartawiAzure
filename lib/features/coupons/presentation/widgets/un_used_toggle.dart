import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCupertinoSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final double thumbSize; // هنا بتتحكم في حجم الكورة

  const CustomCupertinoSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.activeColor,
    this.thumbSize = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 50,
        height: thumbSize + 4,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? activeColor : Colors.grey[400],
          borderRadius: BorderRadius.circular(thumbSize),
        ),
        child: AnimatedAlign(
          duration: Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: thumbSize,
            height: thumbSize,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
