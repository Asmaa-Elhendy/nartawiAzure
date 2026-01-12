import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newwwwwwww/features/profile/presentation/widgets/quantity_increase_Decrease.dart';
import '../../../../core/theme/colors.dart';
import '../../../coupons/presentation/widgets/custom_text.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_bloc.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_event.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_state.dart';


class SettingCard extends StatefulWidget {
  final String title;
  final String description;
  final String quantityLabel;
  final bool isIncrease;
  
  // NEW: External state management callbacks
  final bool? initialSwitchValue;
  final int? initialThresholdValue;
  final Function(bool)? onSwitchChanged;
  final Function(int)? onThresholdChanged;
  
  SettingCard({
    required this.title,
    required this.description,
    required this.quantityLabel,
    this.isIncrease = true,
    this.initialSwitchValue,
    this.initialThresholdValue,
    this.onSwitchChanged,
    this.onThresholdChanged,
  });

  @override
  State<SettingCard> createState() => _SettingCardState();
}

class _SettingCardState extends State<SettingCard> {
  String imageUrl = '';
  late bool _isSwitched; // Will be initialized in initState from external value
  late final ProductQuantityBloc _quantityBloc;
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    
    // Initialize switch from external value or default to false
    _isSwitched = widget.initialSwitchValue ?? false;
    
    _quantityBloc = ProductQuantityBloc(
      calculateProductPrice: CalculateProductPrice(),
      basePrice: 100.0,
    );

    // Initialize threshold from external value or default to '1'
    final initialValue = widget.initialThresholdValue?.toString() ?? '1';
    _quantityController = TextEditingController(text: initialValue);
  }

  void dispose() {
    _quantityController.dispose();
    _quantityBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * .01),
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * .01,
        horizontal: screenWidth * .03,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.whiteColor,
        // boxShadow: [
        //   BoxShadow(
        //     color: AppColors.shadowColor,
        //     offset: Offset(0, 2),
        //     blurRadius: 20,
        //     spreadRadius: 0,
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          Padding(
            padding: EdgeInsets.only(top: screenHeight * .01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customCouponPrimaryTitle(
                  widget.title,
                  screenWidth,
                  screenHeight,
                ),
                Transform.scale(
                  scale: .65, // Bigger (1.0 = default)
                  child: CupertinoSwitch(
                    activeColor: AppColors.primary,
                    value: _isSwitched,
                    onChanged: (value) {
                      setState(() {
                        _isSwitched = value;
                      });
                      // Notify parent of switch change
                      if (widget.onSwitchChanged != null) {
                        widget.onSwitchChanged!(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          customCouponAlertSubTitle(widget.description, screenWidth, screenHeight),


          BlocProvider.value(
            value: _quantityBloc,
            child: BlocBuilder<ProductQuantityBloc, ProductQuantityState>(
              builder: (context, state) {
                // Update controller when state changes
                if (_quantityController.text != state.quantity) {
                  _quantityController.text = state.quantity;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * .02,
                      ),
                      child:
                      widget.isIncrease?
                      Row(
                        children: [
                          Expanded(
                            child: IncreaseDecreaseQuantity(
                              context: context,
                              width: screenWidth,
                              height: screenHeight,
                              isPlus: true,
                              price: 0,
                              // Not used for the controls
                              onIncrease: () {
                                context.read<ProductQuantityBloc>().add(IncreaseQuantity());
                                // Notify parent after increment
                                if (widget.onThresholdChanged != null) {
                                  Future.delayed(Duration(milliseconds: 100), () {
                                    final newValue = int.tryParse(_quantityController.text) ?? 1;
                                    widget.onThresholdChanged!(newValue);
                                  });
                                }
                              },
                              onDecrease: () {
                                context.read<ProductQuantityBloc>().add(DecreaseQuantity());
                                // Notify parent after decrement
                                if (widget.onThresholdChanged != null) {
                                  Future.delayed(Duration(milliseconds: 100), () {
                                    final newValue = int.tryParse(_quantityController.text) ?? 1;
                                    widget.onThresholdChanged!(newValue);
                                  });
                                }
                              },
                              quantityCntroller: _quantityController,
                              onTextfieldChanged: (value) {
                                context.read<ProductQuantityBloc>().add(QuantityChanged(value));
                                // Notify parent on text change
                                if (widget.onThresholdChanged != null) {
                                  final newValue = int.tryParse(value) ?? 1;
                                  widget.onThresholdChanged!(newValue);
                                }
                              },
                              onDone: () => context
                                  .read<ProductQuantityBloc>()
                                  .add(QuantityEditingComplete()),
                              fromDetailedScreen: true,
                              title: widget.quantityLabel,
                            ),
                          ),
                        ],
                      ):SizedBox(),
                    ),
                  ],
                );
              },
            ),
          ),

        ],
      ),
    );
  }
}
