import 'package:eatoutroundabout/models/product_model.dart';
import 'package:eatoutroundabout/screens/admin/product/product_details.dart';
import 'package:eatoutroundabout/screens/venues/view_product.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductItem extends StatelessWidget {
  final Product? product;
  final bool? isMyProduct;

  ProductItem({this.product, this.isMyProduct});

  final miscService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Get.to(() => isMyProduct ?? false ? ProductDetails(product: product!) : ViewProduct(product: product!)),
      contentPadding: const EdgeInsets.only(top: 15),
      leading: CachedImage(url: product!.promoImage, height: 60),
      trailing: Icon(Icons.keyboard_arrow_right_rounded),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          children: [
            Expanded(child: Text(product!.productName!)),
            //Text('£' + product.price, style: TextStyle(color: greenColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      subtitle: Text(product!.description!, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey)),
    );
  }
}
