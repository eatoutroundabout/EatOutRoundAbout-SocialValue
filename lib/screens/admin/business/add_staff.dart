import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/models/users_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/business_staff_item.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBusinessStaff extends StatelessWidget {
  final BusinessProfile? businessProfile;

  AddBusinessStaff({this.businessProfile});

  int staffType = 0;
  bool isReceptionist = false;
  final firestoreService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();
  final utilService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: <Widget>[
          Heading(title: 'ADD STAFF'),
          Padding(
            padding: const EdgeInsets.all(padding),
            child: Text(businessProfile!.businessName!, textScaleFactor: 1.25, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: StreamBuilder(
              stream: firestoreService.getStaffForBusinessProfile(businessProfile!.businessProfileID!),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData)
                  return snapshot.data!.docs.length > 0
                      ? ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: padding),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, i) {
                            DocumentSnapshot doc = snapshot.data!.docs[i];
                            User user = doc!.data() as User;
                            return BusinessStaffItem(user: user, businessProfileID: businessProfile!.businessProfileID);
                          },
                        )
                      : EmptyBox(text: 'No Staff added yet');
                else
                  return LoadingData();
              },
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
                                validate: true,
                                textInputType: TextInputType.phone,
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
                                          Get.back();
                                          utilService.showLoading();
                                          String mobile = staffTEC.text.trim();
                                          if (mobile.startsWith("0")) mobile = mobile.substring(1, mobile.length);
                                          if (!mobile.startsWith("+44")) mobile = "+44" + mobile;
                                          List<QueryDocumentSnapshot<User>> users = (await firestoreService.getUserViaMobile(mobile)).docs;
                                          Get.back();
                                          if (users.isNotEmpty) {
                                            String userID = users[0].data().userID!;
                                            // await firestoreService.updateUser({
                                            //   'businessProfileStaff': FieldValue.arrayUnion([userID]),
                                            //   'userID': userID
                                            // });
                                            await firestoreService.addBusinessStaff(userID, businessProfile!.businessProfileID!);
                                            await showGreenAlert('Added successfully');
                                          } else
                                            showRedAlert('No user with this mobile is registered with us.');
                                        },
                                        child: Text('Add')),
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
