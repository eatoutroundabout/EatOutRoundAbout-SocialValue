import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/models/event_model.dart';
import 'package:eatoutroundabout/screens/admin/event/add_event.dart';
import 'package:eatoutroundabout/screens/auth/section_splash.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/event_item.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class EventDashboard extends StatelessWidget {
  final BusinessProfile? businessProfile;

  EventDashboard({this.businessProfile});

  final userController = Get.find<UserController>();
  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15)),
      body: Column(
        children: [
          Heading(title: 'MY EVENTS'),
          Expanded(
            child: Container(
              color: appBackground,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: CustomButton(
                      color: greenColor,
                      text: 'Add a new Event',
                      function: () => Get.to(
                        () => SectionSplash(
                          title: 'Purchase Event Vouchers',
                          description: 'Promote your event to local businesses and add Eat Out vouchers to reward attendance and allow your guests to check-in, network on the app and get a free voucher!',
                          image: 'assets/images/events.png',
                          function: () => Get.off(() => AddEvent(businessProfile: businessProfile)),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PaginateFirestore(
                      isLive: true,
                      shrinkWrap: true,
                      itemBuilderType: PaginateBuilderType.listView,
                      itemBuilder: (context, documentSnapshot, i) {
                        Event event = documentSnapshot[i]!.data() as Event;
                        return EventItem(event: event, isMyEvent: true);
                      },
                      query: firestoreService.getMyEvents(),
                      onEmpty: Padding(
                        padding: EdgeInsets.only(bottom: Get.height / 2 - 200, left: 25, right: 25),
                        child: Text(
                          'Promote your event to local businesses and add Eat Out vouchers to reward attendance and allow your guests to check-in, network on the app and get a free voucher!',
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.15,
                        ),
                      ),
                      itemsPerPage: 10,
                      bottomLoader: LoadingData(),
                      initialLoader: LoadingData(),
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
}
