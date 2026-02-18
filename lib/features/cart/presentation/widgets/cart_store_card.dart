import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newwwwwwww/features/cart/presentation/widgets/widget_view_detail_store.dart';
import 'package:newwwwwwww/features/home/domain/models/supplier_model.dart';
import 'package:newwwwwwww/features/home/presentation/bloc/suppliers_bloc/suppliers_bloc.dart';
import 'package:newwwwwwww/features/home/presentation/bloc/suppliers_bloc/suppliers_event.dart';
import 'package:newwwwwwww/features/home/presentation/bloc/suppliers_bloc/suppliers_state.dart';
import '../../../../../../core/theme/colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../home/presentation/pages/suppliers/supplier_detail.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/build_row_raing.dart';
import 'outline_buttons.dart';
//get suupier with id
//navigate to detail with this supplier 

Widget CartStoreCard(
  BuildContext context,
  double screenWidth,
  double screenHeight, {
  String? supplierId,
  String? supplierName,
  double? supplierRating,
  String? supplierLogo,
}) {
  // Fetch supplier details if supplierId is available
  if (supplierId != null) {
    final supplierIdInt = int.tryParse(supplierId);
    if (supplierIdInt != null) {
      context.read<SuppliersBloc>().add(FetchSupplierById(supplierIdInt));
    }
  }

  return BlocBuilder<SuppliersBloc, SuppliersState>(
    builder: (context, state) {
      Supplier? detailedSupplier;
      
      if (state is SupplierDetailLoaded) {
        detailedSupplier = state.supplier;
      } else if (supplierId != null && supplierName != null) {
        // Use original supplier data as fallback
        detailedSupplier = Supplier(
          id: int.tryParse(supplierId) ?? 0,
          arName: supplierName,
          enName: supplierName,
          isActive: true,
          isVerified: false,
          rating: supplierRating?.toInt(),
          logoUrl: supplierLogo,
        );
      }

      return Container(
    // height: screenHeight*.3,
    padding:  EdgeInsets.symmetric(vertical: screenHeight*.01,horizontal: screenWidth*.01),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: AppColors.whiteColor,


    ),
    child: Column(
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              //   width: widget.screenWidth * .04,
              // الحجم العرض
              height: screenHeight * .08,//0.09
              // الحجم الارتفاع
              decoration: BoxDecoration(
                color: AppColors.backgrounHome, // لون الخلفية
                shape: BoxShape.circle, // يجعله دائري
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: supplierLogo != null && supplierLogo.isNotEmpty
                  ? Image.network(
                      supplierLogo,
                      height: screenHeight * .03,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/home/main_page/company.png",
                          height: screenHeight * .03,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      "assets/images/home/main_page/company.png",
                      height: screenHeight * .03,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(width: screenWidth*.01,),
            Expanded(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: screenWidth*.01),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(supplierName ?? 'Company 1', style: TextStyle(fontWeight: FontWeight.w600, fontSize: screenWidth*.036),),
                      Padding(
                        padding:  EdgeInsets.only(right: screenWidth*.02),
                        child: BuildRowRating(screenWidth, screenHeight, title: supplierRating?.toString() ?? '0'),
                      ),
                    ],
                  ),
                    SizedBox(height: screenHeight*.01,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        viewStoreWithoutFlexible((){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>SupplierDetails(supplier: detailedSupplier ?? Supplier(id: int.tryParse(supplierId ?? '0') ?? 0, arName: supplierName ?? 'Unknown', enName: supplierName ?? 'Unknown', isActive: true, isVerified: false))));

                        }, 'View Store', screenWidth, screenHeight),

                        OutlineButtonWithoutFlexible((){
                          showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: '',
                              barrierColor: Colors.black54, // خلفية شفافة
                              pageBuilder: (ctx, anim1, anim2) {
                              return
                                ViewDetailSupplierAlert(ctx,screenWidth,screenHeight, supplier: detailedSupplier);
                              },
                          );
                              }

                        , AppLocalizations.of(context)!.viewDetails, screenWidth, screenHeight,context)

                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),

      ],
    ));
        },
      );
}

