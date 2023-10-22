import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/event_model.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendButton extends StatelessWidget {
  final String? eventID;

  AttendButton({this.eventID});

  final userController = Get.find<UserController>();
  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestoreService.getEventByEventIDStream(eventID!),
      builder: (context, AsyncSnapshot<DocumentSnapshot<Event>> snapshot) {
        if (snapshot.hasData) {
          Event thisEvent = snapshot.data!.data()!;
          return CustomButton(
            color: thisEvent.attendeeUserIDs!.contains(userController.currentUser.value.userID) ? Colors.grey : primaryColor,
            text: thisEvent.attendeeUserIDs!.contains(userController.currentUser.value.userID) ? 'Attending' : 'Attend',
            function: () async {
              if (!thisEvent.attendeeUserIDs!.contains(userController.currentUser.value.userID)) {
                await cloudFunction(
                    functionName: 'attendEvent',
                    parameters: {
                      'userID': userController.currentUser.value.userID,
                      'eventID': eventID,
                    },
                    action: () {});
              } else
                showGreenAlert('Already marked as attending');
            },
          );
        } else
          return Container();
      },
    );
  }
}
