import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/event_model.dart';
import 'package:eatoutroundabout/screens/events/view_users.dart';
import 'package:eatoutroundabout/screens/home/festival_venues.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/attend_button.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/check_in_button.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_list_tile.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
//import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ViewEvent extends StatelessWidget {
  final Event? event;

  ViewEvent({this.event});

  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'EVENT DETAILS'),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(padding),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * .35,
                          child: Swiper(
                            //scrollDirection: Axis.vertical,
                            loop: false,
                            itemBuilder: (context, i) {
                              return CachedImage(
                                roundedCorners: true,
                                height: double.infinity,
                                url: event!.eventImages![i],
                              );
                            },
                            itemCount: event!.eventImages!.length,
                            pagination: new SwiperPagination(builder: SwiperCustomPagination(builder: (BuildContext context, SwiperPluginConfig config) {
                              return SingleChildScrollView(scrollDirection: Axis.horizontal, child: DotSwiperPaginationBuilder(color: lightGreenColor, activeColor: primaryColor, size: 10.0, activeSize: 15.0).build(context, config));
                            })),
                          ),
                        ),
                        SizedBox(height: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(padding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(DateFormat('dd MMM yyyy, hh:mm aa').format(event!.eventDateTimeFrom!.toDate()).toString(), style: TextStyle(color: redColor)),
                                    SizedBox(height: 10),
                                    Text(event!.eventTitle!, textScaleFactor: 1.1, style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10),
                                    if (event!.pricePerHead! > 0)
                                      Container(
                                        color: lightGreenColor,
                                        padding: const EdgeInsets.all(5),
                                        margin: const EdgeInsets.only(bottom: 5),
                                        child: Text('£' + event!.pricePerHead.toString() + ' per head', textScaleFactor: 1.5),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            if (event!.eventType == 'festival')
                              CustomListTile(
                                onTap: () => Get.to(() => FestivalVenues(postCode: event!.postCode)),
                                leading: Icon(Icons.restaurant, color: primaryColor),
                                title: Text('Where to eat out?'),
                                trailing: Icon(Icons.keyboard_arrow_right_rounded),
                              ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(padding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Summary', style: TextStyle(fontWeight: FontWeight.bold, color: greenColor)),
                                    SizedBox(height: 10),
                                    Text(event!.summary!, textAlign: TextAlign.justify),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(padding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Description', style: TextStyle(fontWeight: FontWeight.bold, color: greenColor)),
                                    SizedBox(height: 10),
                                    Text(event!.description!, textAlign: TextAlign.justify),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(padding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      onTap: () => Get.to(() => ViewUsers(users: event!.checkedInUserIDs, title: 'Checked-In')),
                                      leading: Icon(Icons.group_outlined, color: Colors.grey.shade800),
                                      title: event!.checkedInUserIDs!.isNotEmpty! ? Text(event!.checkedInUserIDs!.length.toString() + ' people have checked-in') : Text('No one has checked-in yet'),
                                      trailing: Icon(Icons.keyboard_arrow_right),
                                    ),
                                    ListTile(
                                      onTap: () => Get.to(() => ViewUsers(users: event!.attendeeUserIDs, title: 'Attendees')),
                                      leading: Icon(Icons.group_outlined, color: Colors.grey.shade800),
                                      title: event!.attendeeUserIDs!.isNotEmpty ? Text(event!.attendeeUserIDs!.length.toString() + ' people are attending') : Text('No one is attending yet'),
                                      trailing: Icon(Icons.keyboard_arrow_right),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            if (event!.bookingLink != '') Expanded(child: CustomButton(function: () => openLink(event!.bookingLink!), text: 'Book', color: greenColor)),
                            if (event!.bookingLink != '') SizedBox(width: padding / 2),
                            Expanded(child: AttendButton(eventID: event!.eventID)),
                            SizedBox(width: padding / 2),
                            Expanded(child: CheckInButton(eventID: event!.eventID)),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  openLink(String link) async {
    if (!link.startsWith('tel')) link = link.startsWith('http') ? link : 'https://' + link;
    utilService.openLink(link);
  }
}
