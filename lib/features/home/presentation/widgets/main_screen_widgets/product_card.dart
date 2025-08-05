import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import '../../../../../core/theme/colors.dart';
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
  int price=100;
  TextEditingController quantityController = TextEditingController(text: '1');

  @override
  onIncrease(){
    int current = int.tryParse(quantityController.text) ?? 1;
    quantityController.text = (current + 1).toString();
    price=100*current;
        setState(() {

        });
  }

  onDecrease(){
    int current = int.tryParse(quantityController.text) ?? 1;
   if(current>1){
     quantityController.text = (current -1).toString();
   }
   price=100*current;
    setState(() {

    });
  }

  onTextfieldChanged(String value){
    if(quantityController.text.isNotEmpty){

      int current=int.parse(value);

      price=100*current;
      quantityController.text=current.toString();
    }

    setState(() {

    });
  }
  ondone(){
     if(quantityController.text.isEmpty){
       quantityController.text='1';
     }
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.screenHeight * .02),
      child: Container(
        width: widget.screenWidth * .24,
        //height: widget.screenHeight*.37,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.secondaryColorWithOpacity8,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor, // ظل خفيف
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
                    fit: BoxFit.cover, // تغطية كاملة
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
                        padding:  EdgeInsets.symmetric(vertical: widget.screenHeight*.01),
                        child: Text("Hand Pump Dispenser",style: TextStyle(color: AppColors.primary,fontSize: widget.screenWidth*.028,fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,),
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
                      Padding(
                        padding:  EdgeInsets.symmetric(vertical: widget.screenHeight*.01),
                        child: Text("QAR 20.00",style: TextStyle(color: AppColors.primary,fontSize: widget.screenWidth*.038,fontWeight: FontWeight.w600),overflow: TextOverflow.ellipsis,),
                      ),
                      Text(
                        'one-time purchase',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: widget.screenWidth*.028,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                   Padding(
                     padding:  EdgeInsets.symmetric(vertical: widget.screenHeight*.01),
                     child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         BuildRoundedIconOnProduct(context: context,width:widget.screenWidth,height:  widget.screenHeight,isPlus:  true,price: price,onIncrease: onIncrease,onDecrease: onDecrease,quantityCntroller: quantityController,onTextfieldChanged: onTextfieldChanged,onDone: ondone),
                         BuildRoundedIconOnProduct(context: context,width:widget.screenWidth,height:  widget.screenHeight,isPlus:  false,price: price,onIncrease: (){},onDecrease: (){},quantityCntroller: quantityController)
                       ],
                     ),
                   )
                    ],
                  ),
                ),

              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.screenWidth * .02,vertical: widget.screenHeight*.01
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BuildIconOnProduct(
                    widget.screenWidth,
                    widget.screenHeight,
                    true,
                  ),
                  BuildIconOnProduct(
                    widget.screenWidth,
                    widget.screenHeight,
                    false,
                  ),
                ],
              ),
            ),
          ],
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