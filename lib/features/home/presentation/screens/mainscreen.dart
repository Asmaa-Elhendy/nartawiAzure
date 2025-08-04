import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/tabler.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/category_card.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/custom_search_bar.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/store_card.dart';
import 'package:iconify_flutter/icons/game_icons.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../widgets/main_screen_widgets/build_carous_slider.dart';
import '../widgets/main_screen_widgets/build_tapped_blue_title.dart';
import '../widgets/main_screen_widgets/product_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
    return ListView(
   children: [
     Padding(
       padding:  EdgeInsets.symmetric(horizontal: screenWidth*.06),
       child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             CustomSearchBar(controller: _SearchController,height: screenHeight,width: screenWidth,),
             SizedBox(height: screenHeight*.02,),
             BuildCarousSlider(),
             Row(mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 GestureDetector(
                   onTap:(){},
                   child:  Padding(
                     padding:  EdgeInsets.symmetric(vertical: screenHeight*.01),
                     child: BuildTappedTitle('View All Coupons',screenWidth),
                   ),

                 )
               ],
             ),
             BuildStretchTitleHome(screenWidth, "Featured Stores"),
             SizedBox(
               height: screenHeight * 0.18, // Adjust height as needed
               child: ListView(
                 scrollDirection: Axis.horizontal,
                 children: [
                   StoreCard(screenWidth: screenWidth, screenHeight: screenHeight),
                   StoreCard(screenWidth: screenWidth, screenHeight: screenHeight),
                   StoreCard(screenWidth: screenWidth, screenHeight: screenHeight),
                   StoreCard(screenWidth: screenWidth, screenHeight: screenHeight),
                   StoreCard(screenWidth: screenWidth, screenHeight: screenHeight),
                   // Add more cards
                 ],
               ),
             ),
             BuildStretchTitleHome(screenWidth, "Popular Categories"),
             SizedBox(
               height: screenHeight * 0.15, // Adjust height as needed
               child: ListView(
                 scrollDirection: Axis.horizontal,
                 children: [
                   CategoryCard(screenWidth: screenWidth, screenHeight: screenHeight,icon:  Tabler.bottle,title: 'Bottles',),
                   CategoryCard(screenWidth: screenWidth, screenHeight: screenHeight,icon:  GameIcons.water_gallon,title: 'Gallons',),
                   CategoryCard(screenWidth: screenWidth, screenHeight: screenHeight,icon:  MaterialSymbols.water_drop_outline_rounded,title: 'Alkaline',),
                   CategoryCard(screenWidth: screenWidth, screenHeight: screenHeight,icon:  Mdi.coupon_outline,title: 'Coupons',)

                   // Add more cards
                 ],
               ),
             ),
             BuildStretchTitleHome(screenWidth, "Popular Products")
           ]),
     ),
     GridView.count(
       crossAxisCount: 2, // عدد الأعمدة
       shrinkWrap: true, // مهم جدًا لو بتحطه جوه ScrollView
       physics: NeverScrollableScrollPhysics(), // يمنع الـ Grid من الاسكرول لو فيه ScrollView أكبر
       padding: const EdgeInsets.all(16),
       crossAxisSpacing: 12,
       mainAxisSpacing: 12,
       childAspectRatio:0.48,
       children: [
         ProductCard(
           screenWidth: screenWidth,
           screenHeight: screenHeight,
           icon: 'assets/images/home/main_page/product.jpg',
           title: 'Bottle',
         ),
         ProductCard(
           screenWidth: screenWidth,
           screenHeight: screenHeight,
           icon: 'assets/images/home/main_page/product.jpg',
           title: 'Gallon',
         ),
         ProductCard(
           screenWidth: screenWidth,
           screenHeight: screenHeight,
           icon: 'assets/images/home/main_page/product.jpg',
           title: 'Alkaline',
         ),
         ProductCard(
           screenWidth: screenWidth,
           screenHeight: screenHeight,
           icon: 'assets/images/home/main_page/product.jpg',
           title: 'Coupon',
         ),
         // أضف المزيد من العناصر حسب الحاجة
       ],
     ),

   ],
    );

  }
}
