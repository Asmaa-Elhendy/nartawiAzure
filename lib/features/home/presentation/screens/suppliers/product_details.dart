import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/price_widget.dart';


import '../../../../../core/theme/colors.dart';
import '../../bloc/product_quantity/product_quantity_bloc.dart';
import '../../bloc/product_quantity/product_quantity_event.dart';
import '../../bloc/product_quantity/product_quantity_state.dart';
import '../../widgets/background_home_Appbar.dart';
import '../../widgets/build_ForegroundAppBarHome.dart';
import '../../widgets/main_screen_widgets/checked_box_container.dart';
import '../../widgets/main_screen_widgets/products/icon_on_product_card.dart';
import '../../widgets/main_screen_widgets/products/product_card.dart';
import '../../widgets/main_screen_widgets/suppliers/tapBarfirstPage.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
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
  }  @override
  void dispose() {
    _quantityController.dispose();
    _quantityBloc.close();
    super.dispose();
  }
  String? imageUrl=null;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent, // في حالة الصورة في الخلفية

        // ✅ أضف ده
        body: Stack(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight,
                color: AppColors.backgrounHome,
              ),
              buildBackgroundAppbar(screenWidth),
              BuildForegroundappbarhome(
                screenHeight: screenHeight,
                screenWidth: screenWidth,title: 'Product Details',is_returned: true,
              ),
              Positioned.fill(
                  top: MediaQuery.of(context).padding.top + screenHeight * .1,
                  child:
                  BlocProvider.value(
                      value: _quantityBloc,
                      child: BlocBuilder<ProductQuantityBloc, ProductQuantityState>(
                          builder: (context, state) {
                            // Update controller when state changes
                            if (_quantityController.text != state.quantity) {
                              _quantityController.text = state.quantity;
                            }


                            return Padding(
                              padding: EdgeInsets.only(top: screenHeight * .04,
                                  right: screenWidth * .05,
                                  left: screenWidth * .05),
                              child: Container(
                                width: screenWidth * .24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColors.whiteColor,
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
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20)),
                                          child: Image.asset(
                                            "assets/images/home/main_page/product.jpg",
                                            width: double.infinity,
                                            height: screenHeight * 0.2,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: screenHeight * .01,
                                            horizontal: screenWidth * .02,
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              ProductTitle(
                                                  screenHeight, screenWidth),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: screenHeight *
                                                        .01),
                                                child: Text(
                                                  "Hand Pump Dispenser",
                                                  style: TextStyle(
                                                      color: AppColors.primary,
                                                      fontSize: screenWidth *
                                                          .028,
                                                      fontWeight: FontWeight
                                                          .w600
                                                  ),
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),
                                              ),
                                              Text(
                                                'company hand pump dispenser-pure natural...',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: screenWidth * .028,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              // Static price display
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: screenHeight *
                                                        .01),
                                                child: Text(
                                                  "QAR 100.00",
                                                  style: TextStyle(
                                                      color: AppColors.primary,
                                                      fontSize: screenWidth *
                                                          .038,
                                                      fontWeight: FontWeight
                                                          .w600
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'one-time purchase',
                                                style: TextStyle(
                                                  fontSize: screenWidth * .028,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Padding(
                                                padding:  EdgeInsets.symmetric(vertical: screenHeight*.02),
                                                child: Row(
                                                  children: [
                                                    BuildRoundedIconOnProduct(
                                                      context: context,
                                                      width:screenWidth,
                                                      height:screenHeight,
                                                      isPlus: true,
                                                      price: 0, // Not used for the controls
                                                      onIncrease: () => context.read<ProductQuantityBloc>().add(IncreaseQuantity()),
                                                      onDecrease: () => context.read<ProductQuantityBloc>().add(DecreaseQuantity()),
                                                      quantityCntroller: _quantityController,
                                                      onTextfieldChanged: (value) => context.read<ProductQuantityBloc>().add(QuantityChanged(value)),
                                                      onDone: () => context.read<ProductQuantityBloc>().add(QuantityEditingComplete()),
                                                                                                 fromDetailedScreen: true ),
                                                   SizedBox(width: screenWidth*.07,),
                                                    BuildPriceContainer(screenWidth, screenHeight, state)
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Top-right icons (add to cart and favorite)
                                    Positioned(
                                      top: screenHeight * 0.01,
                                      right: screenWidth * 0.02,
                                      left: screenWidth * 0.02,
                                      child: Row(
                                        //  mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          BuildIconOnProduct(
                                            screenWidth,
                                            screenHeight,
                                            true, // plus icon
                                          ),
                                          //      SizedBox(width: screenWidth * 0.02), // Spacing between icons
                                          BuildIconOnProduct(
                                            screenWidth,
                                            screenHeight,
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
                  ),





                  )]));

  }
}
