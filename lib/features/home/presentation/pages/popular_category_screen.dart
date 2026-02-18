import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/supplier_full_card.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../domain/models/product_categories_models/product_category_model.dart';
import '../bloc/products_bloc/products_bloc.dart';
import '../bloc/products_bloc/products_event.dart';
import '../widgets/background_home_Appbar.dart';
import '../widgets/build_ForegroundAppBarHome.dart';
import '../widgets/main_screen_widgets/suppliers/tapBarfirstPage.dart';

// Helper method to safely extract category name
String _getCategoryName(BuildContext context, ProductCategory category) {
  try {
    if (AppLocalizations.of(context)!.localeName == 'ar') {
      return category.arName;
    } else {
      if (category.enName is String) {
        return category.enName;
      } else if (category.enName is Map) {
        final nameMap = category.enName as Map;
        return nameMap['enName']?.toString() ?? 
               nameMap['arName']?.toString() ??
               category.enName.toString();
      } else {
        return category.enName.toString();
      }
    }
  } catch (e) {
    return AppLocalizations.of(context)!.localeName == 'ar' 
        ? category.arName 
        : category.enName.toString();
  }
}

class PopularCategoryScreen extends StatefulWidget {

  ProductCategory category;
  PopularCategoryScreen({required this.category});

  @override
  State<PopularCategoryScreen> createState() =>
      _PopularCategoryScreenState();
}

class _PopularCategoryScreenState extends State<PopularCategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
@override
  void initState() {
    // TODO: implement initState
    super.initState();

}
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final topPadding = mediaQuery.padding.top;

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
            title: _getCategoryName(context, widget.category),
            is_returned: true,
          ),
          Positioned.fill(
            top: topPadding + screenHeight * .1,
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * .03,bottom: screenHeight*.09),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TabBarFirstPage(category: widget.category,supplier: null,),
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
