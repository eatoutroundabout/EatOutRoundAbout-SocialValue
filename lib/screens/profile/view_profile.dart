import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/connection_model.dart';
import 'package:eatoutroundabout/models/users_model.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/screens/messages/view_image.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/business_profile_tile.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/connect_button.dart';
import 'package:eatoutroundabout/widgets/favorite_venue_item.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:eatoutroundabout/widgets/message_button.dart';
import 'package:eatoutroundabout/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';

class ViewProfile extends StatefulWidget {
  final String? userID;

  ViewProfile({this.userID});

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  final userController = Get.find<UserController>();
  final firestoreService = Get.find<FirestoreService>();

  User? user;
  PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();
  final UniqueKey key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestoreService.getUserStream(widget.userID),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          user = snapshot.data!.data() as User;
          return Scaffold(
            appBar: AppBar(
              title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15),
              actions: [
                Center(
                  child: InkWell(
                    onTap: () => utilService.showReportDialog(widget.userID!),
                    child: Text(
                      'REPORT   ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                Heading(title: widget.userID != userController.currentUser.value.userID ? 'CONNECTION' : 'MY PROFILE'),
                Expanded(
                  child: createHeader(),
                ),
              ],
            ),
          );
        } else
          return Scaffold(
            body: LoadingData(),
          );
      },
    );
  }

  createHeader() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 10, bottom: 20),
            child: InkWell(
              onTap: () {
                if (user!.photoURL != '' && user!.photoURL != null && user!.photoURL != 'profile') Get.to(() => ViewImages(index: 0, images: [user!.photoURL]));
              },
              child: CachedImage(
                url: user!.photoURL,
                height: MediaQuery.of(context).size.width * 0.35,
              ),
            ),
          ),
          Center(
            child: Text(
              user!.firstName! + ' ' + user!.lastName!,
              style: TextStyle(fontWeight: FontWeight.bold),
              textScaleFactor: 1.25,
            ),
          ),
          SizedBox(height: 25),
          if (widget.userID != userController.currentUser.value.userID)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: ConnectButton(userID: widget.userID, showingOnProfile: true)),
                Expanded(child: MessageButton(userID: widget.userID)),
              ],
            ),
          SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bio', style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(user!.userBio!, textAlign: TextAlign.justify, style: TextStyle(color: primaryColor)),
                ],
              ),
            ),
          ),
          if (user!.jobFunction != 'None' || user!.jobTitle != 'None' || user!.jobLevel != 'None')
            Card(
              child: Padding(
                padding: const EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Job Details', style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Title', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                        Text(user!.jobTitle!, style: TextStyle(color: primaryColor)),
                        SizedBox(height: 10),
                        Text('Functions', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                        Text(user!.jobFunction!, style: TextStyle(color: primaryColor)),
                        SizedBox(height: 10),
                        Text('Level', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                        Text(user!.jobLevel!, style: TextStyle(color: primaryColor)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          if (user!.businessProfileAdmin!.isNotEmpty || user!.businessProfileStaff!.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Business Profiles', style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    ListView.builder(itemBuilder: (context, i) => BusinessProfileTile(businessProfileID: user!.businessProfileAdmin![i]), itemCount: user!.businessProfileAdmin!.length, shrinkWrap: true, physics: NeverScrollableScrollPhysics()),
                    ListView.builder(itemBuilder: (context, i) => BusinessProfileTile(businessProfileID: user!.businessProfileStaff![i]), itemCount: user!.businessProfileStaff!.length, shrinkWrap: true, physics: NeverScrollableScrollPhysics()),
                  ],
                ),
              ),
            ),
          StreamBuilder(
            stream: firestoreService.getSavedVenues(widget.userID!),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.docs.isNotEmpty
                    ? Card(
                        color: Colors.grey.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(padding),
                          child: Container(
                            height: 260,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Favorite Places to Eat Out', style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    padding: const EdgeInsets.only(top: 20),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, i) {
                                      return FutureBuilder(
                                        future: firestoreService.getVenueByVenueID(snapshot.data!.docs[i].get('venueID')),
                                        builder: (context, AsyncSnapshot<DocumentSnapshot<Venue>> vesselData) {
                                          if (vesselData.hasData)
                                            return FavoriteVenueItem(venue: vesselData.data!.data());
                                          else
                                            return Container();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container();
              } else
                return LoadingData();
            },
          ),
          FutureBuilder(
            future: firestoreService.getUserConnections(widget.userID!),
            builder: (context, AsyncSnapshot<DocumentSnapshot<Connection>> snapshot) {
              if (snapshot.hasData) {
                Connection connection = snapshot.data!.data() as Connection;
                if (connection != null)
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('People you may know', style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i) {
                              return UserTile(userID: connection.connections![i]);
                            },
                            separatorBuilder: (context, i) {
                              return Divider(height: 1);
                            },
                            itemCount: connection.connections!.length,
                          ),
                        ],
                      ),
                    ),
                  );
                else
                  return Container();
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
