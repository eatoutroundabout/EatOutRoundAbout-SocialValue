import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/book_table_model.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/notification_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingRequestItem extends StatelessWidget {
  final String? eventID;
  final String? notificationID;
  final String? senderUserID;

  BookingRequestItem({this.eventID, this.notificationID, this.senderUserID});

  final firestoreService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();
  final notificationService = Get.find<NotificationService>();
  final utilService = Get.find<UtilService>();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firestoreService.getBookingByBookingID(eventID!),
        builder: (context, AsyncSnapshot<DocumentSnapshot<BookTableModel>> snapshot) {
          if (snapshot.hasData) {
            BookTableModel event = snapshot.data!.data()!;
            if (event != null)
              return Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(padding / 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('You have received a booking request from - '),
                    UserTile(userID: senderUserID),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Booking Date'),
                        Text(DateFormat('MMMM dd, yyyy hh:mm aa').format(event.startTime!.toDate())),
                      ],
                    ),
                    Divider(color: Colors.transparent),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Attendees', style: TextStyle(color: primaryColor)),
                        Text(event.noAttendees.toString(), style: TextStyle(color: primaryColor)),
                      ],
                    ),
                    Divider(color: Colors.transparent),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Venue', style: TextStyle(color: primaryColor)),
                        FutureBuilder(
                          future: firestoreService.getVenueByVenueID(event.venueID!),
                          builder: (context,AsyncSnapshot<DocumentSnapshot<Venue>> snapshot) {
                            return Text(snapshot.hasData ? snapshot.data!.data()!.venueName! : '', style: TextStyle(color: primaryColor));
                          },
                        ),
                      ],
                    ),
                    Divider(color: Colors.transparent),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Approve',
                            color: primaryColor,
                            function: () async {
                              utilService.showLoading();
                              await firestoreService.updateEventRequest(event, true, notificationID!);
                              await notificationService.sendNotification(
                                parameters: {
                                  'receptionistID': userController.currentUser.value.userID,
                                  'eventID': eventID,
                                },
                                body: 'Congrats! Your table booking request has been approved',
                                type: 'tableBookingResponse',
                                receiverUserID: event.userID,
                              );
                              await notificationService.removeNotification(notificationID!);
                              Get.back();
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomButton(
                            color: redColor,
                            text: 'Deny',
                            function: () async {
                              utilService.showLoading();
                              await firestoreService.updateEventRequest(event, false, notificationID!);
                              await notificationService.sendNotification(
                                parameters: {
                                  'receptionistID': userController.currentUser.value.userID,
                                  'eventID': eventID,
                                },
                                body: 'Sorry. Your table booking request has been denied',
                                type: 'tableBookingResponse',
                                receiverUserID: event.userID,
                              );
                              await notificationService.removeNotification(notificationID!);
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            else
              return Container();
          } else
            return Container();
        });
  }
}
