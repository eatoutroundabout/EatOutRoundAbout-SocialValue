import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/account_model.dart';
import 'package:eatoutroundabout/models/post_code_model.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/screens/admin/account/add_account.dart';
import 'package:eatoutroundabout/screens/admin/venue/add_a_venue.dart';
import 'package:eatoutroundabout/screens/home/recommend_venue.dart';
import 'package:eatoutroundabout/screens/home/show_events.dart';
import 'package:eatoutroundabout/screens/venues/view_venue.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/utils/dietary_constants.dart';
import 'package:eatoutroundabout/widgets/color_card.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:eatoutroundabout/widgets/powered_by.dart';
import 'package:eatoutroundabout/widgets/venue_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:paginate_firestore/paginate_firestore.dart';

class ShowVenues extends StatefulWidget {
  @override
  _ShowVenuesState createState() => _ShowVenuesState();
}

class _ShowVenuesState extends State<ShowVenues> {
  Completer<GoogleMapController> controller = Completer();
  static LatLng center = LatLng(myLatitude, myLongitude);
  LatLng? lastMapPosition;
  Set<Marker> markers = new Set();
  RxBool showList = true.obs;
  bool showTipsDialog = false;
  String sortBy = 'lm3ImpactValue';
  String filter = 'home';
  String visit = '';
  TextEditingController promoCodeTEC = TextEditingController();

