import 'package:eatoutroundabout/models/book_table_model.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/screens/venues/view_venue.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookTableItem extends StatelessWidget {
  final Venue? venue;
  final BookTableModel? event;

  BookTableItem({this.venue, this.event});

  final miscService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => ViewVenue(venueID: venue!.venueID)),
      child: Container(
        height: 325,
        decoration: BoxDecoration(
          color: redColor,
          borderRadius: BorderRadius.circular(padding / 2),
        ),
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(padding / 2), topRight: Radius.circular(padding / 2)),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(padding / 2), topRight: Radius.circular(padding / 2)),
                      child: CachedImage(url: venue!.coverURL, height: double.infinity, roundedCorners: false),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CachedImage(url: venue!.logo, height: 50, roundedCorners: true),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(padding / 2), bottomRight: Radius.circular(padding / 2)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(child: Text(venue!.venueName!, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold))),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: orangeColor,
                        ),
                        child: Text(venue!.averageRating!.toStringAsFixed(1) + ' ★', textScaleFactor: 0.75, style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  Text(venue!.streetAddress!, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey)),
                  Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(DateFormat().format(event!.startTime!.toDate())),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                        child: Row(
                          children: [
                            Icon(Icons.group, size: 20),
                            SizedBox(width: 3),
                            Text(event!.noAttendees.toString(), textScaleFactor: 0.9),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text('Booking ' + getStatus(event!.confirmed!), style: TextStyle(color: getColor(event!.confirmed!))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getStatus(bool status) {
    if (status == null) return 'Requested';
    if (status) return 'Accepted';
    if (!status) return 'Rejected';
  }

  getColor(bool status) {
    if (status == null) return Colors.amber.shade700;
    if (status) return Colors.green;
    if (!status) return Colors.red;
  }
}
