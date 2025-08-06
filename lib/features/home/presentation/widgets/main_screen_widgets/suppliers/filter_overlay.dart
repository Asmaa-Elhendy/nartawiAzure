import 'package:flutter/material.dart';

import '../../../../../../core/theme/colors.dart';

OverlayEntry buildFilterOverlay({
  required BuildContext context,
  required Offset offset,
  required double width,
  required double height,
  required Set<String> selectedFilters,
  required VoidCallback onClose,
}) {
  return OverlayEntry(
    builder: (context) => Positioned(
      top: offset.dy + height + 5,
      left: offset.dx,
      width: width,
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(12),
        child: StatefulBuilder(
          builder: (context, setStateOverlay) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFilterItem('Search By', selectedFilters, setStateOverlay),
                  Divider(),
                  _buildFilterItem('Price', selectedFilters, setStateOverlay),
                  _buildFilterItem('Popular Products', selectedFilters, setStateOverlay),
                  _buildFilterItem('Purchase Type', selectedFilters, setStateOverlay),
                  _buildFilterItem('Size', selectedFilters, setStateOverlay),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}

Widget _buildFilterItem(
    String title,
    Set<String> selectedFilters,
    void Function(VoidCallback fn) setStateOverlay,
    ) {
  final isSelected = selectedFilters.contains(title);

  return GestureDetector(
    onTap: () {
      if (title != 'Search By') {
        setStateOverlay(() {
          if (isSelected) {
            selectedFilters.remove(title);
          } else {
            selectedFilters.add(title);
          }
        });
      }
    },
    child: Row(mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.BorderAnddividerAndIconColor : AppColors.textLight,
            ),
          ),
        ),
      ],
    ),
  );
}
