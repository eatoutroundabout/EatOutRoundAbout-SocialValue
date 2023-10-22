import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/users_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class NotificationService {
  final userController = Get.find<UserController>();
  final ref = FirebaseFirestore.instance;
  final firestoreService = Get.find<FirestoreService>();

  getNotifications(int limit) {
    return ref.collection("notificationFeeds").where('receiverUserID', isEqualTo: userController.currentUser.value.userID).orderBy('creationDate', descending: true).limit(limit);
  }

  removeNotification(String notificationID) async {
    await ref.collection('notificationFeeds').doc(notificationID).delete();
  }

  sendNotification({Map<String, dynamic>? parameters, String? receiverUserID, String? body, String? type}) async {
    //GET RECEIVER USER FOR TOKEN
    DocumentSnapshot doc = await firestoreService.getUser(receiverUserID);
    User receiverUser = doc.data() as User;

    //ADD MANDATORY PARAMETERS FOR NOTIFICATION
    parameters!['creationDate'] = Timestamp.now();
    parameters['receiverUserID'] = receiverUserID;
    parameters['notificationID'] = Uuid().v1();
    parameters['senderUserID'] = userController.currentUser.value.userID;
    parameters['type'] = type;

    //DEPENDING ON THE TYPE STORE NOTIFICATION DETAILS AND FLAGS
    if (type != 'message') {
      await ref.collection('notificationFeeds').doc(parameters['notificationID']).set(parameters);
      await firestoreService.updateOtherUser({'unreadNotifications': true, 'userID': receiverUserID});
    } else
      await firestoreService.updateOtherUser({'unreadMessages': true, 'userID': receiverUserID});

    print(receiverUser.token);
    //SEND NOTIFICATIONS

    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'key=$serverToken'},
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'title': userController.currentUser.value.firstName! + ' ' + userController.currentUser.value.lastName!, 'body': body},
            'priority': 'high',
            'data': <String, dynamic>{'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'id': '1', 'status': 'done', 'type': type},
            'to': receiverUser.token,
          },
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
