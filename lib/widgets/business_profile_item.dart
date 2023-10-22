import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/screens/admin/business/business_profile_details.dart';
import 'package:eatoutroundabout/screens/business/view_business_profile.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessProfileItem extends StatelessWidget {
  final String? businessProfileID;
  final bool? isMyBusinessProfile;

  BusinessProfileItem({this.businessProfileID, this.isMyBusinessProfile});

  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firestoreService.getBusinessByBusinessID(businessProfileID!),
      builder: (context, AsyncSnapshot<DocumentSnapshot<BusinessProfile>> snapshot) {
        if (snapshot.hasData) {
          BusinessProfile businessProfile = snapshot.data!.data()!;
          return InkWell(
            onTap: () {
              if (isMyBusinessProfile ?? false)
                Get.to(() => BusinessProfileDetails(businessProfile: businessProfile));
              else
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ViewBusinessProfile(businessProfile: businessProfile)));
            },
            child: Container(
              margin: EdgeInsets.only(bottom: padding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(padding / 2),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(padding / 2), bottomRight: Radius.circular(padding / 2)),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        CachedImage(
                          url: businessProfile.logo == '' ? 'assets/images/logo.png' : businessProfile.logo,
                          height: 80,
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(businessProfile.businessName!, textScaleFactor: 0.9, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Expanded(child: Text(businessProfile.summary!, textScaleFactor: 0.85, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: greenColor))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else
          return Container(height: 56);
      },
    );
  }
}
