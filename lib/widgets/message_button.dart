import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/connection_model.dart';
import 'package:eatoutroundabout/models/users_model.dart';
import 'package:eatoutroundabout/screens/messages/chats.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageButton extends StatelessWidget {
  final String? userID;

  MessageButton({this.userID});

  final firestoreService = Get.find<FirestoreService>();
  final utilService = Get.find<UtilService>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestoreService.checkIfConnected(userID),
      builder: (context, AsyncSnapshot<DocumentSnapshot<Connection>> snapshot) {
        Connection? connection = snapshot.hasData ? snapshot.data!.data() : null;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(getColor(connection!))),
            child: Text('Message', textScaleFactor: 1),
            onPressed: () async {
              if (connection.connections!.contains(userID)) {
                final messageService = Get.find<FirestoreService>();
                utilService.showLoading();
                String chatRoomID = await messageService.checkIfChatRoomExists(userID!);
                DocumentSnapshot doc = await firestoreService.getUser(userID);
                User chatUser = doc.data() as User;
                Get.back();
                Get.to(Chats(user: chatUser, chatRoomID: chatRoomID));
              }
            },
          ),
        );
      },
    );
  }

  getText(Connection connection) {
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
  }

  getColor(Connection connection) {
    if (connection != null) {
      if (connection.connections!.contains(userID))
        return greenColor;
      else
        return Colors.grey;
    } else
      return Colors.grey;
  }
}
