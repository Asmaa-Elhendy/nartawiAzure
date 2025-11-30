import 'package:flutter/material.dart';
import 'package:newwwwwwww/core/theme/colors.dart';

import '../custom_search_bar.dart';
import '../products/product_card.dart';
import 'build_filter_button.dart';
import 'filter_overlay.dart';

class TabBarFirstPage extends StatefulWidget {
  final bool fromAllProducts;
  const TabBarFirstPage({super.key, this.fromAllProducts = false});

  @override
  State<TabBarFirstPage> createState() => _TabBarFirstPageState();
}

class _TabBarFirstPageState extends State<TabBarFirstPage> {
  final Set<String> selectedFilters = {};
  final Set<String> tags = {'small bottles', 'gallons', 'under QAE 50', 'spring water'};

  OverlayEntry? _overlayEntry;
  final GlobalKey _searchBarKey = GlobalKey();
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _hideFilterMenu();
    super.dispose();
  }

  List<Widget> generateTags(double width, double height) {
    return tags.map((tag) => getChip(tag, width, height)).toList();
  }

  Widget getChip(String name, double width, double height) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * .015,
        vertical: height * .008,
      ),
      decoration: BoxDecoration(
        color: AppColors.greyDarktextIntExtFieldAndIconsHome,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: width * .031,
              fontWeight: FontWeight.w600,
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                tags.remove(name);
              });
            },
            child: Padding(
              padding: EdgeInsets.only(right: width * .01, left: width * .02),
              child: Icon(Icons.close, color: AppColors.whiteColor, size: width * .042),
            ),
          )
        ],
      ),
    );
  }

  void _toggleFilterMenu() {
    if (_overlayEntry == null) {
      _showFilterMenu();
    } else {
      _hideFilterMenu();
    }
  }

  void _showFilterMenu() {
    final renderBox = _searchBarKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = buildFilterOverlay(
      context: context,
      offset: offset,
      width: size.width,
      height: size.height,
      selectedFilters: selectedFilters,
      onClose: _hideFilterMenu,
      onChanged: () {
        // Rebuild parent to reflect tag visibility when filters change
        setState(() {});
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideFilterMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // دي عشان التجربة، خلي عندك list من المنتجات
    final products = List.generate(15, (index) => "Product $index");

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomSearchBar(
                  key: _searchBarKey,
                  controller: _searchController,
                  height: screenHeight,
                  width: screenWidth,
                  fromSupplierDetail: true,
                ),
                BuildFilterButton(
                  screenWidth,
                  screenHeight,
                  _toggleFilterMenu,
                ),
              ],
            ),
            selectedFilters.isNotEmpty
                ? Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: generateTags(screenWidth, screenHeight),
                  )
                : const SizedBox(),
            widget.fromAllProducts ? BuildCompareButton(screenWidth, screenHeight, context) : const SizedBox(),
          ]),
        ),

        // optimized grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            // crossAxisSpacing: 12,
            // mainAxisSpacing: 12,
            // childAspectRatio: 0.48,
            crossAxisSpacing: screenWidth*.03,//12
            mainAxisSpacing: screenWidth*.03, //12
            childAspectRatio: 0.49, //0.48 handel design shimaa for product card
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductCard(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              icon: 'assets/images/home/main_page/product.jpg',
              fromAllProducts: widget.fromAllProducts,
            );
          },
        ),
      ]),
    );
  }
}
