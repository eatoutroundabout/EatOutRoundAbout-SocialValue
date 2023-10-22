import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/screens/profile/dietary_preferences.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class PrivacySettings extends StatefulWidget {
  final bool? isSetup;

  PrivacySettings({this.isSetup});

  @override
  State<PrivacySettings> createState() => _PrivacySettingsState();
}

class _PrivacySettingsState extends State<PrivacySettings> {
  final marketing = true.obs;
  final economyTips = true.obs;
  final pushNotifications = true.obs;
  final presentProfile = true.obs;
  final eventVisibility = true.obs;
  final shareInCircle = true.obs;
  final sms = false.obs;
  final email = false.obs;
  final userController = Get.find<UserController>();
  final utilService = Get.find<UtilService>();
  @override
  void initState() {
    marketing.value = userController.currentUser.value.isMarketing!;
    economyTips.value = userController.currentUser.value.isEconomyTips!;
    pushNotifications.value = userController.currentUser.value.isPushNotifications!;
    presentProfile.value = userController.currentUser.value.presentProfile!;
    eventVisibility.value = userController.currentUser.value.eventVisibility!;
    shareInCircle.value = userController.currentUser.value.shareInCircle!;
    sms.value = userController.currentUser.value.smsUpdates!;
    email.value = userController.currentUser.value.emailUpdates!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15)),
      body: Column(
        children: [
          Heading(title: 'PRIVACY SETTINGS'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: padding, vertical: 30),
              child: Column(
                children: [
                  Text('Pick \'n\' Mix your Privacy Settings', textAlign: TextAlign.center, textScaleFactor: 1.25, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Your Privacy and Experience is important to us\nRefer to our Privacy Policy on how data is stored and processed', textAlign: TextAlign.center, textScaleFactor: 0.9),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () => utilService.openLink('https://eatoutroundabout.co.uk/legals/privacy-policy/'),
                    child: Text(
                      'View privacy policy.',
                      textScaleFactor: 0.95,
                      maxLines: 2,
                      style: TextStyle(color: Colors.teal, decoration: TextDecoration.underline),
                    ),
                  ),
                  Divider(height: 50),
                  setting(0, 'Keep me updated with events, restaurants and recommendations'),
                  setting(1, 'Keep me updated with ideas to help my local economy'),
                  setting(2, 'Push Notifications'),
                  setting(3, 'Would you like us to present your profile for others to connect?'),
                  setting(4, 'Would you like to be visible when attending events?'),
                  setting(5, 'Share my details in the circle'),
                  Text('We\'d love to keep you updated with deals from our restaurant partners. We will not share your data. Select how you you would like to hear'),
                  Obx(() {
                    return Row(
                      children: [
                        Expanded(child: CheckboxListTile(value: sms.value, controlAffinity: ListTileControlAffinity.leading, onChanged: (val) => sms.value = val!, title: Text('SMS'))),
                        SizedBox(height: 80),
                        Expanded(child: CheckboxListTile(value: email.value, controlAffinity: ListTileControlAffinity.leading, onChanged: (val) => email.value = val!, title: Text('Email'))),
                      ],
                    );
                  }),
                  CustomButton(
                    text: 'Update',
                    function: () async {
                      String ipAddress = await getIPAddress();
                      await cloudFunction(
                        functionName: 'updatePrivacy',
                        parameters: {
                          'userID': userController.currentUser.value.userID,
                          'ipAddress': ipAddress,
                          'marketingBefore': userController.currentUser.value.isMarketing,
                          'pushNotificationsBefore': userController.currentUser.value.isPushNotifications,
                          'economyTipsBefore': userController.currentUser.value.isEconomyTips,
                          'presentProfileBefore': userController.currentUser.value.presentProfile,
                          'eventVisibilityBefore': userController.currentUser.value.eventVisibility,
                          'shareInCircleBefore': userController.currentUser.value.shareInCircle,
                          'smsBefore': userController.currentUser.value.smsUpdates,
                          'emailBefore': userController.currentUser.value.emailUpdates,
                          'marketingAfter': marketing.value,
                          'pushNotificationsAfter': pushNotifications.value,
                          'economyTipsAfter': economyTips.value,
                          'presentProfileAfter': presentProfile.value,
                          'eventVisibilityAfter': eventVisibility.value,
                          'shareInCircleAfter': shareInCircle.value,
                          'smsAfter': sms.value,
                          'emailAfter': email.value,
                        },
                        action: () async {
                          final firestoreService = Get.find<FirestoreService>();
                          await firestoreService.getCurrentUser();
                          if (widget.isSetup!)
                            Get.offAll(() => DietaryPreferences(isSetup: true));
                          else
                            Get.back();
                        },
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  if (widget.isSetup!) CustomButton(text: 'Skip', color: Colors.grey, function: () => Get.offAll(() => DietaryPreferences(isSetup: true))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  setting(int i, String text) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Row(
          children: [
            FlutterSwitch(
              value: getValue(i),
              borderRadius: 30.0,
              padding: 8.0,
              activeColor: primaryColor,
              showOnOff: true,
              onToggle: (value) => setValue(i, value),
            ),
            SizedBox(width: 15),
            Expanded(child: Text(text)),
          ],
        ),
      );
    });
  }

  getValue(int i) {
    switch (i) {
      case 0:
        return marketing.value;
      case 1:
        return economyTips.value;
      case 2:
        return pushNotifications.value;
      case 3:
        return presentProfile.value;
      case 4:
        return eventVisibility.value;
      case 5:
        return shareInCircle.value;
    }
  }

  setValue(int i, bool value) {
    switch (i) {
      case 0:
        return marketing.value = value;
      case 1:
        return economyTips.value = value;
      case 2:
        return pushNotifications.value = value;
      case 3:
        return presentProfile.value = value;
      case 4:
        return eventVisibility.value = value;
      case 5:
        return shareInCircle.value = value;
    }
  }

  getIPAddress() async {
    utilService.showLoading();
    String? ip = await utilService.getIpAddress();
    Get.back();
    return ip;
  }
}
