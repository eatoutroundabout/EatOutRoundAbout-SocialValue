import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/voucher_model.dart';
import 'package:eatoutroundabout/screens/auth/login.dart';
import 'package:eatoutroundabout/screens/home/home_page.dart';
import 'package:eatoutroundabout/screens/profile/privacy_settings.dart';
import 'package:eatoutroundabout/services/authentication_service.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/utils/preferences.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart' as u;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:r_get_ip/r_get_ip.dart';
import 'package:url_launcher/url_launcher.dart';

class UtilService {
  final firestoreService = Get.find<FirestoreService>();

  openLink(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch URL';
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  getPinColor(String venueImpactStatus) {
    switch (venueImpactStatus) {
      case 'none':
        return 'assets/images/pin.png';
      case 'gold':
        return 'assets/images/gold_pin.png';
      case 'silver':
        return 'assets/images/silver_pin.png';
      case 'bronze':
        return 'assets/images/bronze_pin.png';
      default:
        return 'assets/images/pin.png';
    }
  }

  Future<String?> getIpAddress() async {
    try {
      /// Initialize Ip Address
      // var ipAddress = IpAddress(type: RequestType.json);
      //
      // /// Get the IpAddress based on requestType.
      // dynamic data = await ipAddress.getIpAddress();
      // print(data.toString());
      // return data.toString();
      //print(await RGetIp.externalIP);
      return await RGetIp.externalIP;
    } on IpAddressException catch (exception) {
      /// Handle the exception.
      print(exception.message);
      return 'Could not fetch IP';
    }
  }

  validateEmail(String email) {
    if (email.isEmpty) {
      return "Email cannot be empty";
    }
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email) ? null : 'Invalid Email';
  }

  validateText(String text) {
    if (text.isEmpty) {
      return "Cannot be empty";
    }
  }

  generateCaseSearch(String query) {
    List<String> keywords = query.split(" ").toList();
    List<String> caseSearch = [];

    for (int i = 0; i < keywords.length; i++)
      for (int j = 0; j < keywords[i].length; j++) {
        caseSearch.add(keywords[i].substring(0, j + 1));
      }

    for (int i = keywords[0].length; i < query.length; i++) {
      caseSearch.add(query.substring(0, i + 1));
    }
    return caseSearch;
  }

  showLoading() {
    Get.defaultDialog(
      radius: padding / 2,
      titlePadding: const EdgeInsets.all(10),
      contentPadding: const EdgeInsets.all(10),
      barrierDismissible: false,
      title: 'Please wait...',
      content: LoadingData(),
    );
  }

