import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/tabler.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/category_card.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/custom_search_bar.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/store_card.dart';
import 'package:iconify_flutter/icons/game_icons.dart';
import '../../../../core/theme/colors.dart';
import '../widgets/background_home_Appbar.dart';
import '../widgets/build_ForegroundAppBarHome.dart';
import '../widgets/main_screen_widgets/build_carous_slider.dart';
import '../widgets/main_screen_widgets/build_tapped_blue_title.dart';
import '../widgets/main_screen_widgets/product_card.dart';

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
      extendBody: true,
      extendBodyBehindAppBar: true, // 🔥 يخلي الجسم يبدأ من أعلى الشاشة خلف الـ AppBar
      backgroundColor: Colors.transparent, // في حالة الصورة في الخلفية
      body:
      Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            color: AppColors.backgrounHome,
          ),
          buildBackgroundAppbar(screenWidth),
          BuildForegroundappbarhome(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            child: Padding(
              padding:  EdgeInsets.only(top: screenHeight*.04,bottom: screenHeight*.1),
              child: ListView(
                children: [
                  Container(
                    padding:  EdgeInsets.symmetric(vertical: screenHeight*.01,horizontal: screenWidth*.04),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.secondaryColorWithOpacity8,
                      boxShadow: [
                        BoxShadow(
                          color:AppColors.shadowColor, // ظل خفيف
                          offset: Offset(0, 2),
                          blurRadius: 20,
                          spreadRadius: 0,
                        ),
                      ],

                    ),
                    child: Row(
                      children: [
                        Container(
                          width: screenWidth*.1,
                          height: screenHeight*.05,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: ClipOval(
                              child: Image.network(
                                imageUrl ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                      'assets/images/home/main_page/person.png'
                                    //  fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Company A',style: TextStyle(fontWeight: FontWeight.w700),),
                              ],
                            ),
                            Row(mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Iconify(
                                      MaterialSymbols.star,  // This uses the Material Symbols "star" icon
                                      size: screenHeight*.025,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(width: screenWidth*.01,),
                                    Text('5.0',style: TextStyle(fontSize: screenWidth*.03,fontWeight: FontWeight.w500))
                                  ],
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),


    );

  }
}
