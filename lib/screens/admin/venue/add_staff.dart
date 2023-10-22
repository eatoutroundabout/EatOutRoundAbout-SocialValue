import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/users_model.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:eatoutroundabout/widgets/staff_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddStaff extends StatelessWidget {
  final Venue? venue;

  AddStaff({this.venue});

  int staffType = 0;
  bool isReceptionist = false;
  final firestoreService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: <Widget>[
          Heading(title: 'ADD STAFF'),
          Padding(
            padding: const EdgeInsets.all(padding),
            child: Text(venue!.venueName!, textScaleFactor: 1.25, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    height: 45,
                    margin: const EdgeInsets.all(padding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(padding / 2),
                      color: Colors.grey.shade400,
                    ),
                    child: TabBar(
                      tabs: [
                        Tab(text: 'Venue Admins'),
                        Tab(text: 'Venue Staff'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        StreamBuilder(
                          stream: firestoreService.getVenueAdminForVenue(venue!.venueID!),
                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData)
                              return snapshot.data!.docs.length > 0
                                  ? ListView.builder(
                                      padding: const EdgeInsets.symmetric(horizontal: padding),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, i) {
                                        DocumentSnapshot doc = snapshot.data!.docs[i];
                                        User user = doc!.data() as User;
                                        return StaffItem(user: user, venueID: venue!.venueID, staffType: VENUE_ADMIN);
                                      },
                                    )
                                  : EmptyBox(text: 'No Admins added yet');
                            else
                              return LoadingData();
                          },
                        ),
                        StreamBuilder(
                          stream: firestoreService.getStaffForVenue(venue!.venueID!),
                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData)
                              return snapshot.data!.docs.length > 0
                                  ? ListView.builder(
                                      padding: const EdgeInsets.symmetric(horizontal: padding),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, i) {
                                        DocumentSnapshot doc = snapshot.data!.docs[i];
                                        User user = doc!.data() as User;
                                        return StaffItem(user: user, venueID: venue!.venueID, staffType: VENUE_STAFF);
                                      },
                                    )
                                  : EmptyBox(text: 'No Staff added yet');
                            else
                              return LoadingData();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(padding),
            child: CustomButton(
              color: primaryColor,
              text: 'Add Staff Member',
              function: () async {
                TextEditingController staffTEC = TextEditingController();
                showDialog(
                  context: context,
                  builder: (BuildContext context1) {
                    return StatefulBuilder(builder: (context2, setState) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding / 2)),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Add Staff Member', textScaleFactor: 1.25),
                              CustomTextField(
                                label: 'Enter Mobile Number',
                                hint: '10 digit mobile number',
                                labelColor: greenColor,
                                controller: staffTEC,
                                maxLines: 1,
                                validate: true,
                                isEmail: false,
                                textInputType: TextInputType.phone,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Radio(
                                              value: 0,
                                              groupValue: staffType,
                                              onChanged: (value) {
                                                setState(() {
                                                  staffType = value!;
                                                });
                                              },
                                            ),
                                            Text(
                                              'Staff',
                                              style: new TextStyle(color: greenColor),
                                            ),
                                          ],
                                        ),
                                        Text('- Can redeem vouchers', textScaleFactor: 0.85, style: TextStyle(color: Colors.grey)),
                                        Text('- Can find suppliers', textScaleFactor: 0.85, style: TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Radio(
                                              value: 1,
                                              groupValue: staffType,
                                              onChanged: (value) {
                                                setState(() {
                                                  staffType = value!;
                                                });
                                              },
                                            ),
                                            Text(
                                              'Admin',
                                              style: new TextStyle(color: greenColor),
                                            ),
                                          ],
                                        ),
                                        Text('- Can redeem vouchers', textScaleFactor: 0.85, style: TextStyle(color: Colors.grey)),
                                        Text('- Can find suppliers', textScaleFactor: 0.85, style: TextStyle(color: Colors.grey)),
                                        Text('- Can modify a venue', textScaleFactor: 0.85, style: TextStyle(color: Colors.grey)),
                                        Text('- Can view redemptions', textScaleFactor: 0.85, style: TextStyle(color: Colors.grey)),
                                        Text('- Can add staff/admin', textScaleFactor: 0.85, style: TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              CheckboxListTile(
                                value: isReceptionist,
                                onChanged: (val) => setState(() => isReceptionist = val!),
                                title: Text('Set as Receptionist'),
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(child: CustomButton(function: () => Get.back(), text: 'Cancel', color: Colors.grey)),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          String mobile = staffTEC.text.trim();
                                          if (mobile.startsWith("0")) mobile = mobile.substring(1, mobile.length);
                                          if (!mobile.startsWith("+44")) mobile = "+44" + mobile;

                                          Map parameters = {
                                            'mobile': mobile,
                                            'venueID': venue!.venueID,
                                            'type': staffType == 0 ? 'venueStaff' : 'venueAdmin',
                                            'receptionist': isReceptionist,
                                          };
                                          await cloudFunction(functionName: 'addStaff', parameters: parameters, action: () => Get.back());
                                          // if (staffType == 0)
                                          //   await firestoreService.addVenueStaff(mobile, venue.venueID);
                                          // else
                                          //   await firestoreService.addVenueAdmin(mobile, venue.venueID);
                                        },
                                        child: Text('Add', textScaleFactor: 1)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
