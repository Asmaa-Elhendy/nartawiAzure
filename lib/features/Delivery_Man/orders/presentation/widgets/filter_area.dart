// filter_by_row_typeahead.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../../../../core/theme/colors.dart';

class FilterByRowTypeAhead extends StatelessWidget {
  final double width;
  final double height;

  final List<String> zones;
  final List<String> streets;
  final List<String> buildings;

  final TextEditingController zoneController;
  final TextEditingController streetController;
  final TextEditingController buildingController;

  final VoidCallback onClearZone;
  final VoidCallback onClearStreet;
  final VoidCallback onClearBuilding;

  final ValueChanged<String> onZoneSelected;
  final ValueChanged<String> onStreetSelected;
  final ValueChanged<String> onBuildingSelected;

  const FilterByRowTypeAhead({
    super.key,
    required this.width,
    required this.height,
    required this.zones,
    required this.streets,
    required this.buildings,
    required this.zoneController,
    required this.streetController,
    required this.buildingController,
    required this.onClearZone,
    required this.onClearStreet,
    required this.onClearBuilding,
    required this.onZoneSelected,
    required this.onStreetSelected,
    required this.onBuildingSelected,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final itemWidth = (w - (w * .12) - 20) / 3;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * .01),
      child: Row(
        children: [
          SizedBox(
            width: itemWidth,
            child: _SearchablePillTypeAhead(
              width: width,
              height: height,
              hint: 'Zone',
              controller: zoneController,
              items: zones,
              onSelected: onZoneSelected,
              onClear: onClearZone,
            ),
          ),
          SizedBox(width: width * .01),
          SizedBox(
            width: itemWidth,
            child: _SearchablePillTypeAhead(
              width: width,
              height: height,
              hint: 'Street',
              controller: streetController,
              items: streets,
              onSelected: onStreetSelected,
              onClear: onClearStreet,
            ),
          ),
          SizedBox(width: width * .01),
          SizedBox(
            width: itemWidth,
            child: _SearchablePillTypeAhead(
              width: width,
              height: height,
              hint: 'Building',
              controller: buildingController,
              items: buildings,
              onSelected: onBuildingSelected,
              onClear: onClearBuilding,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchablePillTypeAhead extends StatelessWidget {
  final double width;
  final double height;
  final String hint;
  final TextEditingController controller;
  final List<String> items;
  final ValueChanged<String> onSelected;
  final VoidCallback onClear;

  const _SearchablePillTypeAhead({
    required this.width,
    required this.height,
    required this.hint,
    required this.controller,
    required this.items,
    required this.onSelected,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final pillH = height * .042;
    final screenW = MediaQuery.of(context).size.width;

    return Container(
      height: pillH,
      padding: EdgeInsets.symmetric(horizontal: width * .03),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.BorderAnddividerAndIconColor,
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, pillConstraints) {
                final pillWidth = pillConstraints.maxWidth;

                // ✅ عرض الـ suggestions: أكبر من الـ pill + لكن مايزيدش عن 92% من الشاشة
                double suggestionsWidth = math.min(
                  screenW * .98,                // ✅ تقريبًا عرض الشاشة
                  pillWidth + (screenW * .55),  // ✅ أكبر بوضوح من قبل
                );


                return TypeAheadField<String>(
                  controller: controller,
                  suggestionsCallback: (pattern) {
                    final q = pattern.trim().toLowerCase();
                    if (q.isEmpty) return items;
                    return items.where((e) => e.toLowerCase().contains(q)).toList();
                  },

                  itemBuilder: (context, suggestion) {
                    return Container(
                      width: double.infinity, // ✅ مهم جدًا
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: width * .01,
                        vertical: height * .01,
                      ),
                      child: Text(
                        suggestion,
                        maxLines: 2, // ✅ يسمح بسطرين فقط عند الحاجة
                        overflow: TextOverflow.ellipsis, // ✅ لو أطول
                        softWrap: true, // ✅ كسر ذكي على مستوى الكلمة
                        style: TextStyle(
                          fontSize: width * .03,
                          color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                          fontWeight: FontWeight.w500,
                          height: 1.3, // مسافة مريحة
                        ),
                      ),
                    );
                  },


                  emptyBuilder: (context) {
                    return Material(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: height * .012,
                          horizontal: width * .03,
                        ),
                        child: Text(
                          'No items found',
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: width * .028,
                            color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },

                  onSelected: (suggestion) {
                    controller.text = suggestion;
                    onSelected(suggestion);
                    FocusScope.of(context).unfocus();
                  },

                  builder: (context, textController, focusNode) {
                    return TextField(
                      controller: textController,
                      focusNode: focusNode,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: width * .03,
                        color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: hint,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: width * .03,
                          color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                        ),
                        contentPadding: EdgeInsets.only(
                          left: width * .004,
                          right: width * .004,
                          top: height * .008,
                          bottom: height * .008,
                        ),
                      ),
                    );
                  },

                  decorationBuilder: (context, child) {
                    return Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: suggestionsWidth,
                          maxWidth: suggestionsWidth,
                        ),
                        child: child,
                      ),
                    );
                  },

                  constraints: BoxConstraints(
                    maxHeight: height * .35,
                  ),
                  hideOnEmpty: false,
                  hideOnLoading: true,
                  hideWithKeyboard: false,
                );
              },
            ),
          ),

          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                controller.clear();
                onClear();
                FocusScope.of(context).unfocus();
              },
              child: Icon(
                Icons.cancel,
                size: width * .045,
                color: AppColors.greyDarktextIntExtFieldAndIconsHome,
              ),
            )
          else
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: width * .055,
              color: AppColors.greyDarktextIntExtFieldAndIconsHome,
            ),
        ],
      ),
    );
  }
}
