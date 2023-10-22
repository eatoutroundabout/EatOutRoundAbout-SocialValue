import 'package:eatoutroundabout/models/offer_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/offer_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewOffer extends StatelessWidget {
  final Offer? offer;

  ViewOffer({this.offer});

  final firestoreService = Get.find<FirestoreService>();
  final utilService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: <Widget>[
          Heading(title: 'VIEW OFFER', textScaleFactor: 1.75),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: OfferItem(offer: offer, isMyOffer: false),
            ),
          ),
        ],
      ),
    );
  }
}
