import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/users_model.dart';
import 'package:eatoutroundabout/screens/profile/view_profile.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/connect_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserTile extends StatelessWidget {
  final userID;

  UserTile({this.userID});

  final firestoreService = Get.put(FirestoreService());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firestoreService.getUser(userID),
      builder: (context, AsyncSnapshot<DocumentSnapshot<User>> snapshot) {
        if (snapshot.hasData) {
          User? user = snapshot.data!.data();
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: padding / 2),
            onTap: () {
              print('GOING HERE');
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ViewProfile(userID: userID)));
              // Get.to(() => new FriendProfile(userID: userID));
            },
            leading: CachedImage(url: user!.photoURL, height: 50, roundedCorners: true),
            title: Text(user.firstName! + ' ' + user.lastName!, maxLines: 1, style: TextStyle(color: primaryColor)),
            subtitle: Text(user.userBio!, maxLines: 2, overflow: TextOverflow.ellipsis, textScaleFactor: 0.9, style: TextStyle(color: Colors.grey)),
            trailing: SizedBox(height: 25, width: 80, child: ConnectButton(userID: user.userID)),
          );
        } else
          return Container(height: 56);
      },
    );
  }
}
