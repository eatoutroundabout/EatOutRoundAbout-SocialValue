import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/connection_model.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/notification_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectButton extends StatelessWidget {
  final String? userID;
  final bool? showingOnProfile;

  ConnectButton({this.userID, this.showingOnProfile});

  final firestoreService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();
  final notificationService = Get.find<NotificationService>();

  @override
  Widget build(BuildContext context) {
    if (userController.currentUser.value.userID == userID)
      return Container();
    else
      return StreamBuilder(
        stream: firestoreService.checkIfConnected(userID),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            Connection connection = snapshot.data!.data() as Connection;
            return showingOnProfile ?? false
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(getColor(connection))),
                      child: Text(getText(connection), textScaleFactor: 1),
                      onPressed: () async => await action(connection),
                    ),
                  )
                : OutlinedButton(
                    style: ButtonStyle(side: MaterialStateProperty.all(BorderSide(color: getColor(connection))), padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 5))),
                    child: Text(getText(connection), textScaleFactor: 0.9, style: TextStyle(color: getColor(connection))),
                    onPressed: () async => await action(connection),
                  );
          } else
            return Container();
        },
      );
  }

  getText(Connection connection) {
    if (connection != null) {
      if (connection.connections!.contains(userID))
        return 'Connected';
      else if (connection.inBoundRequests!.contains(userID))
        return 'Respond';
      else if (connection.outBoundRequests!.contains(userID))
        return 'Requested';
      else if (connection.friends!.contains(userID))
        return 'Friends';
      else
        return 'Connect';
    } else
      return 'Connect';
  }

  getColor(Connection connection) {
    if (connection != null) {
      if (connection.connections!.contains(userID))
        return primaryColor;
      else if (connection.inBoundRequests!.contains(userID))
        return greenColor;
      else if (connection.outBoundRequests!.contains(userID))
        return Colors.grey;
      else if (connection.friends!.contains(userID))
        return primaryColor;
      else
        return redColor;
    } else
      return redColor;
  }

  action(Connection connection) async {
    if (getText(connection) == 'Connect') {
      await cloudFunction(
          functionName: 'sendConnectionRequest',
          parameters: {
            'senderUserID': userController.currentUser.value.userID,
            'receiverUserID': userID,
          },
          action: () async {
            await notificationService.sendNotification(
              parameters: {},
              body: 'New connection request : ' + userController.currentUser.value.firstName! + ' ' + userController.currentUser.value.lastName!,
              type: 'connectionRequest',
              receiverUserID: userID!,
            );
          });
    } else if (getText(connection) == 'Respond') {
      Get.defaultDialog(
        radius: padding / 2,
        contentPadding: const EdgeInsets.all(padding),
        title: 'Respond',
        content: Text('Would you like to accept this connection request?', textScaleFactor: 1.2, textAlign: TextAlign.center),
        actions: [
          ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(greenColor)),
              onPressed: () async {
                Get.back();
                await cloudFunction(
                    functionName: 'acceptConnectionRequest',
                    parameters: {
                      'receiverUserID': userController.currentUser.value.userID,
                      'senderUserID': userID,
                    },
                    action: () async {
                      await notificationService.sendNotification(
                        parameters: {
                          'receiverUserID': userID,
                        },
                        body: 'You are now connected with ' + userController.currentUser.value.firstName! + ' ' + userController.currentUser.value.lastName!,
                        type: 'connectionResponse',
                        receiverUserID: userID!,
                      );
                      showGreenAlert('Request Accepted');
                    });
              },
              child: Text('Connect')),
          ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.teal.shade50)),
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: primaryColor)),
          ),
        ],
      );
    }
  }
}