  showInfoDialog(String title, String description, bool closeScreen) {
    Get.defaultDialog(
      radius: padding / 2,
      titlePadding: const EdgeInsets.all(padding),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      barrierDismissible: false,
      title: title,
      content: Text(description),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
              if (closeScreen) Get.back();
            },
            child: const Text('OK'))
      ],
    );
  }

  showUnlockDialog(num amount, String feature, String description) {
    Get.defaultDialog(
      radius: padding / 2,
      titlePadding: const EdgeInsets.all(padding),
      //contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      barrierDismissible: false,
      title: 'Unlock the feature?',
      content: Text('$description\n\nThis feature is locked. Would you like to unlock this feature?'),
      actions: [
        CustomButton(
            text: 'Yes',
            color: primaryColor,
            function: () async {
              String? url;
              Get.back();
              final userController = Get.find<UserController>();
              String email = userController.currentUser.value.email!;
              switch (feature) {
                case VIEW_PRODUCT:
                  url = "https://payment.eatoutroundabout.co.uk?email=$email";
                  break;
                case VIEW_OFFER:
                  url = "https://yum.eatoutroundabout.co.uk/B2B-Offers?email=$email";
                  break;
                case VIEW_MEMBERSHIP:
                  url = "https://payment.eatoutroundabout.co.uk?email=$email";
                  break;
              }
              await openLink(url!);
            }),
        CustomButton(
          text: 'No',
          color: Colors.grey,
          function: () => Get.back(),
        ),
      ],
    );
  }

  logout() {
    Get.defaultDialog(
      radius: padding / 2,
      title: 'Logout',
      content: const Text('Are you sure you want to logout?', textScaleFactor: 1),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel', textScaleFactor: 1)),
        TextButton(
            onPressed: () async {
              final u.FirebaseAuth auth = u.FirebaseAuth.instance;
              await auth.signOut();
              Get.back();
              Get.off(() => Login());
            },
            child: const Text('Logout', textScaleFactor: 1)),
      ],
    );
  }

  showConfirmationDialog({String? title, String? contentText, String? confirmText, String? cancelText, Function? cancel, Function? confirm}) {
    Get.defaultDialog(
      radius: padding / 2,
      title: title!,
      content: Text(contentText!),
      actions: [
        CustomButton(
            text: confirmText ?? 'Yes',
            color: primaryColor,
            function: () {
              if (confirm == null)
                Get.back();
              else
                confirm();
            }),
        CustomButton(
            text: cancelText ?? 'No',
            color: Colors.grey,
            function: () {
              if (cancel == null)
                Get.back();
              else
                cancel();
            }),
      ],
    );
  }

  goBackDialog() {
    Get.defaultDialog(
      radius: padding / 2,
      contentPadding: const EdgeInsets.all(padding),
      title: 'You will lose the progress',
      content: Text('Do you want to cancel and go back without saving?', textAlign: TextAlign.center),
      confirm: CustomButton(text: 'No', color: Colors.grey, function: () => Get.back()),
      cancel: CustomButton(
        text: 'Yes',
        color: primaryColor,
        function: () {
          Get.back();
          Get.back();
        },
      ),
    );
    return;
  }

  showTipsDialog() async {
    if (await Preferences.getTipsPopupUser())
      Get.defaultDialog(
        radius: padding / 2,
        title: 'Send Tips',
        content: Text('Would you like to receive tips and ideas to help your local economy from Eat Out Round About?'),
        actions: [
          TextButton(
              onPressed: () async {
                Get.back();
                await Preferences.setTipsPopupUser(false);
                await firestoreService.updateUser({'showTips': true});
              },
              child: Text('YES')),
          TextButton(
              onPressed: () async {
                Get.back();
                await Preferences.setTipsPopupUser(false);
                await firestoreService.updateUser({'showTips': false});
              },
              child: Text('NO')),
        ],
      );
  }

  showPromoCodeDialog() {
    TextEditingController promoCodeTEC = TextEditingController();
    Get.back();
    Get.defaultDialog(
      radius: padding / 2,
      contentPadding: const EdgeInsets.all(padding),
      title: 'Claim Voucher',
      content: CustomTextField(
        label: '',
        hint: 'Enter Promo Code',
        labelColor: greenColor,
        controller: promoCodeTEC,
        maxLines: 1,
        validate: true,
        isEmail: false,
        textInputType: TextInputType.text,
      ),
      actions: [
        CustomButton(
          function: () async {
            final voucherService = Get.find<FirestoreService>();
            final userController = Get.find<UserController>();

            if (promoCodeTEC.text.isEmpty) {
              showRedAlert('Please enter a valid promo code');
              return;
            }
            Get.back();
            showLoading();
            String voucherID = '';
            QuerySnapshot querySnapshot = await voucherService.getVoucherByPromoCode(promoCodeTEC.text);
            if (querySnapshot.docs.isEmpty) {
              showRedAlert('Invalid Promo Code');
              voucherID = '';
              Get.back();
              return;
            } else {
              Voucher? voucher = querySnapshot.docs[0].data() as Voucher;
              voucherID = voucher.voucherID!;
              Map voucherMap = {
                'voucherID': voucherID,
                'userID': userController.currentUser.value.userID,
                'latitude': userController.myLatitude,
                'longitude': userController.myLongitude,
                'promoCode': promoCodeTEC.text.trim(),
              };
              await cloudFunction(
                  functionName: 'addVoucher',
                  parameters: voucherMap,
                  action: () {
                    Get.back();
                  });
            }
          },
          text: 'Claim',
          color: primaryColor,
        ),
        CustomButton(function: () => Get.back(), text: 'Cancel', color: Colors.grey),
      ],
    );
  }

  showSendCertificateDialog(String venue) {
    Get.defaultDialog(
      radius: padding / 2,
      title: 'Send the Certificate',
      content: Text('Would you like to send the Good-to-go certificate now?\n\nYou can also mail us the certificate at support@eatoutroundabout.co.uk'),
      actions: [
        TextButton(
            onPressed: () async {
              Get.back();
              String url = 'mailto:support@eatoutroundabout.co.uk?subject=Good-To-Go Certificate&body=PFA the certificate for $venue';
              openLink(url);
            },
            child: Text('Send Now')),
        TextButton(
            onPressed: () async {
              Get.back();
            },
            child: Text('Not Now')),
      ],
    );
  }

  showLogoutDialog() {
    Get.defaultDialog(
      radius: padding / 2,
      title: 'Logout',
      content: Text('Are you sure you want to logout?', textScaleFactor: 1),
      actions: [
        CustomButton(
            text: 'Logout',
            function: () async {
              final authService = Get.find<AuthService>();
              await authService.signOut();
              Get.back();
              Get.off(() => Login());
            }),
        CustomButton(
          text: 'Cancel',
          color: Colors.grey,
          function: () => Get.back(),
        ),
      ],
    );
  }

  showPersonaliseDialog(String mobile) {
    Get.defaultDialog(
      radius: padding / 2,
      title: 'Personalise your experience?',
      content: Text('Do you want to personalise your experience?', textScaleFactor: 1),
      actions: [
        CustomButton(text: 'Yes', function: () => Get.offAll(() => PrivacySettings(isSetup: true))),
        CustomButton(
          text: 'Skip',
          color: Colors.grey,
          function: () async {
            Get.offAll(() => HomePage());
          },
        ),
      ],
    );
  }

  showReportDialog(String userID) {
    Get.defaultDialog(
      radius: padding / 2,
      title: 'Report user',
      content: Column(
        children: [
          Text('Do you want to report this user?', textScaleFactor: 1),
          SizedBox(height: 15),
          CustomButton(
              text: 'Report Spam',
              function: () {
                Get.back();
                showGreenAlert('User has been reported. Appropriate action will be taken in case of suspicious activity.');
              }),
          SizedBox(height: 5),
          CustomButton(
              text: 'Report False Identity',
              function: () {
                Get.back();
                showGreenAlert('User has been reported. Appropriate action will be taken in case of suspicious activity.');
              }),
          SizedBox(height: 5),
          CustomButton(
              text: 'Block',
              color: redColor,
              function: () {
                Get.back();
                showGreenAlert('User has been reported and will be blocked soon. Appropriate action will be taken in case of suspicious activity.');
              }),
          SizedBox(height: 5),
          CustomButton(
            text: 'Cancel',
            color: Colors.grey,
            function: () async {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  showBadgeEarnedDialog(BuildContext context, int i, var _controller) {
    List badgeTitles = [
      '£500 Contributed',
      '£500 Saved',
      '15 Bid Visits',
      '50 Charity Visits',
      '50 Culture Visits',
      '50 Family Visits',
      'First Voucher Claim',
      '25 High Street Visits',
      '25 Local Tourist Visits',
      '25 Loyal Venue Visits',
      'Rated 10 Venues',
      '50 Remote Tourist Visits',
      'Shared App',
      '10 Sport Visits',
      '25 Vouchers Claimed',
      '25 Vouchers Redeemed',
      '50 Work Venue Visits',
    ];

    // List badgeDescription = [
    //   'Every £ you spend in the local economy circulates and multiplies.',
    //   'You save money each time you redeem a voucher and help the local economy',
    //   'Businesses club together to make a BID area a great place to live, work and do business. Your support dining in these areas supports the cause.',
    //   'Charities and social enterprises make a difference for social causes. Every £ here means you made a bigger social impact. ',
    //   'Where there is culture there are thriving places. By supporting cultural locations you are helping build better perceptions of the place. ',
    //   'Family time is important for local communities. Supporting family friendly circle helps children to have great spaces to develop confide, learn and grow. ',
    //   'Congratulations. You took the first step to helping your local economy. ',
    //   'The purpose of the high street has changed over recent years and is grateful  for your support as it redefines itself.',
    //   'Most people do not actively think to spend  leisure time in the place they live to boost the local economy.  Being local from time to time makes a huge difference to the local economy and is good for the environment! ',
    //   'Local circle value your custom and repeat custom is their lifeblood.',
    //   'Thanks for helping others to make great choices in where they dine out and boost the economy. ',
    //   'Visiting places from outside the area where you helps to take new money into that area. ',
    //   'We appreciate you helping to spread the word.',
    //   'Sport plays a vital role in contribution to local economies and community. ',
    //   'Each voucher claim brings at least £5 into circulation in the local economy!',
    //   'Each time you redeem a voucher the contribution into the local economy multiplies!',
    //   'Spending money in the place where you work means that money earned in the local area can recirculate and grow. When everyone plays their part they can create a thriving work location.'
    // ];
    List badgeImages = [
      'assets/images/contribution.png',
      'assets/images/saved.png',
      'assets/images/.png',
      'assets/images/charity.png',
      'assets/images/culture.png',
      'assets/images/family.png',
      'assets/images/first_time.png',
      'assets/images/high_street.png',
      'assets/images/local_tourist.png',
      'assets/images/loyalty.png',
      'assets/images/.png',
      'assets/images/tourist.png',
      'assets/images/share.png',
      'assets/images/sport.png',
      'assets/images/.png',
      'assets/images/.png',
      'assets/images/work.png',
    ];
    _controller.play();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding / 2)),
        title: Center(child: Text('Congratulations! \nYou earned a badge!', textAlign: TextAlign.center)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConfettiWidget(
              blastDirectionality: BlastDirectionality.explosive,
              confettiController: _controller,
              particleDrag: 0.05,
              emissionFrequency: 0.01,
              numberOfParticles: 20,
              gravity: 0.05,
              shouldLoop: false,
              colors: [
                Colors.green,
                Colors.red,
                Colors.yellow,
                Colors.blue,
              ],
            ),
            Image.asset(badgeImages[i], width: 300, height: 300),
            Text(badgeTitles[i], textScaleFactor: 1.25),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('OK')),
        ],
      ),
    );
  }
}
