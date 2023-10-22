import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/utils/preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

setupNotifications() {
  //1. Request Notification Permissions
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (isAllowed) AwesomeNotifications().requestPermissionToSendNotifications();
  });

  //2. Initialize Notification Channels
  initNotifications();

  //3. Initialize Firebase Background Handler
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  //4. Listen and Show Notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) => showNotification(message));
}

Future<void> backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  showNotification(message);
}

showNotification(RemoteMessage message) async {
  if (await Preferences.getNotificationStatus()) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(id: 10, channelKey: 'eora_channel', title: message.notification!.title, body: message.notification!.body),
    );
  }
  final userController = Get.put(UserController());
  if (message.data['type'] == 'message')
    userController.currentUser.value.unreadMessages = true;
  else
    userController.currentUser.value.unreadNotifications = true;
}

initNotifications() {
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'eora_channel_group',
        channelKey: 'eora_channel',
        channelName: 'Notifications',
        channelDescription: 'Notification channel for The Break Room',
        defaultColor: primaryColor,
        ledColor: Colors.green,
        //channelShowBadge: true,
      ),
    ],
  );
}
