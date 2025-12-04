import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/price_widget.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/products/SecondTabProductDetail.dart';
import 'package:newwwwwwww/features/home/presentation/widgets/main_screen_widgets/products/firstTabProductDetail.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/components/confirmation_alert.dart';
import '../../bloc/cart/cart_bloc.dart';
import '../../bloc/cart/cart_event.dart';
import '../../bloc/product_quantity/product_quantity_bloc.dart';
import '../../bloc/product_quantity/product_quantity_event.dart';
import '../../bloc/product_quantity/product_quantity_state.dart';
import '../../widgets/background_home_Appbar.dart';
import '../../widgets/build_ForegroundAppBarHome.dart';
import '../../widgets/main_screen_widgets/products/icon_on_product_card.dart';
import '../../widgets/main_screen_widgets/products/product_card.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final TextEditingController _quantityController;
  late final ProductQuantityBloc _quantityBloc;

  String? imageUrl = null;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _quantityController = TextEditingController(text: '1');
    _quantityBloc = ProductQuantityBloc(
      calculateProductPrice: CalculateProductPrice(),
      basePrice: 100.0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _quantityController.dispose();
    _quantityBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: BlocProvider.value(
        value: _quantityBloc,
        child: BlocBuilder<ProductQuantityBloc, ProductQuantityState>(
          builder: (context, state) {
            // sync textfield with bloc state (without changing your logic)
            if (_quantityController.text != state.quantity) {
              _quantityController.text = state.quantity;
            }

            return Stack(
              children: [
                Container(
                  width: screenWidth,
                  height: screenHeight,
                  color: AppColors.backgrounHome,
                ),
                buildBackgroundAppbar(screenWidth),
                BuildForegroundappbarhome(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  title: 'Product Details',
                  is_returned: true,
                  onReturnFromSupplierDetail: () {
                    final currentQuantity =
                        int.tryParse(_quantityBloc.state.quantity) ?? 1;
                    if (currentQuantity > 1) {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => ConfirmationAlert(
                          price: state.price,
                          centerTitle:
                          "You Have Selected 1 Item, But You Haven’t Confirmed Your Choice Yet",
                          leftOnTap: () {
                            Navigator.pop(dialogContext);
                            context
                                .read<CartBloc>()
                                .add(CartAddItem('Hand Pump'));
                            Navigator.pop(context);
                          },
                          rightOnTap: () {
                            Navigator.pop(dialogContext);
                            Navigator.pop(context);
                          },
                          leftTtile: 'Add To Cart',
                          rightTitle: 'Continue Shopping',
                          itemAAdedToCart: true,
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                Positioned.fill(
                  top: MediaQuery.of(context).padding.top + screenHeight * .1,
                  bottom: screenHeight * .05 + screenHeight * .09,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: screenWidth * .05,
                        left: screenWidth * .05,
                        bottom: screenHeight * .04,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
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
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      ProductTitle(
                                          screenHeight, screenWidth),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: screenHeight * .01,
                                        ),
                                        child: Text(
                                          "Hand Pump Dispenser",
                                          style: TextStyle(
                                            fontSize: screenWidth * .028,
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
                                          fontSize: screenWidth * .028,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: screenHeight * .01,
                                        ),
                                        child: Text(
                                          "QAR 100.00",
                                          style: TextStyle(
                                            fontSize: screenWidth * .038,
                                            fontWeight: FontWeight.w600,
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
                                        padding: EdgeInsets.symmetric(
                                          vertical: screenHeight * .02,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: BuildRoundedIconOnProduct(
                                                context: context,
                                                width: screenWidth,
                                                height: screenHeight,
                                                isPlus: true,
                                                price: 0,
                                                onIncrease: () => context
                                                    .read<
                                                    ProductQuantityBloc>()
                                                    .add(IncreaseQuantity()),
                                                onDecrease: () => context
                                                    .read<
                                                    ProductQuantityBloc>()
                                                    .add(DecreaseQuantity()),
                                                quantityCntroller:
                                                _quantityController,
                                                onTextfieldChanged: (value) =>
                                                    context
                                                        .read<
                                                        ProductQuantityBloc>()
                                                        .add(
                                                      QuantityChanged(
                                                        value,
                                                      ),
                                                    ),
                                                onDone: () => context
                                                    .read<
                                                    ProductQuantityBloc>()
                                                    .add(
                                                  QuantityEditingComplete(),
                                                ),
                                                fromDetailedScreen: true,
                                              ),
                                            ),
                                            SizedBox(
                                              width: screenWidth * .04,
                                            ),
                                            BuildPriceContainer(
                                              screenWidth,
                                              screenHeight,
                                              state,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // TabBar
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: screenHeight * .004,
                                          horizontal: screenWidth * .004,
                                        ),
                                        margin: EdgeInsets.symmetric(
                                          horizontal: screenWidth * .04,
                                        ),
                                        height: screenHeight * .05,
                                        decoration: BoxDecoration(
                                          color: AppColors.tabViewBackground,
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                        child: TabBar(
                                          controller: _tabController,
                                          indicator: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            color: AppColors.whiteColor,
                                          ),
                                          indicatorSize:
                                          TabBarIndicatorSize.tab,
                                          dividerColor: Colors.transparent,
                                          labelStyle: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                          unselectedLabelColor: AppColors
                                              .greyDarktextIntExtFieldAndIconsHome,
                                          tabs: [
                                            SizedBox(
                                              width: screenWidth * .5,
                                              child: const Tab(
                                                text: 'Product Details',
                                              ),
                                            ),
                                            SizedBox(
                                              width: screenWidth * .5,
                                              child: const Tab(
                                                text: 'Reviews',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * .015),

                                      // Replaced TabBarView with AnimatedBuilder (as you had)
                                      AnimatedBuilder(
                                        animation: _tabController,
                                        builder: (context, _) {
                                          if (_tabController.index == 0) {
                                            return BuildFirstTabProductDetail(
                                              screenWidth,
                                              screenHeight,
                                            );
                                          } else {
                                            return BuildSecondTabProductDetail(
                                              screenWidth,
                                              screenHeight,
                                            );
                                          }
                                        },
                                      ),
                                      SizedBox(height: screenHeight * .02),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: screenHeight * 0.01,
                              right: screenWidth * 0.02,
                              left: screenWidth * 0.02,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  BuildIconOnProduct(state.price,
                                    screenWidth,
                                    screenHeight,
                                    true,
                                    false,
                                  ),
                                  BuildIconOnProduct(state.price,
                                    screenWidth,
                                    screenHeight,
                                    false,
                                    false,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
