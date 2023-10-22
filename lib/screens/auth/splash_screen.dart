import 'dart:async';

import 'package:eatoutroundabout/screens/auth/login.dart';
import 'package:eatoutroundabout/screens/auth/onboarding.dart';
import 'package:eatoutroundabout/screens/home/home_page.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/utils/preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_launcher_nullsafe/store_launcher_nullsafe.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final firestoreService = Get.find<FirestoreService>();

  void handleTimeout() async {
    bool flag = await Preferences.getOnboardingStatus();
    if (flag) {
      if (FirebaseAuth.instance.currentUser == null || await Preferences.getUser() == null || await Preferences.getUser() == '') {
        Get.off(() => Login());
      } else {
        USER_ROLE.value = await Preferences.getUserRole();
        await firestoreService.getCurrentUser();
        await firestoreService.getCurrentAccount();
        await firestoreService.registerFirebase();
        print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
        Get.offAll(() => HomePage());
      }
    } else
      Get.off(Onboarding());
  }

  startTimeout() async {
    if (await firestoreService.updateVersion())
      try {
        Get.defaultDialog(
          radius: padding / 2,
          barrierDismissible: false,
          title: 'Update required',
          content: Text('We have been busy doing some updates to improve your experience of Eat Out Round About.'),
          contentPadding: const EdgeInsets.all(10),
          actions: [
            TextButton(
                onPressed: () async {
                  await StoreLauncher.openWithStore('com.eatoutroundabout');
                },
                child: Text('Update Now')),
          ],
        );
      } catch (e) {
        showRedAlert('You must update the app for new features and less bugs');
      }
    else {
      var duration = const Duration(seconds: 1);
      return new Timer(duration, handleTimeout);
    }
  }

  @override
  void initState() {
    super.initState();
    startTimeout();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'logo',
              child: Image.asset('assets/images/home_logo.png',width: Get.width/2, height: MediaQuery.of(context).size.height * 0.25),
            ),
            Image.asset('assets/images/loading.gif', height: 80),
          ],
        ),
      ),
    );
  }
}
