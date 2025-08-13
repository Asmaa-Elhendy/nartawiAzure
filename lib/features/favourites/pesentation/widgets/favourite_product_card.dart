import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:newwwwwwww/features/home/presentation/screens/suppliers/product_details.dart';
import '../../../../../../core/theme/colors.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_bloc.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_event.dart';
import '../../../home/presentation/bloc/product_quantity/product_quantity_state.dart';
import '../../../home/presentation/widgets/main_screen_widgets/price_widget.dart';
import '../../../home/presentation/widgets/main_screen_widgets/products/icon_on_product_card.dart';

class FavouriteProductCard extends StatefulWidget {
  double screenWidth;
  double screenHeight;
  String icon;

  FavouriteProductCard({
    required this.screenWidth,
    required this.screenHeight,
    required this.icon,
  });

  @override
  State<FavouriteProductCard> createState() => _FavouriteProductCardState();
}

class _FavouriteProductCardState extends State<FavouriteProductCard> {
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
    return InkWell(
      onTap: (){
        // Navigator.pushNamed(context, '/productDetail');
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductDetailScreen()));

      },
      child: BlocProvider.value(
        value: _quantityBloc,
        child: BlocBuilder<ProductQuantityBloc, ProductQuantityState>(
          builder: (context, state) {
            // Update controller when state changes
            if (_quantityController.text != state.quantity) {
              _quantityController.text = state.quantity;
            }

            return Padding(
              padding: EdgeInsets.only(bottom: widget.screenHeight * .02,left: widget.screenWidth*.06,right: widget.screenWidth*.06),
              child: Container(
                width: widget.screenWidth ,
                height: widget.screenHeight*.28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.favouriteProductCard,
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                              child:
                              Image.asset(
                                widget.icon,
                                 width: widget.screenWidth * .31, // match or be smaller than container
                                height: widget.screenHeight*.28,
                                fit: BoxFit.cover,
                             ),
                            ),
                            Positioned(
                              top: widget.screenHeight * 0.01,
                              right: widget.screenWidth * 0.01,
                              left: widget.screenWidth * 0.01,
                              child: Row(
                                //  mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  BuildIconOnProduct(
                                    widget.screenWidth,
                                    widget.screenHeight,
                                    true, // plus icon
                                      true
                                  ),
                                  //      SizedBox(width: widget.screenWidth * 0.02), // Spacing between icons
                                  BuildIconOnProduct(
                                    widget.screenWidth,
                                    widget.screenHeight,
                                    false, // heart icon
                                    true
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom:widget.screenHeight * .01 ,
                              top: widget.screenHeight * .02,
                              right: widget.screenWidth*.03,
                              left: widget.screenWidth*.03

                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ProductTitle(widget.screenHeight, widget.screenWidth),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: widget.screenHeight * .01),
                                  child: Text(
                                    "Hand Pump Dispenser",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: widget.screenWidth * .028,
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
                                  padding: EdgeInsets.symmetric(vertical: widget.screenHeight * .01),
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
                                  padding: EdgeInsets.symmetric(vertical: widget.screenHeight * .01,horizontal: widget.screenWidth*.01),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      BuildRoundedIconOnProduct(
                                        context: context,
                                        width: widget.screenWidth,
                                        height: widget.screenHeight,
                                        isPlus: true,
                                        price: 0,
                                        onIncrease: () => context.read<ProductQuantityBloc>().add(IncreaseQuantity()),
                                        onDecrease: () => context.read<ProductQuantityBloc>().add(DecreaseQuantity()),
                                        quantityCntroller: _quantityController,
                                        onTextfieldChanged: (value) => context.read<ProductQuantityBloc>().add(QuantityChanged(value)),
                                        onDone: () => context.read<ProductQuantityBloc>().add(QuantityEditingComplete()),
                                      ),
                                      BuildPriceContainer(widget.screenWidth, widget.screenHeight, state)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )



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
              height: screenHeight * .03,//
              fit: BoxFit.cover,
            ),
          ),SizedBox(width: screenWidth*.02,),
          Text('Company',style: TextStyle(fontSize: screenWidth*.032,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,)
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