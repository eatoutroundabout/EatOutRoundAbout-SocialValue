import 'package:eatoutroundabout/models/event_model.dart';
import 'package:eatoutroundabout/screens/admin/event/edit_event.dart';
import 'package:eatoutroundabout/screens/admin/event/view_event_code.dart';
import 'package:eatoutroundabout/screens/events/view_event.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatelessWidget {
  final Event? event;

  EventDetails({this.event});

  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            color: Colors.white,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(event!.eventTitle!, textScaleFactor: 1.25, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text(DateFormat('dd MMM yyyy, hh:mm aa').format(event!.eventDateTimeFrom!.toDate()), textScaleFactor: 1, style: TextStyle(color: greenColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Divider(height: 1),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(padding * 2, padding * 2, padding * 2, 0),
              color: appBackground,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomButton(
                      color: primaryColor,
                      text: 'View Event Code',
                      function: () => Get.to(() => ViewEventCode(event: event!)),
                    ),
                    SizedBox(height: padding),
                    CustomButton(
                      color: primaryColor,
                      text: 'View Event Details',
                      function: () => Get.to(() => ViewEvent(event: event)),
                    ),
                    SizedBox(height: padding),
                    CustomButton(
                      color: primaryColor,
                      text: 'Edit Event',
                      function: () => Get.to(() => EditEvent(event: event)),
                    ),
                    SizedBox(height: padding),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
