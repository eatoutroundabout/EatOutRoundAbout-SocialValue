import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/models/product_model.dart';
import 'package:eatoutroundabout/screens/messages/view_image.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/offer_tile.dart';
import 'package:eatoutroundabout/widgets/product_item.dart';
import 'package:eatoutroundabout/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/offer_model.dart';

class ViewBusinessProfile extends StatelessWidget {
  final BusinessProfile? businessProfile;

  ViewBusinessProfile({this.businessProfile});

  final firestoreService = Get.find<FirestoreService>();
  final utilService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: <Widget>[
          Heading(title: 'SOCIAL VALUE PROFILE', textScaleFactor: 1.75),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: appBackground,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => Get.to(() => ViewImages(index: 0, images: [businessProfile!.logo])),
                          child: CachedImage(url: businessProfile!.logo, height: 120),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(businessProfile!.businessName!, style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                            SizedBox(height: 15),
                            Text('Profile created On: ' + DateFormat('dd MMM yyyy').format(businessProfile!.creationDate!.toDate()), textScaleFactor: 0.9, style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Summary', style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                            SizedBox(height: 15),
                            Text(businessProfile!.summary!, textAlign: TextAlign.justify),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description', style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                            SizedBox(height: 15),
                            Text(businessProfile!.description!, textAlign: TextAlign.justify),
                          ],
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: firestoreService.getBusinessProducts(businessProfile!.businessProfileID!),
                      builder: (context, AsyncSnapshot<QuerySnapshot<Product>> snapshot) {
                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(padding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Products', style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, i) {
                                        Product product = snapshot.data!.docs[i].data();
                                        return ProductItem(product: product, isMyProduct: false);
                                      }),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    FutureBuilder(
                      future: firestoreService.getBusinessOffers(businessProfile!.businessProfileID!),
                      builder: (context, AsyncSnapshot<QuerySnapshot<Offer>> snapshot) {
                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(padding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Offers', style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, i) {
                                        Offer product = snapshot.data!.docs[i].data();
                                        return OfferTile(offer: product, isMyOffer: false);
                                      }),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('People who work here', style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                            SizedBox(height: 15),
                            UserTile(userID: businessProfile!.userID),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(FontAwesomeIcons.facebookF),
                          color: businessProfile!.facebook!.isNotEmpty ? Colors.indigo : Colors.grey,
                          onPressed: () => businessProfile!.facebook!.isNotEmpty ? utilService.openLink(businessProfile!.facebook!) : null,
                        ),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.instagram),
                          color: businessProfile!.instagram!.isNotEmpty ? Colors.pinkAccent : Colors.grey,
                          onPressed: () => businessProfile!.instagram!.isNotEmpty ? utilService.openLink(businessProfile!.instagram!) : null,
                        ),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.twitter),
                          color: businessProfile!.twitter!.isNotEmpty ? Colors.lightBlueAccent : Colors.grey,
                          onPressed: () => businessProfile!.twitter!.isNotEmpty ? utilService.openLink(businessProfile!.twitter!) : null,
                        ),
                        IconButton(
                          icon: Icon(FontAwesomeIcons.linkedinIn),
                          color: businessProfile!.linkedIn!.isNotEmpty ? Colors.blueAccent : Colors.grey,
                          onPressed: () => businessProfile!.linkedIn!.isNotEmpty ? utilService.openLink(businessProfile!.linkedIn!) : null,
                        ),
                      ],
                    ),
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
