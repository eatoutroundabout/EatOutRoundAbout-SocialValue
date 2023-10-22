import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/event_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/event_item.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class MyEvents extends StatefulWidget {
  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
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
            child: PaginateFirestore(
              itemBuilderType: PaginateBuilderType.listView,
              itemBuilder: (context, documentSnapshot, i) {
                Event event = documentSnapshot[i].data() as Event;
                return EventItem(event: event);
              },
              isLive: true,
              query: firestoreService.getMyAttendingEvents(),
              onEmpty: EmptyBox(text: 'No events to show'),
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
