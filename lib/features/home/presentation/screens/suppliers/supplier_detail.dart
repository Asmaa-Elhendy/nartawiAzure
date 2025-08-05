import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/custom_search_bar.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/supplier_full_card.dart';
import '../../../../../core/theme/colors.dart';
import '../../widgets/background_home_Appbar.dart';
import '../../widgets/build_ForegroundAppBarHome.dart';
import '../../widgets/main_screen_widgets/product_card.dart';

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

              child: SingleChildScrollView(
                child: Column(//k
                  children: [
                    BuildFullCardSupplier(context, screenHeight, screenWidth, false),
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
                ),
              ),
            ))]));

  }
}
