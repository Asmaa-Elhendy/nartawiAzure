import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/supplier_card.dart';
import '../../../../../core/theme/colors.dart';
import '../../widgets/background_home_Appbar.dart';
import '../../widgets/build_ForegroundAppBarHome.dart';

class AllSuppliersScreen extends StatefulWidget {
  const AllSuppliersScreen({super.key});

  @override
  State<AllSuppliersScreen> createState() => _AllSuppliersScreenState();
}

class _AllSuppliersScreenState extends State<AllSuppliersScreen> {
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
     backgroundColor: AppColors.whiteColor, // في حالة الصورة في الخلفية
      body:
      Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            color: AppColors.whiteColor,
          ),
          buildBackgroundAppbar(screenWidth),
          BuildForegroundappbarhome(
            screenHeight: screenHeight,
            screenWidth: screenWidth,title: 'Water Suppliers',is_returned: true,
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            child: Padding(
              padding:  EdgeInsets.only(top: screenHeight*.04,right: screenWidth*.03,left:screenWidth*.03 ),
              child: SizedBox(height: screenHeight*.8,
                child: ListView(
                  children: [
                    BuildCardSupplier(screenHeight, screenWidth,true),
                    BuildCardSupplier(screenHeight, screenWidth,false),
                    BuildCardSupplier(screenHeight, screenWidth,true),
                    BuildCardSupplier(screenHeight, screenWidth,false),
                    BuildCardSupplier(screenHeight, screenWidth,true),
                    BuildCardSupplier(screenHeight, screenWidth,false),
                  ],

                ),
              ),
            ),
          ),
        ],
      ),


    );

  }
}
