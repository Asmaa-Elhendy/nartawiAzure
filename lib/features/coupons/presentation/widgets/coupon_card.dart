import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:newwwwwwww/features/coupons/domain/models/bundle_purchase.dart';
import 'package:newwwwwwww/features/coupons/domain/models/coupons_models.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/prefered_days_grid.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/refill_outline_button.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/snack_bar_warnning.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/view_Consumption_history_alert.dart';
import 'package:newwwwwwww/features/coupons/presentation/widgets/scheduled_order_helper.dart';
import 'package:newwwwwwww/features/coupons/data/models/scheduled_order_model.dart';
import 'package:newwwwwwww/core/constants/time_slots.dart';
import 'package:newwwwwwww/features/coupons/presentation/provider/coupon_controller.dart';
import '../../../../core/theme/colors.dart';
import '../../../cart/presentation/widgets/change_address_alert.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_bloc.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_event.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_state.dart';
import '../../../home/presentation/widgets/main_screen_widgets/suppliers/build_info_button.dart';
import '../../../orders/presentation/widgets/order_image_network_widget.dart';
import '../../../profile/presentation/widgets/quantity_increase_Decrease.dart';
import '../../../../core/components/coupon_status_widget.dart';
import 'calender_dialog.dart';
import 'custom_text.dart';
import 'latest_coupon_tracker.dart';

class CouponeCard extends StatefulWidget {
  final bool disbute;
  final Function onReorder;

  /// ✅ دايمًا list (ممكن فاضية)
  final List<WalletCoupon> currentCoupon;

  final BundlePurchase bundle;
  final CouponsController? couponsController;

  const CouponeCard({
    Key? key,
    required this.currentCoupon,
    required this.bundle,
    this.disbute = false,
    required this.onReorder,
    this.couponsController,
  }) : super(key: key);

  @override
  State<CouponeCard> createState() => _CouponeCardState();
}

class _CouponeCardState extends State<CouponeCard> {
  String imageUrl = '';
  bool _isSwitched = false;

  late final ProductQuantityBloc _quantityBloc;
  late final ProductQuantityBloc _quantityTwoBloc;
  late final TextEditingController _quantityController;
  late final TextEditingController _quantityTwoController;

  final Set<int> _selectedPreferredDays = {};
  int _selectedTimeSlotId = 2;
  ScheduledOrderModel? _existingSchedule;
  CouponsController? _couponsController;