  final voucherService = Get.find<FirestoreService>();
  final firestoreService = Get.find<FirestoreService>();
  final eventsService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();
  final utilService = Get.find<UtilService>();

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    QuerySnapshot querySnapshot = await firestoreService.getAllVenues();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      Venue venue = querySnapshot.docs[i].data() as Venue;
      allVenues.add(venue);
      DocumentSnapshot doc = await voucherService.getPostCodeData(allVenues[i].postCode!.replaceAll(" ", "").toLowerCase());
      PostCode postCode = doc.data() as PostCode;
      String pin = utilService.getPinColor(venue.venueImpactStatus!);
      Uint8List markerIcon = await utilService.getBytesFromAsset(pin, 75);
      markers.add(
        Marker(
          markerId: MarkerId(allVenues[i].venueID!),
          position: LatLng(postCode.lat!.toDouble(), postCode.long!.toDouble()),
          icon: BitmapDescriptor.fromBytes(markerIcon),
          infoWindow: InfoWindow(
            title: allVenues[i].venueName,
            snippet: allVenues[i].streetAddress,
            onTap: () => Get.to(() => ViewVenue(venueID: allVenues[i].venueID)),
          ),
        ),
      );
    }
  }

  getLocation() async {
    double lat = 51.509865;
    double long = -0.118092;

    center = LatLng(lat, long);
    var location = new loc.Location();
    bool enabled = await location.serviceEnabled();
    if (enabled) {
      try {
        loc.LocationData locationData = await location.getLocation();
        center = LatLng(locationData.latitude!, locationData.longitude!);
      } on Exception {
        center = LatLng(lat, long);
      }
    } else {
      bool gotEnabled = await location.requestService();
      if (gotEnabled) {
        await getLocation();
      } else {
        center = LatLng(lat, long);
      }
    }
  }

  void _onCameraMove(CameraPosition position) {
    lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller1) {
    controller.complete(controller1);
  }

  void _showSortDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding / 2)),
                  insetPadding: EdgeInsets.all(10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(padding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Sort By", textScaleFactor: 1.25),
                        Divider(color: Colors.grey.shade400, height: 20, thickness: 1),
                        RadioListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          groupValue: sortBy,
                          title: Text('Local Impact', textScaleFactor: 1.1),
                          value: 'lm3ImpactValue',
                          onChanged: (val) => setState(() => sortBy = val!),
                        ),
                        RadioListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          groupValue: sortBy,
                          title: Text('Popularity', textScaleFactor: 1.1),
                          value: 'popular',
                          onChanged: (val) => setState(() => sortBy = val!),
                        ),
                        RadioListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          groupValue: sortBy,
                          title: Text('Ratings', textScaleFactor: 1.1),
                          value: 'ratings',
                          onChanged: (val) => setState(() => sortBy = val!),
                        ),
                        RadioListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          groupValue: sortBy,
                          title: Text('Pre-Theatre Dining', textScaleFactor: 1.1),
                          value: 'preTheatreDining',
                          onChanged: (val) => setState(() => sortBy = val!),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text('Apply')),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
    if (result) {
      setState(() {});
    }
  }

  void _showFilterDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding / 2)),
                  insetPadding: EdgeInsets.all(10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(padding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Filter By", textScaleFactor: 1.25),
                        Divider(color: Colors.grey.shade400, height: 20, thickness: 1),
                        RadioListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          groupValue: filter,
                          title: Text('Any', textScaleFactor: 1.1),
                          value: 'any',
                          onChanged: (val) => setState(() => filter = val!),
                        ),
                        RadioListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          groupValue: filter,
                          title: Text('Home (${userController.currentUser.value.livePostcodeDocId?.toUpperCase()})', textScaleFactor: 1.1),
                          value: 'home',
                          onChanged: (val) => setState(() => filter = val!),
                        ),
                        RadioListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          groupValue: filter,
                          title: Text('Work (${userController.currentUser.value.workPostcodeDocId == '' ? 'N/A' : userController.currentUser.value.workPostcodeDocId?.toUpperCase() ?? 'N/A'})', textScaleFactor: 1.1),
                          value: 'work',
                          onChanged: (val) {
                            if (userController.currentUser.value.workPostcodeDocId == '' || userController.currentUser.value.workPostcodeDocId == null)
                              showWorkPostCodeDialog();
                            else
                              setState(() => filter = val!);
                          },
                        ),
                        RadioListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          groupValue: filter,
                          title: dropdownSearch('Visit', 'Visit a Place', lauaConstants),
                          value: 'visit',
                          onChanged: (val) => visit == ''
                              ? Get.defaultDialog(
                                  radius: padding / 2,
                                  title: 'Search',
                                  content: dropdownSearch('Visit', 'Enter', lauaConstants),
                                )
                              : setState(() => filter = val!),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text('Apply')),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
    if (result) {
      setState(() {});
    }
  }

  showWorkPostCodeDialog() {
    TextEditingController workPostCodeTEC = TextEditingController();
    Get.back();
    Get.defaultDialog(
      radius: padding / 2,
      titlePadding: EdgeInsets.all(padding),
      contentPadding: EdgeInsets.symmetric(horizontal: 15),
      title: 'Enter your work postcode',
      content: CustomTextField(
        label: '',
        hint: 'Enter Postcode',
        labelColor: greenColor,
        controller: workPostCodeTEC,
        maxLines: 1,
        validate: true,
        isEmail: false,
        textInputType: TextInputType.text,
      ),
      actions: [
        ElevatedButton(
            onPressed: () async {
              Get.back();

              if (workPostCodeTEC.text.isEmpty) {
                showRedAlert('Please enter a valid postcode');
                return;
              }
              utilService.showLoading();
              await cloudFunction(
                  functionName: 'updateUser',
                  parameters: {
                    'userID': userController.currentUser.value.userID,
                    'workPostcodeDocId': workPostCodeTEC.text.replaceAll(" ", "").toLowerCase(),
                  },
                  action: () async {
                    await firestoreService.getCurrentUser();
                  });
              Get.back();
              filter = 'work';
              setState(() {});
            },
            child: Text('Save', textScaleFactor: 1)),
        TextButton(onPressed: () => Get.back(), child: Text('Cancel', textScaleFactor: 1)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greenColor,
      body: DefaultTabController(
        initialIndex: 0,
        length: 1,
        child: Column(
          children: [
            Heading(title: 'VENUES'),
            Expanded(
              child: Container(
                color: greenColor,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    buildVenues(),
                  ],
                ),
              ),
            ),
            PoweredBy(),
          ],
        ),
      ),
    );
  }

  String? visitPlace;

  dropdownSearch(String title, String hint, RxList items) {
    return Obx(() {
      return MediaQuery(
        data: MediaQueryData(textScaleFactor: 1),
        child: DropdownSearch<String>(
          selectedItem: visitPlace,
          popupProps: PopupProps.modalBottomSheet(showSearchBox: true),
          dropdownDecoratorProps: DropDownDecoratorProps(
            textAlignVertical: TextAlignVertical.center,
            dropdownSearchDecoration: InputDecoration(
              //isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: hint,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
          items: items.map((s) => s as String).toList(),
          onChanged: (onChangedElement) async {
            visitPlace = onChangedElement;
            Get.back();
            utilService.showLoading();
            int i = lauaConstants.indexWhere((element) => element == onChangedElement);
            //visit = await voucherService.getPostCodeFromLAUA(lauaDocID[i]);
            visit = lauaDocID[i];
            Get.back();
            filter = 'visit';
            setState(() {});
            print(i);
          },
        ),
      );
    });
  }

  List<Venue> allVenues = [];

  buildVenues() {
    return Obx(() {
      return Column(
        children: [
          Expanded(
            child: showList.isFalse ? showVenuesMap() : showVenuesList(),
          ),
          Container(
            color: Colors.grey.shade400,
            height: 45,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: InkWell(
                      onTap: () => showList.toggle(),
                      child: Text(
                        showList.isFalse ? 'Show List' : 'Show Map',
                        style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, decoration: TextDecoration.underline, fontSize: 15),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: InkWell(
                      onTap: () => _showFilterDialog(),
                      child: Text(
                        'Filter',
                        style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, decoration: TextDecoration.underline, fontSize: 15),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: InkWell(
                      onTap: () => _showSortDialog(),
                      child: Text(
                        'Sort',
                        style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, decoration: TextDecoration.underline, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  showVenuesMap() {
    return GoogleMap(
      myLocationEnabled: false,
      onMapCreated: _onMapCreated,
      markers: markers,
      onCameraMove: _onCameraMove,
      initialCameraPosition: CameraPosition(
        target: center,
        zoom: 14.0,
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
            padding: const EdgeInsets.only(bottom: 25),
            itemBuilderType: PaginateBuilderType.listView,
            itemBuilder: (context, documentSnapshot, i) {
              Venue venue = documentSnapshot[i].data() as Venue;
              allVenues.add(venue);
              return VenueItem(venue: venue, isMyVenue: false);
            },
            query: snapshot.data as Query,
            onEmpty: Padding(
              padding: const EdgeInsets.all(padding),
              child: Column(
                children: [
                  Text(
                    'No venues to display with your current selection. Try changing the filters',
                    textScaleFactor: 1.25,
                    style: TextStyle(color: Colors.white),
                  ),
                  InkWell(
                    onTap: () async {
                      if (userController.currentUser.value.accountID != null && userController.currentUser.value.accountID != '') {
                        bool isAccountApproved = false;
                        isAccountApproved = await getAccountStatus();
                        if (isAccountApproved)
                          Get.to(() => AddNewVenue());
                        else
                          utilService.showInfoDialog('Awaiting approval', 'Your account is awaiting approval. If you have not heard from us within 48 hours, please contact support@EatOutRoundAbout.co.uk', false);
                      } else
                        addAccount(context, true);
                    },
                    //onTap: () =>Get.to(()=> AddAccount()),
                    child: ColorCard(title: 'Let\'s dine with you', subTitle: 'Sign up here, if you have a stunning restaurant or cafe and value sourcing locally. It\'s free to feature on Eat Out Round About and we\'ll fund your voucher redemptions.', color: orangeColor),
                  ),
                  InkWell(
                    onTap: () => Get.to(() => RecommendVenue()),
                    child: ColorCard(title: 'Recommend a Venue', subTitle: 'We’d love to have venues open in your area. Why not recommend your favourites and we’ll contact them? It’s free for venues to list!', color: redColor),
                  ),
                ],
              ),
            ),
            itemsPerPage: 10,
            bottomLoader: LoadingData(),
            initialLoader: LoadingData(),
          );
        } else
          return LoadingData();
      },
    );
  }

  getAccountStatus() async {
    final firestoreService = Get.find<FirestoreService>();
    bool isAccountApproved = false;

    utilService.showLoading();

    DocumentSnapshot doc = await firestoreService.getMyAccount();
    if (doc != null) {
      Account account = doc.data() as Account;
      isAccountApproved = account.accountApproved!;
    }
    Get.back();

    return isAccountApproved;
  }

  addAccount(context, isVenueAccount) {
    Get.defaultDialog(
      radius: padding / 2,
      contentPadding: const EdgeInsets.all(padding),
      title: 'Create account?',
      content: Text(
        'To proceed further, you need to create an account and get it approved. Would you like to create an account now?',
        textAlign: TextAlign.center,
      ),
      actions: [
        CustomButton(
          function: () {
            Get.back();
            Get.to(() => AddAccount(isVenueAccount: isVenueAccount));
          },
          text: 'Yes',
          color: primaryColor,
        ),
        CustomButton(
          function: () => Get.back(),
          text: 'No',
          color: Colors.grey,
        ),
      ],
    );
  }

  getQuery() async {
    String? postCode;
    String? laua;
    if (filter == 'home') postCode = userController.currentUser.value.livePostcodeDocId;
    if (filter == 'work') postCode = userController.currentUser.value.workPostcodeDocId;
    if (filter == 'visit') laua = visit;
    if (filter == 'home' || filter == 'work') laua = await firestoreService.getLAUAForPostcode(postCode!);

    switch (sortBy) {
      case 'lm3ImpactValue':
        return firestoreService.getLocalImpactVenues(laua!);
      case 'popular':
        return firestoreService.getPopularVenues(laua!);
      case 'ratings':
        return firestoreService.getRatedVenues(laua!);
      case 'preTheatreDining':
        return firestoreService.getPreTheatreDiningVenues(laua!);
    }
  }
}
