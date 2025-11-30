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
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  List<bool> _suppliersData = List.generate(10, (index) => index.isEven);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore) {
      _loadMoreSuppliers();
    }
  }

  Future<void> _loadMoreSuppliers() async {
    setState(() => _isLoadingMore = true);

    // محاكاة تحميل بيانات جديدة
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _suppliersData.addAll(List.generate(5, (index) => index.isEven));
      _isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final paddingTop = mediaQuery.padding.top;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          const SizedBox.expand(),
          buildBackgroundAppbar(screenWidth),
          BuildForegroundappbarhome(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            title: 'Water Suppliers',
            is_returned: true,
          ),
          Positioned.fill(
            top: paddingTop + screenHeight * .1,
            bottom: screenHeight*.05,
            child: Padding(
              padding: EdgeInsets.only(
           //     top: screenHeight * .03,//05 handle design shimaa
                right: screenWidth * .037,
                left: screenWidth * .037,
                bottom: screenHeight*.09
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.zero,
                itemCount: _suppliersData.length + (_isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _suppliersData.length) {
                    return BuildCardSupplier(
                      context,
                      screenHeight,
                      screenWidth,
                      _suppliersData[index],
                    );
                  } else {
                    // Loader في أسفل الصفحة
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
