import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/notification_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/venue_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class BookTable extends StatelessWidget {
  final Venue? venue;

  BookTable({this.venue});

  final Rx<TextEditingController> dateTimeTEC = TextEditingController().obs;
  final TextEditingController noAttendeesTEC = TextEditingController();
  final userController = Get.find<UserController>();
  final notificationService = Get.find<NotificationService>();
  num dateTime = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Heading(title: 'BOOK A TABLE'),
            IgnorePointer(ignoring: true, child: VenueItem(venue: venue, isMyVenue: false)),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Confirm Details', textScaleFactor: 1.25, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                  CustomTextField(
                    controller: noAttendeesTEC,
                    label: 'No. of Attendees',
                    hint: 'Enter count',
                    textInputType: TextInputType.numberWithOptions(signed: false, decimal: false),
                  ),
                  Obx(
                    () => InkWell(
                      onTap: () {
                        DatePicker.showDateTimePicker(context, showTitleActions: true, minTime: DateTime.now(), maxTime: DateTime(2100), onChanged: (date) {}, onConfirm: (date) {
                          dateTimeTEC.value.text = DateFormat().format(date);
                          dateTime = date.millisecondsSinceEpoch;
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: CustomTextField(
                        hint: 'Select date and time',
                        label: 'Select date and time',
                        enabled: false,
                        controller: dateTimeTEC.value,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: 'Send Booking Request',
                    function: () async {
                      if (noAttendeesTEC.text.isEmpty || dateTimeTEC.value.text.isEmpty) {
                        showRedAlert('Please fill in all the details');
                        return;
                      }
                      String eventID = Uuid().v1();
                      await cloudFunction(
                          functionName: 'createBooking',
                          parameters: {
                            'userID': userController.currentUser.value.userID,
                            'eventID': eventID,
                            'venueID': venue!.venueID,
                            'noAttendees': noAttendeesTEC.text,
                            'startTime': dateTime,
                            'confirmed': null,
                          },
                          action: () => Get.back());
                      await notificationService.sendNotification(
                        parameters: {
                          'eventID': eventID,
                        },
                        receiverUserID: venue!.receptionist![0],
                        type: 'tableBookingRequest',
                        body: 'You have a new table booking request',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
