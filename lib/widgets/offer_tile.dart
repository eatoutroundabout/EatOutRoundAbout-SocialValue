import 'package:eatoutroundabout/models/offer_model.dart';
import 'package:eatoutroundabout/screens/offer/view_offer.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfferTile extends StatelessWidget {
  final Offer? offer;
  final bool? isMyOffer;

  OfferTile({this.offer, this.isMyOffer});

  final miscService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(top: 15),
      onTap: () => Get.to(() => ViewOffer(offer: offer!)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(offer!.title!),
          SizedBox(height: 5),
          Text(offer!.offering!, style: TextStyle(color: greenColor)),
        ],
      ),
      leading: CachedImage(height: 60, url: offer!.promoImage),
    );
  }
}
