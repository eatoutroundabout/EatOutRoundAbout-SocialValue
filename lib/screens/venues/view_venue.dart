import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/book_table_model.dart';
import 'package:eatoutroundabout/models/product_model.dart';
import 'package:eatoutroundabout/models/review_model.dart';
import 'package:eatoutroundabout/models/users_model.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/screens/buy/buy_greetings.dart';
import 'package:eatoutroundabout/screens/events/book_table.dart';
import 'package:eatoutroundabout/screens/venues/venue_products.dart';
import 'package:eatoutroundabout/screens/venues/venue_reviews.dart';
import 'package:eatoutroundabout/screens/vouchers/my_vouchers.dart';
import 'package:eatoutroundabout/services/buy_service.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:eatoutroundabout/widgets/product_item.dart';
import 'package:eatoutroundabout/widgets/saved_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
//import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:uuid/uuid.dart';

class ViewVenue extends StatefulWidget {
  final String? venueID;

  ViewVenue({this.venueID});

  @override
  _ViewVenueState createState() => _ViewVenueState();
}

class _ViewVenueState extends State<ViewVenue> {
  bool isLoading = true;
  Completer<GoogleMapController> controller = Completer();
  static LatLng? center;
  LatLng? lastMapPosition;
  Set<Marker> markers = new Set();
  Venue? venue;
  Uint8List? markerIcon;
  bool enableRating = false;
  final firestoreService = Get.find<FirestoreService>();
  final utilService = Get.find<UtilService>();
  final buyService = Get.find<BuyService>();
  final eventsService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();

  TextEditingController toTEC = TextEditingController();
  TextEditingController fromTEC = TextEditingController();
  TextEditingController displayMessageTEC = TextEditingController();
  String selectedCard = '';

