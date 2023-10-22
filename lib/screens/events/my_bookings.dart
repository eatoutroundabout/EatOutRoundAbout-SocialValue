import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/book_table_model.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/book_table_item.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class MyBookings extends StatefulWidget {
  @override
  _MyBookingsState createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'MY BOOKINGS'),
          Expanded(
            child: showPage(),
          ),
        ],
      ),
    );
  }

  List<BookTableModel> allEvents = [];

  showPage() {
    return PaginateFirestore(
      key: GlobalKey(),
      padding: const EdgeInsets.only(bottom: 25),
      itemBuilderType: PaginateBuilderType.listView,
      itemBuilder: (context, documentSnapshot, i) {
        BookTableModel event = documentSnapshot[i].data() as BookTableModel;
        allEvents.add(event);

        return FutureBuilder(
          builder: (context, AsyncSnapshot<DocumentSnapshot<Venue>> snapshot) {
            if (snapshot.hasData) {
              Venue venue = snapshot.data!.data() as Venue;
              return BookTableItem(venue: venue, event: event);
            } else
              return Container();
          },
          future: firestoreService.getVenueByVenueID(event.venueID!),
        );
      },
      query: firestoreService.getMyBookings(),
      onEmpty: EmptyBox(text: 'No bookings to show'),
      itemsPerPage: 10,
      bottomLoader: LoadingData(),
      initialLoader: LoadingData(),
    );
  }
}
