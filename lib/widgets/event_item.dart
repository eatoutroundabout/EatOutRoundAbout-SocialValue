import 'package:eatoutroundabout/models/event_model.dart';
import 'package:eatoutroundabout/screens/admin/event/event_details.dart';
import 'package:eatoutroundabout/screens/events/view_event.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EventItem extends StatelessWidget {
  final Event? event;
  final bool? isMyEvent;

  EventItem({this.event, this.isMyEvent});

  final miscService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => isMyEvent ?? false ? EventDetails(event: event!) : ViewEvent(event: event!)),
      child: Container(
        height: 375,
        decoration: BoxDecoration(
          color: redColor,
          borderRadius: BorderRadius.circular(padding / 2),
        ),
        margin: const EdgeInsets.fromLTRB(padding, 0, padding, padding),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(padding / 2), topRight: Radius.circular(padding / 2)),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(padding / 2), topRight: Radius.circular(padding / 2)),
                  child: CachedImage(url: event!.eventImages![0], height: double.infinity, roundedCorners: false),
                ),
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
                  Text(event!.eventTitle!, style: TextStyle(color: greenColor, fontWeight: FontWeight.bold)),
                  Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(DateFormat('dd MMM yyyy, hh:mm aa').format(event!.eventDateTimeFrom!.toDate())),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                        child: Row(
                          children: [
                            Icon(Icons.group, size: 20),
                            SizedBox(width: 3),
                            Text(event!.capacity.toString(), textScaleFactor: 0.9),
                          ],
                        ),
                      ),
                    ],
                  ),
                  //Text('Booking ' + getStatus(event.confirmed), style: TextStyle(color: getColor(event.confirmed))),
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
