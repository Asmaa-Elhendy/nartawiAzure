import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/theme/colors.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_bloc.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_event.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_state.dart';
import '../../../home/presentation/pages/suppliers/product_details.dart';
import '../../../home/presentation/widgets/main_screen_widgets/price_widget.dart';
import '../../../home/presentation/widgets/main_screen_widgets/products/icon_on_product_card.dart';
import '../../../home/presentation/widgets/main_screen_widgets/products/product_card.dart';
import '../../../profile/presentation/widgets/quantity_increase_Decrease.dart';

class FavouriteProductCard extends StatefulWidget {
  double screenWidth;
  double screenHeight;
  String icon;
  bool fromCartScreen;

  FavouriteProductCard({
    required this.screenWidth,
    required this.screenHeight,
    required this.icon,
    this.fromCartScreen = false,
  });

  @override
  State<FavouriteProductCard> createState() => _FavouriteProductCardState();
}

class _FavouriteProductCardState extends State<FavouriteProductCard> {
  late final TextEditingController _quantityController;
  late final ProductQuantityBloc _quantityBloc;
  late final ProductQuantityBloc _quantityTwoBloc;
  late final TextEditingController _quantityTwoController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: '1');
    _quantityBloc = ProductQuantityBloc(
      calculateProductPrice: CalculateProductPrice(),
      basePrice: 100.0,
    );
    _quantityTwoBloc = ProductQuantityBloc(
      calculateProductPrice: CalculateProductPrice(),
      basePrice: 100.0,
    );
    _quantityTwoController = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _quantityBloc.close();
    _quantityBloc.close();
    _quantityTwoBloc.close();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator
        // .pushNamed(context, '/productDetail');
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => ProductDetailScreen()));
      },
      child: BlocProvider.value(
        value: _quantityBloc,
        child: BlocBuilder<ProductQuantityBloc, ProductQuantityState>(
          builder: (context, state) {
            // Update controller when state changes
            if (_quantityController.text != state.quantity) {
              _quantityController.text = state.quantity;
            }
            double containerHeight = widget.fromCartScreen
                ? widget.screenHeight * .29//.33 handle design shimaa
                : widget.screenHeight * .257; //handle height of favourite product card handle design dhimaa
            return Padding(
              padding: EdgeInsets.only(
                bottom: widget.screenHeight * .02,
                left: widget.fromCartScreen ? 0 : widget.screenWidth * .06,
                right: widget.fromCartScreen ? 0 : widget.screenWidth * .06,
              ),
              child: Container(
                width: widget.screenWidth,
                height: containerHeight,
                //from cart can be coupon or product (weekly sent bundles)
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.favouriteProductCard,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                              child: Image.asset(
                                widget.icon,
                                width: widget.screenWidth * .31,
                                // match or be smaller than container
                                height: containerHeight,
                                //height according container
                                fit: BoxFit.cover,
                              ),
                            ),
                            widget.fromCartScreen//j
                                ? Positioned(
                                    top: widget.screenHeight * 0.01,
                                    left: widget.screenWidth * 0.01,
                                    child: BuildIconOnProduct(state.price,
                                      isDelete: true,
                                      widget.screenWidth,
                                      widget.screenHeight,
                                      true, // plus icon
                                      true,
                                    ),
                                  )
                                : Positioned(
                                    top: widget.screenHeight * 0.01,
                                    right: widget.screenWidth * 0.01,
                                    left: widget.screenWidth * 0.01,
                                    child: Row(
                                      //  mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        BuildIconOnProduct(state.price,
                                          widget.screenWidth,
                                          widget.screenHeight,
                                          true, // plus icon
                                          true,
                                        ),
                                        //      SizedBox(width: widget.screenWidth * 0.02), // Spacing between icons
                                        BuildIconOnProduct(state.price,
                                          widget.screenWidth,
                                          widget.screenHeight,
                                          false, // heart icon
                                          true,
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: widget.screenHeight * .01,
                              top: widget.screenHeight * .01,
                              right: widget.screenWidth * .03,
                              left: widget.screenWidth * .03,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.fromCartScreen
                                    ? SizedBox()
                                    : ProductTitle(
                                        widget.screenHeight,
                                        widget.screenWidth,
                                      ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: widget.fromCartScreen
                                        ? 0
                                        : widget.screenWidth * .01,
                                    bottom: widget.screenHeight * .01,
                                  ),
                                  child: Text(
                                    "Hand Pump Dispenser",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: widget.screenWidth * .03, //.028
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  'company hand pump dispenser-pure natural...',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: widget.screenWidth * .028,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: widget.screenHeight * .01,
                                  ),
                                  child: Text(
                                    "QAR 100.00",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: widget.screenWidth * .036,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  'one-time purchase',
                                  style: TextStyle(
                                    fontSize: widget.screenWidth * .028,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: widget.screenHeight * .01,
                                    horizontal: widget.screenWidth * .01,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: BuildRoundedIconOnProduct(
                                          fromCartScreen: widget.fromCartScreen,
                                          context: context,
                                          width: widget.screenWidth,
                                          height: widget.screenHeight,
                                          isPlus: true,
                                          price: 0,
                                          onIncrease: () => context
                                              .read<ProductQuantityBloc>()
                                              .add(IncreaseQuantity()),
                                          onDecrease: () => context
                                              .read<ProductQuantityBloc>()
                                              .add(DecreaseQuantity()),
                                          quantityCntroller: _quantityController,
                                          onTextfieldChanged: (value) => context
                                              .read<ProductQuantityBloc>()
                                              .add(QuantityChanged(value)),
                                          onDone: () => context
                                              .read<ProductQuantityBloc>()
                                              .add(QuantityEditingComplete()),
                                        ),
                                      ),
                                      SizedBox(width: widget.screenWidth*.01,),
                                      BuildPriceContainer(
                                        widget.screenWidth,
                                        widget.screenHeight,
                                        state,
                                      ),
                                    ],
                                  ),
                                ),
                                widget.fromCartScreen
                                    ? //not always when coupon only not product in cart screen
                                      Text(
                                        "Weekly Sent Bundles",
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: widget.screenWidth * .036,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : SizedBox(),
                                widget.fromCartScreen
                                    ? BlocProvider.value(
                                        value: _quantityTwoBloc,
                                        child:
                                            BlocBuilder<
                                              ProductQuantityBloc,
                                              ProductQuantityState
                                            >(
                                              builder: (context, state) {
                                                // Update controller when state changes
                                                if (_quantityTwoController
                                                        .text !=
                                                    state.quantity) {
                                                  _quantityTwoController.text =
                                                      state.quantity;
                                                }
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        top:
                                                            widget
                                                                .screenHeight *
                                                            0.01,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: IncreaseDecreaseQuantity(
                                                              context: context,
                                                              width: widget
                                                                  .screenWidth,
                                                              height: widget
                                                                  .screenHeight,
                                                              isPlus: true,
                                                              price: 0,
                                                              // Not used for the controls
                                                              onIncrease: () => context
                                                                  .read<
                                                                    ProductQuantityBloc
                                                                  >()
                                                                  .add(
                                                                    IncreaseQuantity(),
                                                                  ),
                                                              onDecrease: () => context
                                                                  .read<
                                                                    ProductQuantityBloc
                                                                  >()
                                                                  .add(
                                                                    DecreaseQuantity(),
                                                                  ),
                                                              quantityCntroller:
                                                                  _quantityTwoController,
                                                              onTextfieldChanged:
                                                                  (
                                                                    value,
                                                                  ) => context
                                                                      .read<
                                                                        ProductQuantityBloc
                                                                      >()
                                                                      .add(
                                                                        QuantityChanged(
                                                                          value,
                                                                        ),
                                                                      ),
                                                              onDone: () => context
                                                                  .read<
                                                                    ProductQuantityBloc
                                                                  >()
                                                                  .add(
                                                                    QuantityEditingComplete(),
                                                                  ),
                                                              fromDetailedScreen:
                                                                  true,
                                                              title: '',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
