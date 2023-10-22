import 'package:eatoutroundabout/models/offer_model.dart';
import 'package:eatoutroundabout/screens/admin/offer/offer_details.dart';
import 'package:eatoutroundabout/screens/home/webpage.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/business_profile_logo.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfferItem extends StatelessWidget {
  final Offer? offer;
  final bool? isMyOffer;

  OfferItem({this.offer, this.isMyOffer});

  final miscService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => isMyOffer! ? Get.to(() => OfferDetails(offer: offer!)) : null,
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: lightGreenColor,
          borderRadius: BorderRadius.circular(padding / 2),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedImage(url: offer!.promoImage, height: Get.width - 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: redColor,
                        borderRadius: BorderRadius.circular(padding / 2),
                      ),
                      margin: const EdgeInsets.only(top: padding),
                      padding: const EdgeInsets.all(padding),
                      child: Text(offer!.offering!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    if (offer!.businessProfileID != '') BusinessProfileLogo(businessProfileID: offer!.businessProfileID),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(padding / 2), bottomRight: Radius.circular(padding / 2)),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(offer!.title!, style: TextStyle(color: greenColor), textScaleFactor: 1.2),
                  SizedBox(height: 10),
                  Text(offer!.description!),
                  SizedBox(height: 10),
                  Text('Quote: ' + offer!.quote!, style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 15),
                  CustomButton(
                    text: 'Visit Website',
                    color: redColor,
                    function: () => Get.to(() => MyWebView(url: offer!.website)),
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
