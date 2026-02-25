import 'package:flutter/material.dart';
import 'package:newwwwwwww/features/home/domain/models/product_model.dart';
import '../../../../../core/theme/colors.dart';
import '../widgets/background_home_Appbar.dart';
import '../widgets/build_ForegroundAppBarHome.dart';
import '../widgets/main_screen_widgets/suppliers/tapBarfirstPage.dart';
import '../../../../../../l10n/app_localizations.dart';

class AllProductScreen extends StatefulWidget {
  final bool? isBundle;

  const AllProductScreen({super.key, this.isBundle});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  final TextEditingController _SearchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    _SearchController.dispose();
    
    // Note: Removed BLoC refresh from dispose to avoid "deactivated widget" error
    // The refresh is now handled by MainScreen's didChangeDependencies method
    
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
                screenWidth: screenWidth,
                title: widget.isBundle == true 
                    ? AppLocalizations.of(context)!.allBundles 
                    : AppLocalizations.of(context)!.allProducts,
                is_returned: true,
              ),
              Positioned.fill(
                  top: MediaQuery.of(context).padding.top + screenHeight * .1,
                  bottom: screenHeight*.05,
                  child:Padding(
                    padding:  EdgeInsets.only(top: screenHeight*.03,
                     bottom: screenHeight*.09,//top 03
                    ),//04 handle design shimaa

                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TabBarFirstPage(
                            fromAllProducts: true,
                            category: null,
                            supplier: null,
                            isBundle: widget.isBundle,
                          ),

                        ],
                      ),
                    ),
                  ))]));

  }
}
