import 'package:eatoutroundabout/app.dart';
import 'package:eatoutroundabout/controllers/notification_controller.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

initialSetup(Flavor appFlavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupNotifications();
  switch (appFlavor) {
    case Flavor.production:
      serverToken = 'AAAAnMCCmS8:APA91bH1aldfeuRXKghCnaJFX14PdQbHvXSAduuzZi7GeYXK6zXM34eLQ7AVmlgYZgR6bjr15UdbcaDeg0hDBHSuXf68T-5L6kJ3pDVudCtRY3YaU_KpDtFX88-ITzV3jBE--rPHCHsp';
      Stripe.publishableKey = 'pk_live_51IYbbCIPHlbMd1PrF5SDIkSxKUWxBabnInxwYNMA7cKHQLLZvxGBIHag8N0jojOzDr912mcTvHPdG9yHEQdwoPA800utz7rCz8';
      break;
    case Flavor.development:
      serverToken = 'AAAA1nDxAGU:APA91bHeamM8PIp3DiYaoA_7459vfRq2y4nYOAObEY5JQ6-C22hmuvETLOMUgbB6yV0ihx96KKOhc_bAf0ND_y7ee1FRpjz5zTlvd5Ot1n4G3JBHyx5AAcsDhF9-XmMwDBhiXZottiv5';
      Stripe.publishableKey = 'pk_test_51IYbbCIPHlbMd1PrIpO5ugzpQiYiz5niGtPI4Qu6rG9dm7P3uFvF8vnutM1IOHxe5gSOYg4Nhxu5Bb0hyuXHKH7100DADzhkfh';
      break;
  }
}

/*

07786060111 : Venue Staff
01111111111 : Venue Admin
09876543210 : Account Admin (Blank)
01234567890 : Business Admin (Every business admin is an account admin)
07020005992 : Business Staff

*/
