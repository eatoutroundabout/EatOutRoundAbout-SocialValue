import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/users_model.dart';
import 'package:eatoutroundabout/screens/profile/view_profile.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserShortcut extends StatelessWidget {
  final userID;
  final bool? isDark;

  UserShortcut({this.userID, this.isDark});

  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firestoreService.getUser(userID),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data!.data() as User;
          return InkWell(
            onTap: () {
              Get.to(() => ViewProfile(userID: userID));
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedImage(url: user.photoURL, height: 40, circular: true),
                ),
                Text(user.firstName!, maxLines: 1, textScaleFactor: 1, style: TextStyle(color: isDark! ? Colors.white54 : Colors.black)),
              ],
            ),
          );
        } else
          return Container(height: 56);
      },
    );
  }
}
