import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/tabler.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/category_card.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/custom_search_bar.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/store_card.dart';
import 'package:iconify_flutter/icons/game_icons.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../widgets/build_carous_slider.dart';
import '../widgets/build_tapped_blue_title.dart';

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


   ],
    );

  }
}
