import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/custom_search_bar.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/supplier_full_card.dart';
import '../../../../../core/theme/colors.dart';
import '../../widgets/background_home_Appbar.dart';
import '../../widgets/build_ForegroundAppBarHome.dart';
import '../../widgets/main_screen_widgets/products/product_card.dart';
import '../../widgets/main_screen_widgets/suppliers/tab_bar_view.dart';

class SupplierDetails extends StatefulWidget {
  const SupplierDetails({super.key});

  @override
  State<SupplierDetails> createState() => _SupplierDetailsState();
}

class _SupplierDetailsState extends State<SupplierDetails> {
  final TextEditingController _SearchController = TextEditingController();
  @override
  void dispose() {
    _SearchController.dispose();
    super.dispose();
  }
  String? imageUrl=null;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent, // في حالة الصورة في الخلفية

        // ✅ أضف ده
        body: Stack(
          children: [
          Container(
          width: screenWidth,
          height: screenHeight,
          color: AppColors.backgrounHome,
        ),
        buildBackgroundAppbar(screenWidth),
        BuildForegroundappbarhome(
          screenHeight: screenHeight,
          screenWidth: screenWidth,title: 'Comapny A',is_returned: true,
        ),
        Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            child:Padding(
              padding:  EdgeInsets.only(top: screenHeight*.04),

              child: Column(
                children: [
                  BuildFullCardSupplier(context, screenHeight, screenWidth, false),
                  Expanded(

                      child: StackOver(width: screenWidth,height: screenHeight,)),

                ],
              ),
            ))]));

  }
}
