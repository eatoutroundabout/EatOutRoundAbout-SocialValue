import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color primaryColor = Color(0xff084C61);
const Color appBackground = Color(0xffEFF1F6);
const Color redColor = Color(0xffE2223D);
const Color orangeColor = Color(0xffEE5337);
Color greenColor = Colors.teal.shade400;
const Color lightGreenColor = Color(0xffD0FDF8);
const Color purpleColor = Color(0xff201E49);
const Color blueColor = Color(0xff1463B1);
final RxString USER_ROLE = 'Select'.obs;
const int ANDROID_VERSION = 45;
const int IOS_VERSION = 68;
const double padding = 10;
String serverToken = '';

double myLatitude = 53.6833;
double myLongitude = 1.5059;

showRedAlert(String text) {
  return Get.snackbar('Error', text, backgroundColor: redColor, colorText: Colors.white, margin: EdgeInsets.all(padding), animationDuration: Duration(milliseconds: 500));
}

showGreenAlert(String text) {
  return Get.snackbar('Success', text, backgroundColor: greenColor, colorText: Colors.white, margin: EdgeInsets.all(padding), animationDuration: Duration(milliseconds: 500));
}

showYellowAlert(String text) {
  Get.snackbar('Please wait', text, backgroundColor: Colors.amber, colorText: Colors.black, margin: const EdgeInsets.all(padding), animationDuration: const Duration(milliseconds: 500));
}

const String VENUE_ADMIN = 'Venue Admin';
const String VENUE_STAFF = 'Venue Staff';
const String SELECT_ROLE = 'Select';
const String VIEW_EVENT = 'View Event';
const String VIEW_OFFER = 'View Offer';
const String VIEW_PRODUCT = 'View Product';
const String VIEW_MEMBERSHIP = 'Membership';

//
// isAccessible(String feature) {
//   switch (USER_ROLE.value) {
//     case PARTNER:
//       return PARTNER_FEATURES.contains(feature);
//
//     case VENUE_ADMIN:
//       return VENUE_ADMIN_FEATURES.contains(feature);
//
//     case VENUE_STAFF:
//       return VENUE_STAFF_FEATURES.contains(feature);
//
//     case BUSINESS_ADMIN:
//       return BUSINESS_ADMIN_FEATURES.contains(feature);
//
//     case USER:
//       return APP_USER_FEATURES.contains(feature);
//   }
// }
