import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

class BuyService {
  final ref = FirebaseFirestore.instance;
  final utilService = Get.find<UtilService>();
  final userController = Get.find<UserController>();

  Future<QuerySnapshot> getGreetings(String venueID) async {
    return await ref.collection('greetings').where('venueID', isEqualTo: venueID).orderBy('priority').get();
    //return await ref.collection('greetings').orderBy('priority').get();
  }

  buyMethod({BuildContext? context, num? total, num? quantity, String? image, String? message, String? mobile, String? discountCode, bool? marketing, Function? setState}) async {
    try {
      utilService.showLoading();
      bool success = await processPayment(amountToPay: total!);
      if (success) {
        await cloudFunction(
            functionName: 'inAppPurchase',
            parameters: {
              'orderTotal': total,
              'userID': userController.currentUser.value.userID,
              'voucherQty': quantity,
              'voucherImageUrl': image,
              'displayMessage': message,
              'mobileNumber': mobile,
              'discountCode': discountCode,
              'marketing': marketing,
              'greetingCard': true,
            },
            action: () => Get.back());
      } else {
        Get.back();
        showRedAlert('Payment not successful. Please try again');
      }
    } catch (e) {
      print('@@@@@@ ERROR @@@@@@@@');
      print(e);
      showRedAlert(e.toString());
      showRedAlert('Something went wrong. Please try again.');
      Get.back();

      Get.back();
    }
  }

  Map<String, dynamic>? paymentIntentData;

  printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Future<bool> processPayment({num? amountToPay}) async {
    try {
      HttpsCallable doesAuthExist = FirebaseFunctions.instanceFor(region: 'europe-west2').httpsCallable('stripePI');
      HttpsCallableResult results = await doesAuthExist({
        'paymentMethod': 'card',
        'amount': amountToPay! * 100,
      });
      paymentIntentData = results.data;
      print(json.encode(results.data));

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          style: ThemeMode.light,
          merchantDisplayName: 'Not Usual Ltd.',
        ),
      );
      //setState();
      return await displayPaymentSheet();
    } catch (e) {
      showRedAlert('Something went wrong. Please try again.');
      print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
      print(e);
      return false;
    }
  }

  Future<bool> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      final postPaymentIntent = await Stripe.instance.retrievePaymentIntent(paymentIntentData!['client_secret']);

      paymentIntentData = null;
      // setState();
      if (postPaymentIntent.status == PaymentIntentsStatus.Succeeded) {
        Get.back();
        showGreenAlert('Payment successful');
        return true;
      } else {
        return false;
      }
    } on StripeException catch (e) {
      print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
      print(e);
      return false;
    }
  }
}
