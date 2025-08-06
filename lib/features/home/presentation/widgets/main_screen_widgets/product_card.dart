import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import '../../../../../core/theme/colors.dart';
import '../../bloc/product_quantity/product_quantity_bloc.dart';
import '../../bloc/product_quantity/product_quantity_event.dart';
import '../../bloc/product_quantity/product_quantity_state.dart';
import 'icon_on_product_card.dart';

class ProductCard extends StatefulWidget {
  double screenWidth;
  double screenHeight;
  String icon;
  String title;

  ProductCard({
    required this.screenWidth,
    required this.screenHeight,
    required this.icon,
    required this.title,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late final TextEditingController _quantityController;
  late final ProductQuantityBloc _quantityBloc;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: '1');
    _quantityBloc = ProductQuantityBloc(
      calculateProductPrice: CalculateProductPrice(),
      basePrice: 100.0,
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _quantityBloc.close();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _quantityBloc,
      child: BlocBuilder<ProductQuantityBloc, ProductQuantityState>(
        builder: (context, state) {
          // Update controller when state changes
          if (_quantityController.text != state.quantity) {
            _quantityController.text = state.quantity;
          }

          return Padding(
            padding: EdgeInsets.only(bottom: widget.screenHeight * .02),
            child: Container(
              width: widget.screenWidth * .24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.secondaryColorWithOpacity8,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    offset: Offset(0, 2),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        child: Image.asset(
                          widget.icon,
                          width: double.infinity,
                          height: widget.screenHeight * 0.2,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: widget.screenHeight * .01,
                          horizontal: widget.screenWidth * .02,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProductTitle(widget.screenHeight, widget.screenWidth),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: widget.screenHeight*.01),
                              child: Text(
                                "Hand Pump Dispenser",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: widget.screenWidth*.028,
                                  fontWeight: FontWeight.w600
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              'company hand pump dispenser-pure natural...',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: widget.screenWidth*.028,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            // Static price display
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: widget.screenHeight*.01),
                              child: Text(
                                "QAR 100.00",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: widget.screenWidth*.038,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                            Text(
                              'one-time purchase',
                              style: TextStyle(
                                fontSize: widget.screenWidth*.028,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            // Quantity controls and dynamic price display
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: widget.screenHeight*.01),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Quantity controls
                                  BuildRoundedIconOnProduct(
                                    context: context,
                                    width: widget.screenWidth,
                                    height: widget.screenHeight,
                                    isPlus: true,
                                    price: 0, // Not used for the controls
                                    onIncrease: () => context.read<ProductQuantityBloc>().add(IncreaseQuantity()),
                                    onDecrease: () => context.read<ProductQuantityBloc>().add(DecreaseQuantity()),
                                    quantityCntroller: _quantityController,
                                    onTextfieldChanged: (value) => context.read<ProductQuantityBloc>().add(QuantityChanged(value)),
                                    onDone: () => context.read<ProductQuantityBloc>().add(QuantityEditingComplete()),
                                  ),
                                  // Dynamic price display
                                  Container(
                                    padding: EdgeInsets.all(widget.screenHeight*.005),
                                    width: widget.screenWidth * .15,
                                    height: widget.screenHeight * .045,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppColors.backgrounHome,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${(state.price).toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: widget.screenWidth * 0.036,
                                        ),overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Top-right icons (add to cart and favorite)
                  Positioned(
                    top: widget.screenHeight * 0.01,
                    right: widget.screenWidth * 0.02,
                    left: widget.screenWidth * 0.02,
                    child: Row(
                    //  mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BuildIconOnProduct(
                          widget.screenWidth,
                          widget.screenHeight,
                          true, // plus icon
                        ),
                  //      SizedBox(width: widget.screenWidth * 0.02), // Spacing between icons
                        BuildIconOnProduct(
                          widget.screenWidth,
                          widget.screenHeight,
                          false, // heart icon
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget ProductTitle(double screenHeight,double screenWidth){
  return  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Container(
            //   width: widget.screenWidth * .04,
            // الحجم العرض
            height: screenHeight * .03,
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
            child: Image.asset(
              "assets/images/home/main_page/company.png",
              height: screenHeight * .03,
              fit: BoxFit.cover,
            ),
          ),SizedBox(width: screenWidth*.02,),
          Text('Company',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,)
        ],
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Iconify(
            MaterialSymbols.star,  // This uses the Material Symbols "star" icon
            size: screenHeight*.025,
            color: Colors.amber,
          ),
          SizedBox(width: screenWidth*.01,),
          Text('5.0',style: TextStyle(fontSize: screenWidth*.03,fontWeight: FontWeight.w500))
        ],
      ),
    ],
  );
}