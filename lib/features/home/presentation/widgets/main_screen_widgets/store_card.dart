import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

import '../../pages/suppliers/supplier_detail.dart';


class StoreCard extends StatefulWidget {
  double screenWidth;
  double screenHeight;
  String? imageUrl;
  StoreCard({required this.screenWidth,required this.screenHeight,this.imageUrl=''});

  @override
  State<StoreCard> createState() => _StoreCardState();
}

class _StoreCardState extends State<StoreCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => SupplierDetails()));

      },
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical: widget.screenHeight*.01,horizontal: widget.screenWidth*.01,),
        child: Container(
         // height: widget.screenWidth*.2,
          width: widget.screenWidth*.28,
         // color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: widget.screenWidth*.1,
                height: widget.screenHeight*.05,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: ClipOval(
                    child:
                    widget.imageUrl==null||widget.imageUrl==''?
                        Image.asset(
                            'assets/images/home/main_page/person.png'
                          //  fit: BoxFit.cover,
                        )
                    :
                    Image.network(
                      widget.imageUrl! ,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                            'assets/images/home/main_page/person.png'
                          //  fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: widget.screenHeight*.008),
                child: Text('Company A',style: TextStyle(fontSize: widget.screenWidth*.036,fontWeight: FontWeight.w500,),overflow: TextOverflow.ellipsis,),
              ),

              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Iconify(
                    MaterialSymbols.star,  // This uses the Material Symbols "star" icon
                    size: widget.screenHeight*.027,
                    color: Colors.amber,
                  ),
                  SizedBox(width: widget.screenWidth*.01,),
                  Text('5.0',style: TextStyle(fontSize: widget.screenWidth*.03,fontWeight: FontWeight.w500))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
