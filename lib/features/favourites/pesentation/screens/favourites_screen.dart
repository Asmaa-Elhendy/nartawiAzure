import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/supplier_full_card.dart';
import '../../../../core/theme/colors.dart';
import '../../../home/presentation/pages/suppliers/supplier_detail.dart';
import '../../../home/presentation/widgets/background_home_Appbar.dart';
import '../../../home/presentation/widgets/build_ForegroundAppBarHome.dart';
import '../../../orders/presentation/widgets/order_card.dart';
import '../widgets/favourite_product_card.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen>  with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String? imageUrl = null;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      // 🔥 يخلي الجسم يبدأ من أعلى الشاشة خلف الـ AppBar
      backgroundColor: Colors.transparent,
      // في حالة الصورة في الخلفية
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
            screenWidth: screenWidth,
            title: 'Favourites',
            is_returned: false,//edit back from orders
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            bottom: screenHeight*.05,
            child: Padding(
              padding: EdgeInsets.only(
         //       top: screenHeight * 0.03,//04 handle design shimaa
                bottom: screenHeight * .1,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: screenHeight*.004,horizontal: screenWidth*.004),
                        margin: EdgeInsets.only(left: .06*screenWidth,right:.06*screenWidth,bottom: screenHeight*.03),
                        height: screenHeight*.05,
                        // width: widget.width-widget.width*.04,
                        decoration: BoxDecoration(
                          color: AppColors.tabViewBackground,
                          borderRadius: BorderRadius.circular(
                            8,
                          ),

                        ),
                        child:
                        TabBar(
                          padding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.symmetric(horizontal: screenWidth*.01),
                          controller: _tabController,
                          // give the indicator a decoration (color and border radius)
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              8,
                            ),

                            color: AppColors.whiteColor,
                          ),indicatorSize: TabBarIndicatorSize.tab,dividerColor: Colors.transparent,
                          labelStyle: TextStyle(fontWeight: FontWeight.w600,color: AppColors.primary),
                          unselectedLabelColor: AppColors.greyDarktextIntExtFieldAndIconsHome,

                          tabs: [
                            // first tab [you can add an icon using the icon property]
                            SizedBox(
                              width:screenWidth*.5,
                              child: Tab(
                                text: 'Products',

                              ),
                            ),

                            // second tab [you can add an icon using the icon property]
                            SizedBox(
                              width:screenWidth*.5,
                              child: Tab(
                                text: 'Stores',
                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight*.65,
                        child: TabBarView(
                          controller: _tabController,

                          children: [
                            Container(
                              child: ListView.builder(
                        padding: EdgeInsets.only(bottom: screenHeight * 0.06),
                        itemCount: 3,
                        itemBuilder: (context, index) => FavouriteProductCard(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          icon: 'assets/images/home/main_page/product.jpg',
                        ),
                            ) // first tab bar view widget
                            ,),
                            Container(
                              child: // Stores Tab
                              ListView.builder(padding: EdgeInsets.zero,//handle design shimaa height under app bar favourite store page
                                itemCount: 4,
                                itemBuilder: (context, index) => InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SupplierDetails()));

                                  },
                                  child: BuildFullCardSupplier(
                                    screenHeight ,
                                    screenWidth,
                                    index.isEven,
                                    fromFavouritesScreen: true,
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
