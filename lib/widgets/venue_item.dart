import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/screens/admin/venue/venue_details.dart';
import 'package:eatoutroundabout/screens/venues/view_venue.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VenueItem extends StatelessWidget {
  final Venue? venue;
  final bool? isMyVenue;

  VenueItem({this.venue, this.isMyVenue});

  final miscService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isMyVenue!
          ? venue!.approved!
              ? Get.to(() => VenueDetails(venue: venue!))
              : Get.defaultDialog(
                  radius: padding / 2,
                  title: 'Awaiting Approval',
                  content: buildText(
                    'Your venue is not approved yet. \n\nIf you have not heard from us within 48 hours, please contact support@EatOutRoundAbout.co.uk',
                  ),
                  actions: [
                    CustomButton(
                      function: () => Get.back(),
                      text: 'OK',
                      color: primaryColor,
                    ),
                  ],
                )
          : Get.to(() => ViewVenue(venueID: venue!.venueID)),
      child: Container(
        height: Get.width * 0.65,
        margin: const EdgeInsets.fromLTRB(padding, 0, padding, padding),
        decoration: BoxDecoration(
          color: lightGreenColor,
          borderRadius: BorderRadius.circular(padding / 2),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10),
          ],
          image: DecorationImage(
            image: venue!.coverURL == '' ? AssetImage('assets/images/logo.png') as ImageProvider: CachedNetworkImageProvider(venue!.coverURL!),
            fit: venue!.coverURL == '' ? BoxFit.contain : BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: CachedImage(url: venue!.logo, height: 50, roundedCorners: true),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(padding / 2)),
                    color: orangeColor,
                  ),
                  child: Text(venue!.averageRating!.toStringAsFixed(1) + ' ★', textScaleFactor: 0.85, style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(padding / 2), bottomRight: Radius.circular(padding / 2)),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(venue!.venueName!, textScaleFactor: 0.9, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(child: Text(venue!.streetAddress!, textScaleFactor: 0.85, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: greenColor))),
                      buildIcons(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildIcons() {
    return InkWell(
      onTap: () {
        Get.defaultDialog(
          radius: padding / 2,
          title: 'Info',
          content: Column(
            children: [
              infoItem(Icons.pin_drop_outlined, 'Venue Impact Status - ${venue!.venueImpactStatus!.toUpperCase()}', venue!.venueImpactStatus!.toUpperCase() != 'NONE'),
              infoItem(Icons.dining_outlined, 'Pre-Theatre Dining' + (venue!.preTheatreDining! ? ' available' : ' not available'), venue!.preTheatreDining!),
              infoItem(FontAwesomeIcons.dog, 'Dog friendly' + (venue!.dogFriendly! ? ': Yes' : ': No'), venue!.dogFriendly!),
              infoItem(Icons.wheelchair_pickup_rounded, 'Wheelchair Access' + (venue!.wheelChairAccess! ? ' available' : ' not available'), venue!.wheelChairAccess!),
              infoItem(Icons.qr_code, checkIfVouchersAcceptedToday() ? 'Vouchers accepted today' : 'Vouchers not accepted today', checkIfVouchersAcceptedToday()),
              infoItem(Icons.table_restaurant_outlined, 'Table Booking' + (venue!.acceptTableBooking! ? ' available' : ' not available'), venue!.wheelChairAccess!),
            ],
          ),
          cancel: CustomButton(function: () => Get.back(), text: 'OK', color: primaryColor),
        );
      },
      child: Row(
        children: [
          Image.asset(miscService.getPinColor(venue!.venueImpactStatus!), height: 18, width: 18),
          SizedBox(width: 5),
          Icon(Icons.dining_outlined, size: 20, color: venue!.preTheatreDining! ? greenColor : Colors.grey.shade300),
          SizedBox(width: 5),
          Icon(FontAwesomeIcons.dog, size: 20, color: venue!.dogFriendly! ? greenColor : Colors.grey.shade300),
          SizedBox(width: 5),
          Icon(Icons.wheelchair_pickup_rounded, size: 20, color: venue!.wheelChairAccess! ? greenColor : Colors.grey.shade300),
          SizedBox(width: 5),
          Icon(Icons.qr_code, size: 20, color: checkIfVouchersAcceptedToday() ? orangeColor : Colors.grey.shade300),
          SizedBox(width: 5),
          Icon(Icons.table_restaurant_outlined, size: 20, color: venue!.acceptTableBooking! ? greenColor : Colors.grey.shade300),
          SizedBox(width: 5),
          Icon(Icons.info_outline_rounded, color: primaryColor, size: 20),
        ],
      ),
    );
  }

  infoItem(IconData icon, String title, bool val) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: val ? greenColor : Colors.grey.shade400),
          SizedBox(width: 10),
          Text(title, textScaleFactor: 0.95, style: TextStyle(color: val ? greenColor : Colors.grey.shade400)),
        ],
      ),
    );
  }

  checkIfVouchersAcceptedToday() {
    String day = DateFormat('EEEE').format(DateTime.now()).toLowerCase();
    switch (day) {
      case 'monday':
        return venue!.monday!.accept;
      case 'tuesday':
        return venue!.tuesday!.accept;
      case 'wednesday':
        return venue!.wednesday!.accept;
      case 'thursday':
        return venue!.thursday!.accept;
      case 'friday':
        return venue!.friday!.accept;
      case 'saturday':
        return venue!.saturday!.accept;
      case 'sunday':
        return venue!.sunday!.accept;
    }
  }

  buildText(String text) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Linkify(
        text: text,
        onOpen: (link) => miscService.openLink(link.url),
        options: LinkifyOptions(humanize: true),
        linkStyle: TextStyle(color: greenColor),
        style: TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
        textScaleFactor: 1.1,
      ),
    );
  }
}
