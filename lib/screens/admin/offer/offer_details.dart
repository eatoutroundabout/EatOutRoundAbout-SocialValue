import 'package:eatoutroundabout/models/offer_model.dart';
import 'package:eatoutroundabout/screens/admin/offer/edit_offer.dart';
import 'package:eatoutroundabout/screens/offer/view_offer.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfferDetails extends StatelessWidget {
  final Offer? offer;

  OfferDetails({this.offer});

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
                  child: Text(offer!.title!, textScaleFactor: 1.25, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text(offer!.offering!, style: TextStyle(color: greenColor, fontWeight: FontWeight.bold)),
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
                      text: 'View Offer',
                      function: () => Get.to(() => ViewOffer(offer: offer)),
                    ),
                    SizedBox(height: padding),
                    CustomButton(
                      color: primaryColor,
                      text: 'Edit Offer',
                      function: () => Get.to(() => EditOffer(offer: offer)),
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
