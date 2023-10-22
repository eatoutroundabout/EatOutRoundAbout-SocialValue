import 'package:eatoutroundabout/models/notification_model.dart';
import 'package:eatoutroundabout/services/notification_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/booking_request_item.dart';
import 'package:eatoutroundabout/widgets/booking_response_item.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:eatoutroundabout/widgets/notification_connection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class NotificationsFeed extends StatelessWidget {
  final notificationService = Get.find<NotificationService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'NOTIFICATIONS'),
          Expanded(
            child: PaginateFirestore(
              isLive: true,
              padding: const EdgeInsets.all(padding),
              key: GlobalKey(),
              shrinkWrap: true,
              itemBuilderType: PaginateBuilderType.listView,
              itemBuilder: (context, documentSnapshot, i) {
                NotificationModel notification = NotificationModel.fromDocument(documentSnapshot[i]);
                if (notification.type == 'connectionRequest' || notification.type == 'connectionResponse')
                  return Dismissible(
                    key: Key(notification.notificationID!),
                    child: NotificationConnection(userID: notification.senderUserID, isConnected: notification.type == 'connectionResponse'),
                    onDismissed: (direction) async {
                      await notificationService.removeNotification(notification.notificationID!);
                    },
                  );
                else if (notification.type == 'tableBookingRequest') {
                  return Dismissible(
                    key: Key(notification.notificationID!),
                    child: BookingRequestItem(eventID: notification.eventID, notificationID: notification.notificationID, senderUserID: notification.senderUserID),
                    onDismissed: (direction) async {
                      await notificationService.removeNotification(notification.notificationID!);
                    },
                  );
                } else if (notification.type == 'tableBookingResponse') {
                  return Dismissible(
                    key: Key(notification.notificationID!),
                    child: BookingResponseItem(eventID: notification.eventID, senderUserID: notification.senderUserID),
                    onDismissed: (direction) async {
                      await notificationService.removeNotification(notification.notificationID!);
                    },
                  );
                } else
                  return Container();
              },
              query: notificationService.getNotifications(10),
              onEmpty: EmptyBox(text: 'You are all caught up!'),
              itemsPerPage: 10,
              bottomLoader: LoadingData(),
              initialLoader: LoadingData(),
            ),
          ),
        ],
      ),
    );
  }
}
