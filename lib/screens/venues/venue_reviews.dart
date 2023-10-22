import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/review_model.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class VenueReviews extends StatefulWidget {
  final Venue? venue;

  VenueReviews({this.venue});

  @override
  _VenueReviewsState createState() => _VenueReviewsState();
}

class _VenueReviewsState extends State<VenueReviews> {
  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(widget.venue.venueName, textScaleFactor: 2, style: TextStyle(color: orangeColor, fontWeight: FontWeight.bold)),
              Container(
                height: MediaQuery.of(context).size.height * .06,
                width: double.infinity,
                color: Colors.teal,
                child: Center(
                    child: Text(
                  widget.venue!.streetAddress! + ", " + widget.venue!.townCity! + "," + widget.venue!.postCode!.toUpperCase(),
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
                      roundedCorners: false,
                      circular: true,
                      height: 120,
                      url: widget.venue!.logo,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(padding),
                      child: Text(widget.venue!.venueName!, textScaleFactor: 1.5, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SmoothStarRating(
                        //  onRated: (v) {},
                          starCount: 5,
                          rating: widget.venue!.averageRating!.toDouble(),
                          size: 15.0,
                       //   isReadOnly: true,
                          color: orangeColor,
                          borderColor: orangeColor,
                          spacing: 7.0,
                        ),
                        // SizedBox(width: 15),
                        // Text('(${venue.totalRatingsCount.toString()})', textScaleFactor: 0.9),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: padding * 2, bottom: padding),
            child: Text('All Reviews'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(padding),
              child: StreamBuilder(
                stream: firestoreService.getReviewsForVenue(widget.venue!.venueID!, 5000),
                builder: (context, AsyncSnapshot<QuerySnapshot<Review>> snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    print(snapshot.data!.docs.length);
                    return ListView.builder(
                      itemBuilder: (context, i) {
                        DocumentSnapshot doc = snapshot.data!.docs[i];
                        Review review = doc.data() as Review;
                        return Card(
                          child: ListTile(
                            // contentPadding: EdgeInsets.zero,
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
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
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                    );
                  } else
                    return Container();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
