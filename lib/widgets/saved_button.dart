import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/favorites_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SavedButton extends StatelessWidget {
  final String? venueID;

  SavedButton({this.venueID});

  final firestoreService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestoreService.getVenueSavedStatus(venueID!),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData)
          return IconButton(
            onPressed: () async {
              snapshot.data!.exists ? await firestoreService.unSaveVenue(venueID!) : await firestoreService.saveVenue(Favorite(userID: userController.currentUser.value.userID, venueID: venueID!));
            },
            icon: Icon(
              snapshot.data!.exists ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
              color: !snapshot.data!.exists ? Colors.white54 : Colors.red.shade300,
              size: 20,
            ),
          );
        else
          return Container();
      },
    );
  }
}
