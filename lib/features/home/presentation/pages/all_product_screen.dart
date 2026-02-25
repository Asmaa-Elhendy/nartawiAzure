import 'package:flutter/material.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '../widgets/background_home_Appbar.dart';
import '../widgets/build_ForegroundAppBarHome.dart';
import '../widgets/main_screen_widgets/suppliers/tapBarfirstPage.dart';

class AllProductScreen extends StatefulWidget {
  final bool? isBundle;

  const AllProductScreen({super.key, this.isBundle});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  final TextEditingController _searchController = TextEditingController();

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
            title: widget.isBundle == true
                ? AppLocalizations.of(context)!.allBundles
                : AppLocalizations.of(context)!.allProducts,
            is_returned: true,
          ),

          /// ✅ هنا بقى: TabBarFirstPage هي اللي بتعمل Scroll لوحدها
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + screenHeight * .1,
            bottom: screenHeight * .05,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * .03,
                bottom: screenHeight * .09,
              ),
              child: TabBarFirstPage(
                fromAllProducts: true,
                category: null,
                supplier: null,
                isBundle: widget.isBundle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}