import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/users_model.dart';
import 'package:eatoutroundabout/screens/profile/view_profile.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationConnection extends StatelessWidget {
  final userID;
  final bool? isConnected;

  NotificationConnection({this.userID, this.isConnected});

  final userController = Get.find<UserController>();
  final firestoreService = Get.put(FirestoreService());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firestoreService.getUser(userID),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          User? user = snapshot.data!.data() as User;
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            onTap: () => Get.to(() => ViewProfile(userID: userID)),
            leading: CachedImage(url: user.photoURL, height: 50, roundedCorners: false, circular: true),
            title: Text(user.firstName! + ' ' + user.lastName! + (isConnected! ? ' is now your connection' : ' wants to connect with you'), maxLines: 2, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
            subtitle: Text('Click to view profile'),
          );
        } else
          return Container(height: 56);
      },
    );
  }
}
