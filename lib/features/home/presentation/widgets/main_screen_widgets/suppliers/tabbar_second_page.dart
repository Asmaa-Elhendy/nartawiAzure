import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/build_row_of_stars_ratings.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/suppliers/supplier_reaings_card.dart';

import '../../../../../../core/theme/colors.dart';
import '../../../../../../core/theme/text_styles.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../provider/supplier_reviews_controller.dart';
import 'build_info_button.dart';
import 'build_row_raing.dart';
import 'build_verified_widget.dart';

class TabBarSecondPage extends StatefulWidget {
  final int supplierId;
  const TabBarSecondPage({super.key, required this.supplierId});
  @override
  State<TabBarSecondPage> createState() => _TabBarSecondPageState();
}

class _TabBarSecondPageState extends State<TabBarSecondPage> {
  List<int> items = [1, 2, 3, 4, 5];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SupplierReviewsController>().fetchSupplierReviews(widget.supplierId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final ctrl = context.watch<SupplierReviewsController>();
    final res = ctrl.data;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (ctrl.isLoading)
            Center(child: CircularProgressIndicator(color: AppColors.primary))
          else if (ctrl.error != null)
            Text(ctrl.error!, style: const TextStyle(color: Colors.red))
          else
            BuildSupplierRatingCard(context,
              screenWidth,
              screenHeight,

              // ⭐ هنا بقى بنبعت القيم الحقيقة
              mainTitle: AppLocalizations.of(context)!.ratingSummary,
              overallRating: res?.overallRating ?? 0,
              totalReviews: res?.totalReviews ?? 0,
              orderAvg: res?.orderExperienceAvg ?? 0,
              sellerAvg: res?.sellerExperienceAvg ?? 0,
              deliveryAvg: res?.deliveryExperienceAvg ?? 0,
            ),

          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.02),
            child: Text(
    AppLocalizations.of(context)!.customerReviews,
              style: TextStyle(
                color: AppColors.textLight,
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * .04,
              ),
            ),
          ),

          if ((res?.reviews ?? []).isEmpty)
            Center(
              child: SvgPicture.asset(
                'assets/images/home/main_page/supplier_detail/empty-state.svg',
              ),
            )
          else
          // هنا بعدين نعرض list reviews
            const SizedBox(),
        ],
      ),
    );

  }
}
