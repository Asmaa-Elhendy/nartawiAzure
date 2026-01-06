// filter_by_row_typeahead.dart
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
    // نفس فكرة توزيع المساحة بتاعتك
    final w = MediaQuery.of(context).size.width;
    final itemWidth = (w - (w * .12) - 20) / 3;

    return Padding(
      padding:  EdgeInsets.symmetric(vertical: height*.01),
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

    return Container(
      height: pillH,

      padding: EdgeInsets.symmetric(horizontal: width * .03), // ✅ padding ثابت زي ما تحبي
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
          // ✅ Expanded عشان النص ياخد مساحته ويظهر كامل
          Expanded(
            child: TypeAheadField<String>(
              controller: controller,
              // عشان يشتغل كويس على اللمس
              suggestionsCallback: (pattern) {
                final q = pattern.trim().toLowerCase();
                if (q.isEmpty) return items;
                return items.where((e) => e.toLowerCase().contains(q)).toList();
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  dense: true,
                  tileColor: Colors.white, // ✅ الخلفية بيضا
                  title: Text(
                    suggestion,
                    // maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                  //  softWrap: false,
                    style: TextStyle(
                      fontSize: width * .03,
                      color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
              emptyBuilder: (context) {
                return Material(
                  color: Colors.white, // ✅ خلفية بيضا
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: height * .012,
                      horizontal: width * .02,
                    ),
                    child: Text(
                      'No items found',
                      // maxLines: 1,
                      // overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: width * .028, // أصغر شوية
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

              // ✅ شكل الـ TextField جوه الـ pill
              builder: (context, textController, focusNode) {
                return TextField(
                  controller: textController,
                  focusNode: focusNode,
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

              // ✅ شكل الـ dropdown suggestions
              decorationBuilder: (context, child) {
                return Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.antiAlias,
                  child: child,
                );
              },

              // ✅ خلي الـ suggestions width نفس الـ pill
              constraints: BoxConstraints(
                maxHeight: height * .35,
              ),
              hideOnEmpty: false,
              hideOnLoading: true,
              hideWithKeyboard: false,
            ),
          ),

          // ✅ Icon: لو فيه text -> clear ، لو فاضي -> arrow
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
