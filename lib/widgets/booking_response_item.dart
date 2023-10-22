import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/book_table_model.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/notification_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingResponseItem extends StatelessWidget {
  final String? eventID;
  final String? senderUserID;

  BookingResponseItem({this.eventID, this.senderUserID});

  final firestoreService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();
  final notificationService = Get.find<NotificationService>();

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
                    Text(
                      event.confirmed! ? 'Congrats! Your table booking request has been approved' : 'Sorry. Your table booking request has been denied.',
                      style: TextStyle(color: event.confirmed! ? greenColor : redColor),
                    ),
                    Divider(color: Colors.grey),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Booking Date'),
                        Text(DateFormat('MMMM dd, yyyy').format(event.startTime!.toDate())),
                      ],
                    ),
                    //Divider(color: Colors.transparent),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Attendees', style: TextStyle(color: primaryColor)),
                        Text(event.noAttendees.toString(), style: TextStyle(color: primaryColor)),
                      ],
                    ),
                    //Divider(color: Colors.transparent),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Venue', style: TextStyle(color: primaryColor)),
                        FutureBuilder(
                          future: firestoreService.getVenueByVenueID(event.venueID!),
                          builder: (context, snapshot) {
                            return Text(snapshot.hasData ? Venue.fromDocument(snapshot.data as Map<String,Object>).venueName! : '', style: TextStyle(color: primaryColor));
                          },
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey),
                    Text('Contact person - '),
                    UserTile(userID: senderUserID),
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
