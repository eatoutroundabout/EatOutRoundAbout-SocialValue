import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/product_model.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VenueProducts extends StatefulWidget {
  final Venue? venue;

  VenueProducts({this.venue});

  @override
  _VenueProductsState createState() => _VenueProductsState();
}

class _VenueProductsState extends State<VenueProducts> {
  final firestoreService = Get.find<FirestoreService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: <Widget>[
          Heading(title: 'PRODUCTS'),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              color: appBackground,
              child: StreamBuilder(
                stream: firestoreService.getProducts(widget.venue!.venueID!, 5000),
                builder: (context, AsyncSnapshot<QuerySnapshot<Product>> snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    print(snapshot.data!.docs.length);
                    return ListView.builder(
                      itemBuilder: (context, i) {
                        DocumentSnapshot doc = snapshot.data!.docs[i];
                        Product review = doc.data() as Product;
                        return ProductItem(product: review);
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
                  } else
                    return Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
