import 'package:eatoutroundabout/models/product_model.dart';
import 'package:eatoutroundabout/screens/admin/product/edit_product.dart';
import 'package:eatoutroundabout/screens/venues/view_product.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetails extends StatelessWidget {
  final Product? product;

  ProductDetails({this.product});

  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            color: Colors.white,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(product!.productName!, textScaleFactor: 1.25, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text(product!.category!, style: TextStyle(color: greenColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Divider(height: 1),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(padding * 2, padding * 2, padding * 2, 0),
              color: appBackground,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomButton(
                      color: primaryColor,
                      text: 'View Product',
                      function: () => Get.to(() => ViewProduct(product: product)),
                    ),
                    SizedBox(height: padding),
                    CustomButton(
                      color: primaryColor,
                      text: 'Edit Product',
                      function: () => Get.to(() => EditProduct(product: product)),
                    ),
                    SizedBox(height: padding),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
