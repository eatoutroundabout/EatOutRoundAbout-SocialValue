import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/screens/home/view_powered_by.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
//import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';

class PoweredBy extends StatelessWidget {
  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.only(left: padding),
      child: FutureBuilder<QuerySnapshot<BusinessProfile>>(
          future: firestoreService.getPoweredBy(),
          builder: (context, AsyncSnapshot<QuerySnapshot<BusinessProfile>> snapshot) {
            if (!snapshot.hasData)
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 2, child: LinearProgressIndicator()),
                ],
              );
            else {
              List<BusinessProfile> list = [];
              for (int i = 0; i < snapshot.data!.docs.length; i++) list.add(snapshot.data!.docs[i].data());
              return InkWell(
                onTap: () => Get.to(() => ViewPoweredBy(businessProfilesList: list)),
                child: Row(
                  children: [
                    Text('Powered by -'),
                    Expanded(
                      child: Swiper(
                        autoplay: true,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          BusinessProfile businessProfile = snapshot.data!.docs[i].data();
                          return Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(businessProfile.businessName!),
                                  leading: CachedImage(url: businessProfile.logo, height: 45),
                                  trailing: Icon(Icons.keyboard_arrow_right_rounded),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
