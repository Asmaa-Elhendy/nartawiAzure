import 'package:flutter/material.dart';

import '../../../../../../core/theme/colors.dart';

class FilterExample extends StatefulWidget {
  @override
  _FilterExampleState createState() => _FilterExampleState();
}

class _FilterExampleState extends State<FilterExample> {
  final GlobalKey _filterButtonKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _showFilterMenu() {
    final renderBox = _filterButtonKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + size.height + 5,
        left: offset.dx,
        width: 220,
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFilterItem('Search By', bold: true),
                Divider(),
                _buildFilterItem('Price', enabled: false),
                _buildFilterItem('Popular Products'),
                _buildFilterItem('Purchase Type', enabled: false),
                _buildFilterItem('Size'),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildFilterItem(String title, {bool bold = false, bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: enabled ? Colors.black : AppColors.BorderAnddividerAndIconColor,
        ),
      ),
    );
  }

  void _hideFilterMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [

                  GestureDetector(
                    key: _filterButtonKey,
                    onTap: () {
                      if (_overlayEntry == null) {
                        _showFilterMenu();
                      } else {
                        _hideFilterMenu();
                      }
                    },
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.filter_list, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
