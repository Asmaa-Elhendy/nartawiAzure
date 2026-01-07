import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:newwwwwwww/features/profile/domain/models/client_address.dart';
import '../../../../../../core/theme/colors.dart';
import '../provider/address_controller.dart';

// Helper function to remove duplicate address parts
String _removeDuplicateAddress(String address) {
  final parts = address.split(',').map((part) => part.trim()).toList();

  final uniqueParts = <String>[];
  for (int i = 0; i < parts.length; i++) {
    if (i == 0 || parts[i] != parts[i - 1]) {
      uniqueParts.add(parts[i]);
    }
  }

  return uniqueParts.join(', ');
}

Widget BuildCardAddress(
    BuildContext context,
    double screenHeight,
    double screenWidth, {
      bool selected = false,
      bool fromCart = false,
      bool fromCouponCard = false,
      ClientAddress? address = null,
      required AddressController controller,

      // ✅ NEW (اختياري - مش هيأثر على الاستخدامات التانية)
      bool selectable = false,
      VoidCallback? onSelect,
    }) {
  return GestureDetector(
    // ✅ بدل onTap الفاضي
    onTap: selectable ? onSelect : null,
    child: Padding(
      padding: EdgeInsets.symmetric(
        vertical: fromCart ? screenHeight * .01 : screenHeight * .02,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * .03,
          horizontal: screenWidth * .04,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: selected
              ? Border.all(
            color: AppColors.BorderAnddividerAndIconColor,
            width: 0.5,
          )
              : Border.all(color: Colors.transparent, width: 0),
          color: selected
              ? AppColors.primary
              : fromCart
              ? AppColors.backgrounHome
              : AppColors.whiteColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                fromCouponCard
                    ? SizedBox()
                    : Text(
                  address != null ? address.title! : 'Home',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: screenWidth * .04,
                    color: selected ? AppColors.whiteColor : AppColors.primary,
                  ),
                ),
                GestureDetector(
                  onTap: address == null
                      ? null
                      : () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (contextt) => AlertDialog(
                        title: Text(
                          'Delete address',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * .034,
                          ),
                        ),
                        content: const Text(
                          'Are you sure you want to delete this address?\nThis action cannot be undone.',
                          style: TextStyle(
                            color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(contextt, false),
                            child: Text('Cancel', style: TextStyle(color: AppColors.primary)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(contextt, true),
                            child: Text('Delete', style: TextStyle(color: AppColors.redColor)),
                          ),
                        ],
                      ),
                    );

                    if (confirmed != true) return;
                    await controller.deleteAddress(address.id!);
                  },
                  child: Iconify(
                    MaterialSymbols.delete_outline_rounded,
                    size: screenHeight * .025,
                    color: selected?AppColors.whiteColor:AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: fromCouponCard ? 0 : screenHeight * .02),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/images/profile/delivery_man/home.svg',
                  height: screenHeight * .03,
                 color:    selected?AppColors.whiteColor:AppColors.textLight
                ),
                SizedBox(width: screenWidth * .04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        address != null ? 'Delivering to ${address.title!}' : 'Delivering to Work',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth * .032,
                          color: selected?AppColors.whiteColor:AppColors.textLight
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        address != null ? _removeDuplicateAddress(address.address!) : '',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: screenWidth * .032,
                          color:selected?AppColors.whiteColor: AppColors.greyDarktextIntExtFieldAndIconsHome,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * .02),
                address != null && address.isDefault!
                    ? Iconify(
                  MaterialSymbols.star,
                  size: screenHeight * .03,
                  color: AppColors.primary,
                )
                    : SizedBox(),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
