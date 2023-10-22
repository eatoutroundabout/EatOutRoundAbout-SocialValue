import 'package:eatoutroundabout/models/product_model.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:eatoutroundabout/widgets/product_item.dart';
import 'package:eatoutroundabout/widgets/stock_product_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ManageProducts extends StatefulWidget {
  final Venue? venue;

  ManageProducts({this.venue});

  @override
  _ManageProductsState createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: <Widget>[
          Heading(title: 'MANAGE PRODUCTS'),
          Expanded(
            child: PaginateFirestore(
              isLive: true,
              padding: const EdgeInsets.all(padding),
              key: GlobalKey(),
              shrinkWrap: true,
              itemBuilderType: PaginateBuilderType.listView,
              itemBuilder: (context, documentSnapshot, i) {
                Product review = documentSnapshot[i].data() as Product;
                return Card(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ProductItem(product: review),
                      ),
                      StockProductButton(product: review, venue: widget.venue),
                    ],
                  ),
                );
              },
              query: firestoreService.getAllProductsQuery(),
              onEmpty: EmptyBox(text: 'You are all caught up!'),
              itemsPerPage: 10,
              bottomLoader: LoadingData(),
              initialLoader: LoadingData(),
            ),
          ),
        ],
      ),
    );
  }
}
