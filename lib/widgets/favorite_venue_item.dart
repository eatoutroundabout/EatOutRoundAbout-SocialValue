import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/screens/venues/view_venue.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoriteVenueItem extends StatelessWidget {
  final Venue? venue;

  FavoriteVenueItem({this.venue});

  final miscService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return venue!.approved!
        ? Container()
        : GestureDetector(
            onTap: () => Get.to(() => ViewVenue(venueID: venue!.venueID)),
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.7,
              margin: const EdgeInsets.only(right: 15),
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
                            child: CachedImage(url: venue!.coverURL, height: MediaQuery.of(context).size.width * 0.7, roundedCorners: false),
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
                    padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(padding / 2), bottomRight: Radius.circular(padding / 2)),
                      color: appBackground,
                    ),
                    child: Row(
                      children: [
                        Image.asset(miscService.getPinColor(venue!.venueImpactStatus!), height: 30, width: 40),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: [
                                  Expanded(child: Text(venue!.venueName!, textScaleFactor: 0.9, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold))),
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
                              Text(venue!.streetAddress!, textScaleFactor: 0.85, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: greenColor)),
                            ],
                          ),
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
