import 'package:eatoutroundabout/models/event_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/event_item.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ShowEvents extends StatefulWidget {
  @override
  State<ShowEvents> createState() => _ShowEventsState();
}

class _ShowEventsState extends State<ShowEvents> {
  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return PaginateFirestore(
      itemBuilderType: PaginateBuilderType.listView,
      itemBuilder: (context, documentSnapshot, i) {
        Event event = documentSnapshot[i].data() as Event;
        return EventItem(event: event);
      },
      isLive: true,
      query: firestoreService.getEvents(),
      onEmpty: EmptyBox(text: 'No events to show'),
      itemsPerPage: 10,
      bottomLoader: LoadingData(),
      initialLoader: LoadingData(),
    );
  }
}
