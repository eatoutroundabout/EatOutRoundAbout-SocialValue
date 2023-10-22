import 'package:eatoutroundabout/models/product_model.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailItem extends StatelessWidget {
  final Product? product;

  ProductDetailItem({this.product});

  final miscService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(padding / 2),
            color: Colors.white,
          ),
          child: Row(
            children: [
              CachedImage(height: Get.width * .5, url: product!.promoImage),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product!.productName!, textScaleFactor: 1, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(product!.description!, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 5),
                      Text('£' + product!.price.toString(), textScaleFactor: 1, style: TextStyle(color: greenColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
