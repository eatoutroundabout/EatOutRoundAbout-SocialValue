import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:eatoutroundabout/widgets/venue_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class FestivalVenues extends StatelessWidget {
  final String? postCode;

  FestivalVenues({this.postCode});

  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'WHERE TO EAT OUT?'),
          Expanded(
            child: showVenuesList(),
          ),
        ],
      ),
    );
  }

  showVenuesList() {
    return FutureBuilder(
      future: getQuery(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return PaginateFirestore(
            key: GlobalKey(),
            padding: const EdgeInsets.only(bottom: 25, top: 15),
            itemBuilderType: PaginateBuilderType.listView,
            itemBuilder: (context, documentSnapshot, i) {
              Venue venue = documentSnapshot[i].data() as Venue;
              return VenueItem(venue: venue, isMyVenue: false);
            },
            query: snapshot.data as Query,
            onEmpty: EmptyBox(text: 'No venues to show'),
            itemsPerPage: 10,
            bottomLoader: LoadingData(),
            initialLoader: LoadingData(),
          );
        } else
          return LoadingData();
      },
    );
  }

  getQuery() async {
    String laua = await firestoreService.getLAUAForPostcode(postCode!);
    return firestoreService.getLocalImpactVenues(laua);
  }
}
