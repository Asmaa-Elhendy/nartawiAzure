// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/custom_search_bar.dart';
// import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/build_filter_button.dart';
//
// import '../product_card.dart';
//
// class TabBarFirstPage extends StatefulWidget {
//   const TabBarFirstPage({super.key});
//
//   @override
//   State<TabBarFirstPage> createState() => _TabBarFirstPageState();
// }
//
// class _TabBarFirstPageState extends State<TabBarFirstPage> {
//   Set<String> selectedFilters = {};
//
//   OverlayEntry? _overlayEntry;
//   final GlobalKey _searchBarKey = GlobalKey();
//
//
//   void _showFilterMenu() {
//     final renderBox = _searchBarKey.currentContext!.findRenderObject() as RenderBox;
//     final offset = renderBox.localToGlobal(Offset.zero);
//     final size = renderBox.size;
//
//     _overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         top: offset.dy + size.height + 5,
//         left: offset.dx,
//         width: size.width,
//         child: Material(
//           elevation: 5,
//           borderRadius: BorderRadius.circular(12),
//           child: StatefulBuilder(
//             builder: (context, setStateOverlay) {
//               return Container(
//                 padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildFilterItem('Search By', setStateOverlay),
//                     Divider(),
//                     _buildFilterItem('Price', setStateOverlay),
//                     _buildFilterItem('Popular Products', setStateOverlay),
//                     _buildFilterItem('Purchase Type', setStateOverlay),
//                     _buildFilterItem('Size', setStateOverlay),
//                   ],
//                 ),
//               );//
//             },
//           ),
//         ),
//       ),
//     );
//
//     Overlay.of(context).insert(_overlayEntry!);
//   }
//
//
//   bool selected=false;
//   Widget _buildFilterItem(String title, void Function(VoidCallback fn) setStateOverlay) {
//     final isSelected = selectedFilters.contains(title);
//
//     return GestureDetector(
//       onTap: (){
//        if(title=='Search By'){}else{
//          if (isSelected) {
//            selectedFilters.remove(title);
//          } else {
//            selectedFilters.add(title);
//          }
//          setStateOverlay(() {
//
//          });
//        }},
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 6),
//         child: Text(
//           title,
//           style: TextStyle(//
//             fontWeight: FontWeight.w600 ,
//             color: isSelected ==false ? Colors.black : Colors.grey.shade400,
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _hideFilterMenu() {
//     _overlayEntry?.remove();
//     _overlayEntry = null;
//   }
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.only(
//               left: screenWidth * .04,
//               right: screenWidth * .04,
//               top: screenHeight * .02,
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 CustomSearchBar(
//                   controller: TextEditingController(),
//                   height: screenHeight,
//                   width: screenWidth,
//                   fromSupplierDetail: true,
//                   key: _searchBarKey,
//                 ),
//
//                 Center(
//                     child: BuildFilterButton(
//                       screenWidth,
//                       screenHeight,
//
//                           () {
//                         if (_overlayEntry == null) {
//                           _showFilterMenu();
//                         } else {
//                           _hideFilterMenu();
//                         }
//                       }
//                     ),
//                   ),
//
//               ],
//             ),
//           ),
//           GridView.count(
//             crossAxisCount: 2,
//             // عدد الأعمدة
//             shrinkWrap: true,
//             // مهم جدًا لو بتحطه جوه ScrollView
//             physics: NeverScrollableScrollPhysics(),
//             // يمنع الـ Grid من الاسكرول لو فيه ScrollView أكبر
//             padding: const EdgeInsets.all(16),
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 12,
//             childAspectRatio: 0.48,
//             children: [
//               ProductCard(
//                 screenWidth: screenWidth,
//                 screenHeight: screenHeight,
//                 icon: 'assets/images/home/main_page/product.jpg',
//                 title: 'Bottle',
//               ),
//               ProductCard(
//                 screenWidth: screenWidth,
//                 screenHeight: screenHeight,
//                 icon: 'assets/images/home/main_page/product.jpg',
//                 title: 'Gallon',
//               ),
//               ProductCard(
//                 screenWidth: screenWidth,
//                 screenHeight: screenHeight,
//                 icon: 'assets/images/home/main_page/product.jpg',
//                 title: 'Alkaline',
//               ),
//               ProductCard(
//                 screenWidth: screenWidth,
//                 screenHeight: screenHeight,
//                 icon: 'assets/images/home/main_page/product.jpg',
//                 title: 'Coupon',
//               ),
//               // أضف المزيد من العناصر حسب الحاجة
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../custom_search_bar.dart';
import '../product_card.dart';
import 'build_filter_button.dart';
import 'filter_overlay.dart';


class TabBarFirstPage extends StatefulWidget {
  const TabBarFirstPage({super.key});

  @override
  State<TabBarFirstPage> createState() => _TabBarFirstPageState();
}

class _TabBarFirstPageState extends State<TabBarFirstPage> {
  final Set<String> selectedFilters = {};
  OverlayEntry? _overlayEntry;
  final GlobalKey _searchBarKey = GlobalKey();

  void _toggleFilterMenu() {//k
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

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.02,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomSearchBar(
                  key: _searchBarKey,
                  controller: TextEditingController(),
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
          ),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.48,
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
              // أضف المزيد من العناصر حسب الحاج
            ],
          ),
        ],
      ),
    );
  }
}
