// import 'package:flutter/material.dart';
// import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/custom_search_bar.dart';
// import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/supplier_full_card.dart';
// import '../../../../../core/theme/colors.dart';
// import '../../widgets/background_home_Appbar.dart';
// import '../../widgets/build_ForegroundAppBarHome.dart';
// import '../../widgets/main_screen_widgets/products/product_card.dart';
// import '../../widgets/main_screen_widgets/suppliers/tab_bar_view.dart';
//
// class SupplierDetails extends StatefulWidget {
//   const SupplierDetails({super.key});
//
//   @override
//   State<SupplierDetails> createState() => _SupplierDetailsState();
// }
//
// class _SupplierDetailsState extends State<SupplierDetails> {
//   final TextEditingController _SearchController = TextEditingController();
//
//   @override
//   void dispose() {
//     _SearchController.dispose();
//     super.dispose();
//   }
//   String? imageUrl=null;
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     return  Scaffold(
//         extendBody: true,
//         backgroundColor: Colors.transparent, // في حالة الصورة في الخلفية
//         resizeToAvoidBottomInset: true, // مهم عشان يتصرف مع الكيبورد
//
//         // ✅ أضف ده
//         body: Stack(
//           children: [
//           Container(
//           width: screenWidth,
//           height: screenHeight,
//           color: AppColors.backgrounHome,
//         ),
//         buildBackgroundAppbar(screenWidth),
//         BuildForegroundappbarhome(
//           screenHeight: screenHeight,
//           screenWidth: screenWidth,title: 'Comapny A',is_returned: true,
//         ),
//         Positioned.fill(
//             top: MediaQuery.of(context).padding.top + screenHeight * .1,
//             child:Padding(
//               padding:  EdgeInsets.only(top: screenHeight*.04),
//
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     BuildFullCardSupplier(screenHeight, screenWidth, false),
// //                     SizedBox(
// // height: screenHeight*.6,
// //                         child:
//                         StackOver(width: screenWidth,height: screenHeight,)
//                     //),
//
//                   ],
//                 ),
//               ),
//             ))]));
//
//   }
// }

import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/supplier_full_card.dart';
import '../../../../../core/theme/colors.dart';
import '../../widgets/background_home_Appbar.dart';
import '../../widgets/build_ForegroundAppBarHome.dart';
import '../../widgets/main_screen_widgets/suppliers/tab_bar_view.dart';

class SupplierDetails extends StatefulWidget {
  const SupplierDetails({super.key});

  @override
  State<SupplierDetails> createState() => _SupplierDetailsState();
}

class _SupplierDetailsState extends State<SupplierDetails> {
  final TextEditingController _searchController = TextEditingController();
  String? imageUrl = null;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // الخلفية
          Container(
            width: screenWidth,
            height: screenHeight,
            color: AppColors.backgrounHome,
          ),

          // الـ AppBar اللي في الخلفية
          buildBackgroundAppbar(screenWidth),

          // الـ AppBar اللي فوق
          BuildForegroundappbarhome(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            title: 'Company A',
            is_returned: true,
          ),

          // 👇 جسم الصفحة كله
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            bottom: screenHeight*.05,
            child: Padding(
              padding: EdgeInsets.only(

                  bottom: screenHeight*.09,
                  top: 0//screenHeight * .03
              ),//04 handle design shimaa
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(), // 👈 مافيش بونس زيادة
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // الكارت
                          BuildFullCardSupplier(
                            screenHeight,
                            screenWidth,
                            false,
                          ),

                          SizedBox(height: screenHeight * .01),//handle design

                          // التاب بار + محتوى التابز
                          StackOver(
                            width: screenWidth,
                            height: screenHeight,
                          ),
                        ],
                      ),
                    ),
                  );//k
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