  @override
  void initState() {
    _quantityBloc = ProductQuantityBloc(
      calculateProductPrice: CalculateProductPrice(),
      basePrice: 100.0,
    );
    _quantityTwoBloc = ProductQuantityBloc(
      calculateProductPrice: CalculateProductPrice(),
      basePrice: 100.0,
    );
    _quantityController = TextEditingController(text: '1');
    _quantityTwoController = TextEditingController(text: '1');
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadScheduleData();
    });
  }

  void _loadScheduleData() {
    _couponsController = widget.couponsController;

    if (_couponsController != null && widget.bundle.productVsid != null) {
      final schedule = _couponsController!.getScheduleForProduct(widget.bundle.productVsid!);
      
      if (schedule != null && mounted) {
        setState(() {
          _existingSchedule = schedule;
          _quantityController.text = schedule.weeklyFrequency.toString();
          _quantityTwoController.text = schedule.bottlesPerDelivery.toString();
          _isSwitched = schedule.autoRenewEnabled;
          
          _selectedPreferredDays.clear();
          for (var entry in schedule.schedule) {
            _selectedPreferredDays.add(entry.dayOfWeek);
            _selectedTimeSlotId = entry.timeSlotId;
          }
        });
        
        _quantityBloc.add(QuantityChanged(schedule.weeklyFrequency.toString()));
        _quantityTwoBloc.add(QuantityChanged(schedule.bottlesPerDelivery.toString()));
      }
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _quantityBloc.close();
    _quantityTwoBloc.close();
    _quantityTwoController.dispose();
    super.dispose();
  }

  String formatIssuedDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '';
    final dateTime = DateTime.parse(isoDate).toLocal();
    return DateFormat('MMMM d, yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // ✅ safe access
    final bool hasCoupons = widget.currentCoupon.isNotEmpty;
    final WalletCoupon? firstCoupon = hasCoupons ? widget.currentCoupon.first : null;

    final String locationText =
        firstCoupon?.proofOfDelivery?.location ?? '';

    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * .01),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * .02,
        horizontal: screenWidth * .03,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            offset: const Offset(0, 2),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customCouponPrimaryTitle(
                '${widget.bundle.couponsPerBundle} Coupon Bundle',
                screenWidth,
                screenHeight,
              ),
              CouponStatus(
                screenHeight,
                screenWidth,
                widget.bundle.status,
                fromCoupon: true,
              ),
            ],
          ),

          Row(
            children: [
              SvgPicture.asset(
                "assets/images/orders/calendar.svg",
                width: screenWidth * .042,
                color: AppColors.textLight,
              ),
              SizedBox(width: screenWidth * .02),
              Text(
                'Purchased On ${formatIssuedDate(widget.bundle.purchasedAt?.toIso8601String())}',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: screenWidth * .036,
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * .01),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildNetworkOrderImage(
                  screenWidth,
                  screenHeight,
                  imageUrl,
                  'assets/images/home/main_page/company.png',
                ),
                SizedBox(width: screenWidth * .03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.bundle.vendorName}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * .037,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: screenHeight * .01),
                      child: Text(
                        'Total Order Value',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: screenWidth * .032,
                          color: AppColors.greyDarktextIntExtFieldAndIconsHome,
                        ),
                      ),
                    ),
                    Text(
                      'QAR ${widget.bundle.totalPrice}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * .037,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          latestCouponTracker(screenWidth, screenHeight, widget.onReorder, widget.bundle),

          Padding(
            padding: EdgeInsets.only(top: screenHeight * .01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customCouponPrimaryTitle('Auto-Renewal', screenWidth, screenHeight),
                Transform.scale(
                  scale: .65,
                  child: CupertinoSwitch(
                    activeColor: AppColors.primary,
                    value: _isSwitched,
                    onChanged: (value) => setState(() => _isSwitched = value),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * .02),
            child: Text(
              'Automatically Purchase New Coupons When This Bundle Runs Out',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: screenWidth * .036,
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Address',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * .036,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => ChangeAddressAlert(fromCouponCard: true),
                  );
                },
                child: ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(bounds),
                  child: Text(
                    'Change Address',
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * .034,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: screenHeight * .01),

          Text(
            locationText.isEmpty ? 'No delivery_man address yet' : locationText,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: screenWidth * .032,
              color: AppColors.BorderAnddividerAndIconColor,
            ),
          ),

          SizedBox(height: screenHeight * .03),

          customCouponPrimaryTitle('Weekly Deliver frequency', screenWidth, screenHeight),

          BlocProvider.value(
            value: _quantityBloc,
            child: BlocBuilder<ProductQuantityBloc, ProductQuantityState>(
              builder: (context, state) {
                if (_quantityController.text != state.quantity) {
                  _quantityController.text = state.quantity;
                }
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
                  child: Row(
                    children: [
                      Expanded(
                        child: IncreaseDecreaseQuantity(
                          context: context,
                          width: screenWidth,
                          height: screenHeight,
                          isPlus: true,
                          price: 0,
                          onIncrease: () => context.read<ProductQuantityBloc>().add(IncreaseQuantity()),
                          onDecrease: () => context.read<ProductQuantityBloc>().add(DecreaseQuantity()),
                          quantityCntroller: _quantityController,
                          onTextfieldChanged: (value) =>
                              context.read<ProductQuantityBloc>().add(QuantityChanged(value)),
                          onDone: () => context.read<ProductQuantityBloc>().add(QuantityEditingComplete()),
                          fromDetailedScreen: true,
                          title: 'Days',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          customCouponPrimaryTitle('Bottles Per Delivery', screenWidth, screenHeight),

          BlocProvider.value(
            value: _quantityTwoBloc,
            child: BlocBuilder<ProductQuantityBloc, ProductQuantityState>(
              builder: (context, state) {
                if (_quantityTwoController.text != state.quantity) {
                  _quantityTwoController.text = state.quantity;
                }
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
                  child: Row(
                    children: [
                      Expanded(
                        child: IncreaseDecreaseQuantity(
                          context: context,
                          width: screenWidth,
                          height: screenHeight,
                          isPlus: true,
                          price: 0,
                          onIncrease: () => context.read<ProductQuantityBloc>().add(IncreaseQuantity()),
                          onDecrease: () => context.read<ProductQuantityBloc>().add(DecreaseQuantity()),
                          quantityCntroller: _quantityTwoController,
                          onTextfieldChanged: (value) =>
                              context.read<ProductQuantityBloc>().add(QuantityChanged(value)),
                          onDone: () => context.read<ProductQuantityBloc>().add(QuantityEditingComplete()),
                          fromDetailedScreen: true,
                          title: 'Bottles',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          customCouponPrimaryTitle('Preferred Refill Times /Week', screenWidth, screenHeight),
          Text(
            'Used As A Guide, Not Mandatory',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: screenWidth * .032,
              color: AppColors.BorderAnddividerAndIconColor,
            ),
          ),

          SizedBox(height: screenHeight * .03),

          BlocProvider.value(
            value: _quantityBloc,
            child: BlocBuilder<ProductQuantityBloc, ProductQuantityState>(
              builder: (context, state) {
                final int maxPreferredDays = int.tryParse(state.quantity) ?? 0;

                return DaySelectionGrid(
                  selectedDays: _selectedPreferredDays,
                  onDayTapped: (int dayIndex) {
                    setState(() {
                      if (_selectedPreferredDays.contains(dayIndex)) {
                        _selectedPreferredDays.remove(dayIndex);
                      } else {
                        if (maxPreferredDays > 0 &&
                            _selectedPreferredDays.length >= maxPreferredDays) {
                          showSnackBarWarning(
                            context,
                            screenWidth,
                            screenHeight,
                            'You can select up to $maxPreferredDays preferred days only.',
                          );
                        } else {
                          _selectedPreferredDays.add(dayIndex);
                        }
                      }
                    });
                  },
                );
              },
            ),
          ),

          BuildInfoAndAddToCartButton(
            screenWidth,
            screenHeight,
            'View Last Consumption',
            false,
                () {
              showDialog(
                context: context,
                builder: (ctx) {

                  return ViewConsumptionHistoryAlert(
                    disbute: widget.disbute,
                    currentCoupon: widget.currentCoupon,
                  );
                },
              );
            },
            fromCouponsScreen: true,
          ),

          NextRefillButton(
            selectedDays: _selectedPreferredDays.toList(),
          ),

          SizedBox(height: screenHeight * .02),

          customCouponPrimaryTitle('Preferred Time Slot', screenWidth, screenHeight),
          SizedBox(height: screenHeight * .01),
          
          DropdownButtonFormField<int>(
            value: _selectedTimeSlotId,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: screenWidth * .04,
                vertical: screenHeight * .015,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.BorderAnddividerAndIconColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.BorderAnddividerAndIconColor),
              ),
            ),
            items: TimeSlots.all.map((slot) {
              return DropdownMenuItem(
                value: slot.id,
                child: Text(
                  slot.displayTime,
                  style: TextStyle(fontSize: screenWidth * .036),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedTimeSlotId = value);
              }
            },
          ),

          SizedBox(height: screenHeight * .02),

          if (_existingSchedule != null) ..[
            Container(
              padding: EdgeInsets.all(screenWidth * .03),
              decoration: BoxDecoration(
                color: ScheduledOrderHelper.getApprovalStatusColor(_existingSchedule!.approvalStatus).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ScheduledOrderHelper.getApprovalStatusColor(_existingSchedule!.approvalStatus),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: ScheduledOrderHelper.getApprovalStatusColor(_existingSchedule!.approvalStatus),
                    size: screenWidth * .05,
                  ),
                  SizedBox(width: screenWidth * .02),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Schedule Status: ${ScheduledOrderHelper.getApprovalStatusDisplay(_existingSchedule!.approvalStatus)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * .036,
                          ),
                        ),
                        if (_existingSchedule!.rejectionReason != null)
                          Text(
                            _existingSchedule!.rejectionReason!,
                            style: TextStyle(
                              fontSize: screenWidth * .032,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.visibility, size: screenWidth * .05),
                    onPressed: () => ScheduledOrderHelper.showScheduleStatus(
                      context,
                      schedule: _existingSchedule!,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * .02),
          ],

          ElevatedButton(
            onPressed: _couponsController != null ? _saveSchedule : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: Size(double.infinity, screenHeight * .06),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              _existingSchedule != null ? 'Update Schedule' : 'Save Schedule',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * .04,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          if (_existingSchedule != null) ..[
            SizedBox(height: screenHeight * .01),
            OutlinedButton(
              onPressed: _couponsController != null ? _deleteSchedule : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                minimumSize: Size(double.infinity, screenHeight * .06),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Cancel Schedule',
                style: TextStyle(
                  fontSize: screenWidth * .04,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _saveSchedule() async {
    if (_couponsController == null) return;

    final weeklyFreq = int.tryParse(_quantityController.text) ?? 0;
    final bottlesPerDelivery = int.tryParse(_quantityTwoController.text) ?? 0;

    await ScheduledOrderHelper.saveSchedule(
      context: context,
      controller: _couponsController!,
      bundle: widget.bundle,
      weeklyFrequency: weeklyFreq,
      bottlesPerDelivery: bottlesPerDelivery,
      selectedDays: _selectedPreferredDays,
      timeSlotId: _selectedTimeSlotId,
      autoRenewEnabled: _isSwitched,
      lowBalanceThreshold: 5,
      existingSchedule: _existingSchedule,
    );

    _loadScheduleData();
  }

  Future<void> _deleteSchedule() async {
    if (_couponsController == null || _existingSchedule == null) return;

    await ScheduledOrderHelper.deleteSchedule(
      context: context,
      controller: _couponsController!,
      schedule: _existingSchedule!,
    );

    setState(() {
      _existingSchedule = null;
    });
  }
}
