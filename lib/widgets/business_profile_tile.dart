import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/screens/business/view_business_profile.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessProfileTile extends StatelessWidget {
  final String? businessProfileID;

  BusinessProfileTile({this.businessProfileID});

  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    print(businessProfileID);
    return FutureBuilder(
      future: firestoreService.getBusinessByBusinessID(businessProfileID!),
      builder: (context, AsyncSnapshot<DocumentSnapshot<BusinessProfile>> snapshot) {
        if (snapshot.hasData) {
          BusinessProfile businessProfile = snapshot.data!.data()!;
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ViewBusinessProfile(businessProfile: businessProfile)));
            },
            leading: CachedImage(url: businessProfile.logo, height: 50),
            title: Text(businessProfile.businessName!, maxLines: 1, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
            trailing: Icon(Icons.keyboard_arrow_right_outlined),
          );
        } else
          return Container(height: 56);
      },
    );
  }
}
