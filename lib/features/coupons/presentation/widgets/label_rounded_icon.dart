// import 'package:flutter/material.dart';
// import 'package:iconify_flutter/iconify_flutter.dart';
// import 'package:iconify_flutter/icons/ic.dart';
//
// import '../../../../core/theme/colors.dart';
//
// Widget LabledBuildRoundedIconOnProduct({
//   required BuildContext context,
//   required double width,
//   required double height,
//   required bool isPlus,
//   int price = 0,
//   required VoidCallback onIncrease,
//   required VoidCallback onDecrease,
//   required TextEditingController quantityCntroller,
//   ValueChanged<String>? onTextfieldChanged,
//   VoidCallback? onDone,
//   bool fromDetailedScreen=false,
//   required String title
// }){
//   return Container(
//     padding: fromDetailedScreen?EdgeInsets.symmetric(horizontal: width*.02):EdgeInsets.zero,
//     width:fromDetailedScreen?width*.6:isPlus?width*.2:width*.15, // الحجم العرض
//     height: height*.045, // الحجم الارتفاع
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(20),
//       color: AppColors.backgrounHome, // لون الخلفية
//       shape: BoxShape.rectangle, // يجعله دائري
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.1),
//           blurRadius: 4,
//           offset: Offset(0, 2),
//         ),
//       ],
//     ),
//     child: Center(
//         child:
//         //  isPlus?
//         Row(
//           mainAxisAlignment:fromDetailedScreen? MainAxisAlignment.spaceBetween: MainAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: onDecrease,
//               child: Iconify(
//                 Ic.baseline_minus, // استبدلها بالأيقونة اللي تحبها
//                 size: height*.03,
//                 color: AppColors.redColor,
//               ),
//             ),
//
//             Text(quantityCntroller.text+' '+title,style: TextStyle(fontWeight: FontWeight.w700,fontSize: width*.034),),
//             GestureDetector(
//               onTap: onIncrease,
//               child: Icon(
//                 Icons.add, // استبدلها بالأيقونة اللي تحبها
//                 size: height*.03,
//                 color: AppColors.greenColor,
//               ),
//             )
//
//           ],
//         )
//       //:
//       // Row(
//       //   mainAxisAlignment: MainAxisAlignment.center,
//       //   children: [
//       //
//       //     Center(
//       //       child: Padding(
//       //         padding:  EdgeInsets.symmetric(horizontal: width*.01),
//       //         child: Text('$price',style: TextStyle(fontWeight: FontWeight.w700),),
//       //       ),
//       //     ),
//       //
//       //
//       //   ],
//       // )
//     ),
//   );
// }