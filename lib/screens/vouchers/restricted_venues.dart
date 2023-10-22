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

class RestrictedVenues extends StatelessWidget {
  final String? name;
  final String? value;

  RestrictedVenues({this.name, this.value});
  final firestoreService = Get.find<FirestoreService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greenColor,
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: venues(),
    );
  }

  venues() {
    return Column(
      children: [
        Heading(title: 'VENUES'),
        Expanded(
          child: PaginateFirestore(
            key: GlobalKey(),
            padding: const EdgeInsets.only(top: 15, bottom: 25),
            itemBuilderType: PaginateBuilderType.listView,
            itemBuilder: (context, documentSnapshot, i) {
              Venue venue = documentSnapshot[i].data() as Venue;
              return VenueItem(venue: venue, isMyVenue: false);
            },
            query: firestoreService.getRestrictedVenues(name!, value!),
            onEmpty: EmptyBox(text: 'No venues to show'),
            itemsPerPage: 10,
            bottomLoader: LoadingData(),
            initialLoader: LoadingData(),
          ),
        ),
      ],
    );
  }
}
