import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/screens/business/view_business_profile.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessProfileLogo extends StatelessWidget {
  final businessProfileID;

  BusinessProfileLogo({this.businessProfileID});

  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    print(businessProfileID);
    return FutureBuilder(
      future: firestoreService.getBusinessByBusinessID(businessProfileID),
      builder: (context, AsyncSnapshot<DocumentSnapshot<BusinessProfile>> snapshot) {
        if (snapshot.hasData) {
          BusinessProfile businessProfile = snapshot.data!.data()!;
          return Padding(
            padding: const EdgeInsets.all(padding),
            child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ViewBusinessProfile(businessProfile: businessProfile)));
                },
                child: CachedImage(url: businessProfile.logo, height: 80)),
          );
        } else
          return Container(height: 80 + padding * 2);
      },
    );
  }
}
