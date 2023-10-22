import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/users_model.dart';
import 'package:eatoutroundabout/screens/circle/my_connections.dart';
import 'package:eatoutroundabout/screens/profile/scan_user.dart';
import 'package:eatoutroundabout/screens/profile/view_profile.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_list_tile.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share/share.dart';

class CircleHome extends StatelessWidget {
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      body: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Column(
          children: [
            Heading(title: 'CIRCLE'),
            Expanded(child: buildCircle()),
          ],
        ),
      ),
    );
  }

  buildCircle() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(padding),
        child: Column(
          children: [
            CustomListTile(
              onTap: () => Get.to(() => MyConnections()),
              leading: Icon(Icons.group_outlined, color: primaryColor),
              title: Text('My Connections'),
              trailing: Icon(Icons.keyboard_arrow_right_rounded, color: primaryColor),
            ),
            // CustomListTile(
            //   onTap: () => Get.to(() => ShowCommunities()),
            //   leading: Icon(Icons.group_outlined, color: primaryColor),
            //   title: Text('My Communities'),
            //   trailing: Icon(Icons.keyboard_arrow_right_rounded, color: primaryColor),
            // ),
            //Divider(height: 50, color: greenColor),
            SizedBox(height: 20),
            PrettyQr(
              typeNumber: 3,
              size: 200,
              data: userController.currentUser.value.userID!,
              roundEdges: true,
            ),
            SizedBox(height: 20),
            Text(
              'This is your personal QR code. \nYou can ask others to scan this QR code and add them to your circle.',
              textAlign: TextAlign.center,
              style: TextStyle(color: greenColor),
            ),
            SizedBox(height: 20),
            CustomButton(
              color: redColor,
              text: 'Scan to add a connection',
              function: () => Get.to(() => ScanUser()),
            ),
            SizedBox(height: padding),
            CustomButton(
              text: 'Add connection using mobile number',
              function: () {
                TextEditingController staffTEC = TextEditingController();
                final firestoreService = Get.find<FirestoreService>();
                Get.defaultDialog(
                  radius: padding / 2,
                  title: 'Enter Mobile number',
                  content: CustomTextField(label: 'Enter Mobile Number', hint: '10 digit mobile number', labelColor: greenColor, controller: staffTEC, maxLines: 1, validate: true, isEmail: false, textInputType: TextInputType.phone),
                  actions: [
                    CustomButton(
                      function: () async {
                        Get.back();
                        utilService.showLoading();
                        String mobile = staffTEC.text.trim();
                        if (mobile.startsWith("0")) mobile = mobile.substring(1, mobile.length);
                        if (!mobile.startsWith("+44")) mobile = "+44" + mobile;
                        QuerySnapshot<User> querySnapshot = await firestoreService.getUserViaMobile(mobile);
                        Get.back();
                        if (querySnapshot.docs.isNotEmpty) {
                          User user = querySnapshot.docs[0].data();
                          Get.to(() => ViewProfile(userID: user.userID));
                        } else
                          showRedAlert('User does not exist. Please check the mobile number');
                      },
                      text: 'Connect',
                      color: primaryColor,
                    ),
                    CustomButton(text: 'Cancel', color: Colors.grey, function: () => Get.back()),
                  ],
                );
              },
            ),
            InkWell(
              onTap: () {
                Share.share(' Let’s Eat Out Round About Together. Download the app and get 50% off up to £10 off your next meal out.\nhttps://qrs.ly/96dz5q1. Use Promo Code: ${userController.currentUser.value.userReferralCode}');
              },
              child: card('Recommend Someone', 'When they join they receive an Eat Out Voucher and so do you!', greenColor),
            ),
          ],
        ),
      ),
    );
  }

  card(String title, String subTitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(padding * 2),
      margin: const EdgeInsets.only(top: padding),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(padding / 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, textScaleFactor: 1.5, style: TextStyle(color: Colors.white)),
                SizedBox(height: 15),
                Text(subTitle, style: TextStyle(color: Colors.white70)),
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
    );
  }
}
