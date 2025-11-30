import 'package:flutter/material.dart';
import '../../../../../core/theme/colors.dart';
import '../widgets/background_home_Appbar.dart';
import '../widgets/build_ForegroundAppBarHome.dart';
import '../widgets/main_screen_widgets/suppliers/tapBarfirstPage.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
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
    return  Scaffold(
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
                screenWidth: screenWidth,title: 'All Products',is_returned: true,
              ),
              Positioned.fill(
                  top: MediaQuery.of(context).padding.top + screenHeight * .1,
                  child:Padding(
                    padding:  EdgeInsets.only(top: screenHeight*.03),//04 handle design shimaa

                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TabBarFirstPage(fromAllProducts:true),

                        ],
                      ),
                    ),
                  ))]));

  }
}
