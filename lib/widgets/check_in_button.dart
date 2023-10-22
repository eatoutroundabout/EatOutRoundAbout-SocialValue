import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/event_model.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckInButton extends StatelessWidget {
  final String? eventID;

  CheckInButton({this.eventID});

  final userController = Get.find<UserController>();
  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestoreService.getEventByEventIDStream(eventID!),
        builder: (context, AsyncSnapshot<DocumentSnapshot<Event>> snapshot) {
          if (snapshot.hasData) {
            Event? thisEvent = snapshot.data!.data();
            return CustomButton(
              color: thisEvent!.checkedInUserIDs!.contains(userController.currentUser.value.userID) ? Colors.grey : redColor,
              text: thisEvent.checkedInUserIDs!.contains(userController.currentUser.value.userID) ? 'Checked In' : 'Check-In',
              function: () async {
                if (!thisEvent.checkedInUserIDs!.contains(userController.currentUser.value.userID)) {
                  showPromoCodeDialog();
                } else
                  showGreenAlert('Already checked in');
              },
            );
          } else
            return Container();
        });
  }

  showPromoCodeDialog() {
    TextEditingController promoCodeTEC = TextEditingController();
    Get.defaultDialog(
      radius: padding / 2,
      titlePadding: EdgeInsets.all(padding),
      contentPadding: EdgeInsets.all(padding),
      title: 'Enter the Event Code to Check-In',
      content: CustomTextField(
        label: '',
        hint: 'Enter Event Code',
        labelColor: greenColor,
        controller: promoCodeTEC,
        maxLines: 1,
        validate: true,
        isEmail: false,
        textInputType: TextInputType.text,
      ),
      actions: [
        ElevatedButton(
            onPressed: () async {
              Get.back();
              if (promoCodeTEC.text.isEmpty) {
                showRedAlert('Please enter a valid event code');
                return;
              }
              await cloudFunction(
                  functionName: 'eventCheckIn',
                  parameters: {
                    'userID': userController.currentUser.value.userID,
                    'promoCode': promoCodeTEC.text,
                    'eventID': eventID,
                    'longitude': userController.myLatitude,
                    'latitude': userController.myLongitude,
                  },
                  action: () {});
            },
            child: Text('Check-In')),
        ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.teal.shade50)),
          onPressed: () => Get.back(),
          child: Text('Cancel', style: TextStyle(color: primaryColor)),
        ),
      ],
    );
  }
}