  List<BookTableModel> allEvents = [];
  List<User> allConnections = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    DocumentSnapshot doc = await firestoreService.getVenueByVenueID(widget.venueID!);
    venue = doc.data() as Venue;
    String pin = utilService.getPinColor(venue!.venueImpactStatus!);
    markerIcon = await utilService.getBytesFromAsset(pin, 75);
    await getLocation();
    QuerySnapshot querySnapshot = await firestoreService.getMyReviewForVenue(venue!.venueID!);
    if (querySnapshot.docs.isEmpty) enableRating = true;
    setState(() {
      isLoading = false;
    });
  }

  getLocation() async {
    DocumentSnapshot documentSnapshot = await firestoreService.getVenueCoordinates(venue!.postCode!);
    print('*********LATITUDE');
    //print(documentSnapshot.data()['lat']);
    if (documentSnapshot.exists)
      center = LatLng(documentSnapshot['lat'], documentSnapshot['long']);
    else
      center = LatLng(51.509865, -0.118092); //London Coordinates

    markers.add(Marker(
      markerId: MarkerId(venue!.venueID!),
      position: center!,
      icon: BitmapDescriptor.fromBytes(markerIcon!),
    ));
  }

  void _onCameraMove(CameraPosition position) {
    lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller1) {
    controller.complete(controller1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15),
        backgroundColor: primaryColor,
        actions: [
          SavedButton(venueID: widget.venueID),
        ],
      ),
      body: isLoading
          ? LoadingData()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Heading(title: 'VENUE DETAILS'),
                Expanded(
                  child: buildPackages(),
                ),
              ],
            ),
    );
  }

  buildPackages() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .25,
            width: double.infinity,
            child: GoogleMap(
              myLocationEnabled: false,
              mapToolbarEnabled: true,
              onMapCreated: _onMapCreated,
              markers: markers,
              onCameraMove: _onCameraMove,
              initialCameraPosition: CameraPosition(
                target: center!,
                zoom: 14.0,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .06,
            width: double.infinity,
            color: Colors.teal,
            child: Center(
                child: Text(
              venue!.streetAddress! + ", " + venue!.townCity! + "," + venue!.postCode!.toUpperCase(),
              textScaleFactor: 1,
              style: TextStyle(color: Colors.white70),
            )),
          ),
          Container(
            padding: const EdgeInsets.all(padding),
            alignment: Alignment.center,
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                CachedImage(
                  roundedCorners: true,
                  circular: false,
                  height: 120,
                  url: venue!.logo,
                ),
                Padding(
                  padding: const EdgeInsets.all(padding),
                  child: Text(venue!.venueName!, textScaleFactor: 1.5, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: orangeColor,
                  ),
                  child: Text(venue!.averageRating!.toStringAsFixed(1) + ' ★', textScaleFactor: 0.75, style: TextStyle(color: Colors.white)),
                ),
                Text('(${venue!.totalRatingsCount.toString()} reviews)', textScaleFactor: 0.9),
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.all(padding),
              height: MediaQuery.of(context).size.height * .35,
              child: Swiper(
                //scrollDirection: Axis.vertical,
                loop: false,
                itemBuilder: (context, i) {
                  return CachedImage(
                    roundedCorners: true,
                    height: double.infinity,
                    url: venue!.images![i],
                  );
                },
                itemCount: venue!.images!.length,
                pagination: new SwiperPagination(builder: SwiperCustomPagination(builder: (BuildContext context, SwiperPluginConfig config) {
                  return SingleChildScrollView(scrollDirection: Axis.horizontal, child: DotSwiperPaginationBuilder(color: lightGreenColor, activeColor: primaryColor, size: 10.0, activeSize: 15.0).build(context, config));
                })),
              )),
          Padding(
            padding: const EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: padding / 2),
                  child: Text(venue!.venueDescription!, textScaleFactor: 1, textAlign: TextAlign.justify, style: TextStyle(color: Color.fromRGBO(8, 76, 97, 0.6), fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 25),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        onTap: () => openLink(venue!.website!),
                        leading: Icon(Icons.link, color: Colors.teal.shade400),
                        trailing: Icon(Icons.keyboard_arrow_right_rounded),
                        title: Text('Website', textScaleFactor: 1, style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                      ),
                      if (venue!.venueBookingLink != null && venue!.venueBookingLink != '')
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          onTap: () => openLink(venue!.venueBookingLink!),
                          leading: Icon(FontAwesomeIcons.utensils, color: Colors.teal.shade400, size: 15),
                          trailing: Icon(Icons.keyboard_arrow_right_rounded),
                          title: Text('Booking Link', textScaleFactor: 1, style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                        ),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        onTap: () => openLink('tel:${venue!.venuePhoneNumber}'),
                        leading: Icon(Icons.local_phone, color: Colors.teal.shade400),
                        trailing: Icon(Icons.keyboard_arrow_right_rounded),
                        title: Text('Telephone', textScaleFactor: 1, style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                      ),
                      if (venue!.acceptTableBooking!)
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          onTap: () => Get.to(() => BookTable(venue: venue!)),
                          leading: Icon(Icons.book_online_rounded, color: redColor),
                          trailing: Icon(Icons.keyboard_arrow_right_rounded, color: redColor),
                          title: Text('Book a Table', textScaleFactor: 1, style: TextStyle(color: redColor, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Food Types', style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                        SizedBox(height: 15),
                        Text(venue!.foodTypes!.join(", ")),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Opening Hours', style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                        SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text('DAY', textScaleFactor: 1, style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(child: Center(child: Text('TIMING', textScaleFactor: 1, style: TextStyle(fontWeight: FontWeight.bold)))),
                              Expanded(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('VOUCHER', textScaleFactor: 1, style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              )),
                            ],
                          ),
                        ),
                        Divider(),
                        day('Monday', '${venue!.monday!.open!.toStringAsFixed(2)} - ${venue!.monday!.close!.toStringAsFixed(2)}', venue!.monday!.accept!),
                        Divider(),
                        day('Tuesday', '${venue!.tuesday!.open!.toStringAsFixed(2)} - ${venue!.tuesday!.close!.toStringAsFixed(2)}', venue!.tuesday!.accept!),
                        Divider(),
                        day('Wednesday', '${venue!.wednesday!.open!.toStringAsFixed(2)} - ${venue!.wednesday!.close!.toStringAsFixed(2)}', venue!.wednesday!.accept!),
                        Divider(),
                        day('Thursday', '${venue!.thursday!.open!.toStringAsFixed(2)} - ${venue!.thursday!.close!.toStringAsFixed(2)}', venue!.thursday!.accept!),
                        Divider(),
                        day('Friday', '${venue!.friday!.open!.toStringAsFixed(2)} - ${venue!.friday!.close!.toStringAsFixed(2)}', venue!.friday!.accept!),
                        Divider(),
                        day('Saturday', '${venue!.saturday!.open!.toStringAsFixed(2)} - ${venue!.saturday!.close!.toStringAsFixed(2)}', venue!.saturday!.accept!),
                        Divider(),
                        day('Sunday', '${venue!.sunday!.open!.toStringAsFixed(2)} - ${venue!.sunday!.close!.toStringAsFixed(2)}', venue!.sunday!.accept!),
                      ],
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: firestoreService.getProducts(venue!.venueID!, 5),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(padding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Local Products available', style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                                  InkWell(
                                    onTap: () => Get.to(() => VenueProducts(venue: venue!)),
                                    child: Text('See All >', style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, i) {
                                  DocumentSnapshot doc = snapshot.data!.docs[i];
                                  Product product = doc.data() as Product;
                                  return ProductItem(product: product);
                                },
                                itemCount: snapshot.data!.docs.length,
                                shrinkWrap: true,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else
                      return Container();
                  },
                ),
                StreamBuilder(
                  stream: firestoreService.getReviewsForVenue(venue!.venueID!, 5),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(padding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Reviews', style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                                  InkWell(
                                    onTap: () => Get.to(() => VenueReviews(venue: venue!)),
                                    child: Text('See All >', style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              ListView.builder(
                                itemBuilder: (context, i) {
                                  DocumentSnapshot doc = snapshot.data!.docs[i];
                                  Review review = doc.data() as Review;
                                  return Column(
                                    children: [
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 15, 8, 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SmoothStarRating(
                                                size: 15,
                                                color: orangeColor,
                                               // isReadOnly: true,
                                                borderColor: orangeColor,
                                                starCount: 5,
                                                rating: review.rating!.toDouble(),
                                              ),
                                              Text(
                                                DateFormat('dd MMM yyyy').format(review.creationDate!.toDate()),
                                                textScaleFactor: 0.8,
                                                style: TextStyle(color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                                              child: Text(review.comment!, style: TextStyle(color: Color.fromRGBO(8, 76, 97, 0.6))),
                                            ),
                                            GestureDetector(
                                              onTap: () => showGreenAlert('Reported comment'),
                                              child: Text('Report', style: TextStyle(color: Colors.grey), textScaleFactor: 0.9),
                                            ),
                                            SizedBox(height: 8),
                                          ],
                                        ),
                                      ),
                                      Divider(height: 1),
                                    ],
                                  );
                                },
                                itemCount: snapshot.data!.docs.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else
                      return Container();
                  },
                ),
                CustomButton(
                  color: enableRating ? primaryColor : Colors.grey,
                  text: enableRating ? 'Rate this Place' : 'Already rated this place',
                  function: () {
                    if (enableRating)
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return RatingDialog(
                              starColor: orangeColor,
                              starSize: 35,
                              image: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CachedImage(roundedCorners: true, circular: false, height: 75, url: venue!.logo),
                                ],
                              ),
                              title: Text("Rate ${venue!.venueName}", textAlign: TextAlign.center),
                              initialRating: 0,
                              force: true,
                              message: Text("Tap a star to set your rating and press submit", textAlign: TextAlign.center, textScaleFactor: 0.8, style: TextStyle(color: Colors.grey)),
                              commentHint: 'Tell us what you think...',
                              submitButtonText: "SUBMIT",
                              onSubmitted: (response) async {
                                if (response.comment.isNotEmpty && response.rating > 0) {
                                  Get.back();

                                  await cloudFunction(
                                      functionName: 'addReview',
                                      parameters: {
                                        'userID': userController.currentUser.value.userID,
                                        'flagged': false,
                                        'comment': response.comment,
                                        'rating': response.rating.toDouble(),
                                        'reviewID': Uuid().v1(),
                                        'venueID': venue!.venueID,
                                      },
                                      action: () {
                                        setState(() {
                                          enableRating = false;
                                        });
                                      });
                                } else
                                  showRedAlert('Please tap a star and enter a comment');
                              },
                              //onAlternativePressed: () => openLink('tel:${venue.venuePhoneNumber}'),
                            );
                          });
                  },
                ),
                SizedBox(height: 25),
                if (venue!.paused!)
                  ListTile(
                    leading: Icon(Icons.qr_code, color: redColor),
                    horizontalTitleGap: 0,
                    title: Text('* This venue is not accepting vouchers currently', style: TextStyle(color: redColor, fontWeight: FontWeight.bold)),
                  ),
                if (venue!.dogFriendly!)
                  ListTile(
                    leading: Icon(FontAwesomeIcons.dog, color: Colors.grey.shade800),
                    horizontalTitleGap: 0,
                    title: Text('* This venue is dog friendly'),
                  ),
                if (venue!.preTheatreDining!)
                  ListTile(
                    leading: Icon(Icons.dining_outlined, color: Colors.grey.shade800),
                    horizontalTitleGap: 0,
                    title: Text('* This venue offers Pre-Theatre Dining'),
                  ),
                if (venue!.wheelChairAccess!)
                  ListTile(
                    leading: Icon(Icons.wheelchair_pickup_rounded, color: Colors.grey.shade800),
                    horizontalTitleGap: 0,
                    title: Text('* This venue offers Wheelchair Access'),
                  ),
                // sendGreetingButton(venue.venueName),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 10),
                  child: Text('Our Safety Policy', style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold), textScaleFactor: 1),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 20),
                  child: Text('We partner only with eateries following current government Covid safety guidance.', textScaleFactor: 1, style: TextStyle(color: Colors.grey.shade600)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(FontAwesomeIcons.facebookF),
                      color: venue!.facebook!.isNotEmpty ? Colors.indigo : Colors.grey,
                      onPressed: () => venue!.facebook!.isNotEmpty ? openLink(venue!.facebook!) : null,
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.instagram),
                      color: venue!.instagram!.isNotEmpty ? Colors.pinkAccent : Colors.grey,
                      onPressed: () => venue!.instagram!.isNotEmpty ? openLink(venue!.instagram!) : null,
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.twitter),
                      color: venue!.twitter!.isNotEmpty ? Colors.lightBlueAccent : Colors.grey,
                      onPressed: () => venue!.twitter!.isNotEmpty ? openLink(venue!.twitter!) : null,
                    ),
                    IconButton(
                      icon: Icon(FontAwesomeIcons.linkedinIn),
                      color: venue!.linkedin!.isNotEmpty ? Colors.blueAccent : Colors.grey,
                      onPressed: () => venue!.linkedin!.isNotEmpty ? openLink(venue!.linkedin!) : null,
                    ),
                  ],
                ),
                SizedBox(height: 15),
              ],
            ),
          )
        ],
      ),
    );
  }

  day(String day, String time, bool accept) {
    if (time.contains("-1")) accept = false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(day, textScaleFactor: 1, style: TextStyle(color: Color.fromRGBO(8, 76, 97, 0.8), fontWeight: FontWeight.normal))),
          Expanded(child: Center(child: Text(time.contains("-1") ? 'Closed' : time, textScaleFactor: 1, style: TextStyle(color: Color.fromRGBO(8, 76, 97, 0.8), fontWeight: FontWeight.normal)))),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    onTap: () {
                      if (accept) Get.to(() => MyVouchers(showAppBar: true));
                    },
                    child: Icon(accept ? Icons.qr_code : Icons.close, color: accept ? orangeColor : Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  openLink(String link) async {
    if (!link.startsWith('tel')) link = link.startsWith('http') ? link : 'https://' + link;
    utilService.openLink(link);
  }

  sendGreetingButton(String venueName) {
    return InkWell(
      onTap: () => Get.to(BuyGreetings(venueID: widget.venueID!, venueLogo: venue!.logo)),
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: redColor,
          borderRadius: BorderRadius.circular(padding / 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Voucher', textScaleFactor: 1.5, style: TextStyle(color: Colors.white)),
                  SizedBox(height: 5),
                  Text('Send a ${venue!.venueName} voucher to a friend to save 50% up to £10 on their next meal out.', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            Column(
              children: [
                Icon(Icons.arrow_forward, color: Colors.white, size: 30),
              ],
            )
          ],
        ),
      ),
    );
  }
}
