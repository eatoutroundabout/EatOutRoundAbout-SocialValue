import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/models/social_value.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/loading.dart';

class GetSampleDocument extends StatelessWidget {
  final SocialValue? socialValue;
  final BusinessProfile? businessProfile;

  GetSampleDocument({this.businessProfile, this.socialValue});

  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body:
      FutureBuilder(
          future: firestoreService.getMySocialValueForBusProfile(socialValue!.businessProfileID!),
          builder: (context, AsyncSnapshot<DocumentSnapshot<SocialValue>> snapshot) {
            if (!snapshot.hasData)
              return LoadingData();
            else {
              SocialValue socialValue = snapshot.data!.data() as SocialValue;
              return
                Column(
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
                    SizedBox(height: 15),

                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Social Value', style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                            SizedBox(height: 15),
                            Text(socialValue.un1poverty!.toString(), textAlign: TextAlign.justify),
                          ],
                        ),
                      ),
                    ),

]
                ),
              ),
            ),
          ),
        ],
      );
    }
    }),
      );
  }
}
