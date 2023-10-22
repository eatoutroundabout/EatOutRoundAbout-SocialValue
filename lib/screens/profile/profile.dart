import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/account_model.dart';
import 'package:eatoutroundabout/screens/admin/account/add_account.dart';
import 'package:eatoutroundabout/screens/admin/business/add_business_profile.dart';
import 'package:eatoutroundabout/screens/admin/venue/add_a_venue.dart';
import 'package:eatoutroundabout/screens/events/my_bookings.dart';
import 'package:eatoutroundabout/screens/events/my_events.dart';
import 'package:eatoutroundabout/screens/home/recommend_venue.dart';
import 'package:eatoutroundabout/screens/profile/dietary_preferences.dart';
import 'package:eatoutroundabout/screens/profile/edit_profile.dart';
import 'package:eatoutroundabout/screens/profile/privacy_settings.dart';
import 'package:eatoutroundabout/screens/profile/view_profile.dart';
import 'package:eatoutroundabout/services/authentication_service.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/storage_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/color_card.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_list_tile.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

class Profile extends StatelessWidget {
  final userController = Get.find<UserController>();
  final authService = Get.find<AuthService>();
  final firestoreService = Get.find<FirestoreService>();
  final storageService = Get.find<StorageService>();
  final utilService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Heading(title: 'MY PROFILE'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //   padding: const EdgeInsets.all(padding),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.all(Radius.circular(padding/2)),
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Obx(() {
                  //         return CachedImage(
                  //           roundedCorners: false,
                  //           url: userController.currentUser.value.photoURL ?? '',
                  //           height: MediaQuery.of(context).size.height * 0.12,
                  //           circular: true,
                  //         );
                  //       }),
                  //       SizedBox(width: 10),
                  //       Expanded(
                  //         child: Column(
                  //           children: [
                  //             Text(userController.currentUser.value.firstName + " " + userController.currentUser.value.lastName, textScaleFactor: 1.35),
                  //             SizedBox(height: 15),
                  //             Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //               children: [
                  //                 InkWell(
                  //                   onTap: () async {},
                  //                   child: Column(
                  //                     children: [
                  //                       Text(userController.currentUser.value.connections.toString(), textScaleFactor: 1.25, style: TextStyle(color: redColor)),
                  //                       Text('Connections', style: TextStyle(color: Colors.grey), textScaleFactor: 0.9),
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 InkWell(
                  //                   onTap: () async {},
                  //                   child: Column(
                  //                     children: [
                  //                       Text(userController.currentUser.value.biteBalance.toString(), textScaleFactor: 1.25, style: TextStyle(color: redColor)),
                  //                       Text('Bites Balance', style: TextStyle(color: Colors.grey), textScaleFactor: 0.9),
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 // InkWell(
                  //                 //   onTap: () async {},
                  //                 //   child: Column(
                  //                 //     children: [
                  //                 //       Text('3', textScaleFactor: 1.25, style: TextStyle(color: redColor)),
                  //                 //       Text('Favorites', style: TextStyle(color: Colors.grey), textScaleFactor: 0.9),
                  //                 //     ],
                  //                 //   ),
                  //                 // ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Center(
                    child: Obx(() {
                      return CachedImage(
                        url: userController.currentUser.value.photoURL ?? '',
                        height: 150,
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  Center(child: Text(userController.currentUser.value.firstName! + " " + userController.currentUser.value.lastName!, textScaleFactor: 1.35)),
                  // SizedBox(height: 15),
                  // Center(child: Text('Available Bites : ' + userController.currentUser.value.biteBalance.toString(), textScaleFactor: 1.1, style: TextStyle(color: redColor))),
                  TextButton(onPressed: () => Get.to(() => ViewProfile(userID: userController.currentUser.value.userID)), child: Text('View Profile')),
                  //   buildCircleUserLayout(),
                  SizedBox(height: 20),
                  CustomListTile(
                    onTap: () => Get.to(() => EditProfile()),
                    leading: Icon(Icons.account_box_outlined, color: primaryColor),
                    title: Text('Edit Profile'),
                    trailing: Icon(Icons.keyboard_arrow_right_rounded, color: primaryColor),
                  ),
                  CustomListTile(
                    onTap: () => Get.to(() => DietaryPreferences(isSetup: false)),
                    leading: Icon(Icons.no_food, color: primaryColor),
                    title: Text('Dietary Preferences'),
                    trailing: Icon(Icons.keyboard_arrow_right_rounded, color: primaryColor),
                  ),
                  CustomListTile(
                    onTap: () => Get.to(() => PrivacySettings(isSetup: false)),
                    leading: Icon(Icons.privacy_tip_outlined, color: primaryColor),
                    title: Text('Privacy Settings'),
                    trailing: Icon(Icons.keyboard_arrow_right_rounded, color: primaryColor),
                  ),
                  CustomListTile(
                    onTap: () => Get.to(() => MyBookings()),
                    leading: Icon(Icons.event_seat_outlined, color: primaryColor),
                    title: Text('My Bookings'),
                    trailing: Icon(Icons.keyboard_arrow_right_rounded, color: primaryColor),
                  ),
                  InkWell(
                    onTap: () {
                      //Clipboard.setData(ClipboardData(text: 'Let’s Eat Out Round About Together. Download the app and have a chance to win £10 off your next meal out. \nhttps://eatoutroundabout.co.uk'));
                      //showGreenAlert('Text copied to clipboard');
                      Share.share(' Let’s Eat Out Round About Together. Download the app and get 50% off up to £10 off your next meal out.\nhttps://qrs.ly/96dz5q1. Use Promo Code: ${userController.currentUser.value.userReferralCode}');
                    },
                    child: ColorCard(title: 'Recommend Someone', subTitle: 'When they join they receive an Eat Out Voucher and so do you!', color: greenColor),
                  ),
                  InkWell(
                    onTap: () async {
                      if (userController.currentUser.value.accountID != null && userController.currentUser.value.accountID != '') {
                        bool isAccountApproved = false;
                        isAccountApproved = await getAccountStatus();
                        if (isAccountApproved)
                          Get.to(() => AddBusinessProfile());
                        else
                          utilService.showInfoDialog('Awaiting approval', 'Your account is awaiting approval. If you have not heard from us within 48 hours, please contact support@EatOutRoundAbout.co.uk', false);
                      } else
                        addAccount(context, false);
                    },
                    child: ColorCard(title: 'Own or run a Business?', subTitle: 'Join our mission to benefit your business and local economy through hospitality perks and vouchers!', color: purpleColor),
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
                    child: ColorCard(title: 'Let\'s dine with you', subTitle: 'Sign up here, if you have a stunning restaurant or cafe and value sourcing locally. It\'s free to feature on Eat Out Round About.', color: orangeColor),
                  ),
                  InkWell(
                    onTap: () => Get.to(() => RecommendVenue()),
                    child: ColorCard(title: 'Recommend a Venue', subTitle: 'Recommend your favourite venues and if they come on the app, we\'ll send you a free voucher!', color: redColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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

  recommendAFriend() {
    TextEditingController friendMobileTEC = TextEditingController();
    Get.defaultDialog(
      radius: padding / 2,
      titlePadding: const EdgeInsets.only(top: 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      title: 'Recommend a Friend',
      content: CustomTextField(label: 'Enter your friend\'s mobile number and we will send them a text to invite them to Eat Out Round About and start earning bites with you.', hint: '10 digit mobile number', labelColor: greenColor, controller: friendMobileTEC, maxLines: 1, validate: true, isEmail: false, textInputType: TextInputType.phone),
      actions: [
        ElevatedButton(
            onPressed: () async {
              if (friendMobileTEC.text.isNotEmpty) {
                Get.back();
                String mobile = friendMobileTEC.text.trim();
                if (mobile.startsWith("0")) mobile = mobile.substring(1, mobile.length);
                if (!mobile.startsWith("+44")) mobile = "+44" + mobile;
                await cloudFunction(
                    functionName: 'recommendAFriend',
                    parameters: {
                      'userID': userController.currentUser.value.userID,
                      'mobile': mobile,
                    },
                    action: () {});
              } else
                showRedAlert('Enter mobile number');
            },
            child: Text('Recommend', textScaleFactor: 1)),
        TextButton(onPressed: () => Get.back(), child: Text('Cancel', textScaleFactor: 1)),
      ],
    );
  }

  buildCircleUserLayout() {
    if (userController.currentUser.value.isCircleUser!)
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Bio', textScaleFactor: 1.15, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(userController.currentUser.value.userBio!, style: TextStyle(color: greenColor)),
            SizedBox(height: 20),
            Text('Job Level', textScaleFactor: 1.15, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(userController.currentUser.value.jobLevel!, style: TextStyle(color: greenColor)),
            SizedBox(height: 20),
            Text('How Can I Help You?', textScaleFactor: 1.15, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(userController.currentUser.value.helpYou!, style: TextStyle(color: greenColor)),
            SizedBox(height: 20),
          ],
        ),
      );
    else
      return SizedBox();
  }
}
