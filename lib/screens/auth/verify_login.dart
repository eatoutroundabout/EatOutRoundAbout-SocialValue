import 'package:cloud_functions/cloud_functions.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/users_model.dart' as u;
import 'package:eatoutroundabout/screens/home/home_page.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/utils/preferences.dart';
import 'package:eatoutroundabout/widgets/count_down_timer.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:uuid/uuid.dart';

class VerifyLogin extends StatefulWidget {
  final u.User? user;
  final preferences;

  VerifyLogin({this.user, this.preferences});

  @override
  _VerifyLoginState createState() => _VerifyLoginState();
}

class _VerifyLoginState extends State<VerifyLogin> {
  final TextEditingController otpTEC = new TextEditingController();
  String? verificationCode;
  final firestoreService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();
  final utilService = Get.find<UtilService>();

  @override
  void initState() {
    submit(widget.user!.mobile);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(padding),
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                width: Get.width / 2,
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Verify Code', textScaleFactor: 2, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontFamily: 'Font1')),
                  SizedBox(height: 20),
                  Text('Enter Verification Code received on ', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey), textScaleFactor: 1.1),
                  SizedBox(height: 10),
                  Text(widget.user!.mobile!, textAlign: TextAlign.center, style: TextStyle(color: primaryColor), textScaleFactor: 1.2),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Theme(
                      data: ThemeData(),
                      child: PinInputTextField(
                        autoFocus: true,
                        keyboardType: TextInputType.number,
                        pinLength: 6,
                        decoration: BoxLooseDecoration(
                          bgColorBuilder: FixedColorBuilder(Colors.white),
                          strokeWidth: 0.5,
                          strokeColorBuilder: FixedColorBuilder(Colors.grey),
                          textStyle: TextStyle(color: primaryColor, fontSize: MediaQuery.of(context).size.width * 0.06),
                        ),
                        controller: otpTEC,
                      ),
                    ),
                  ),
                  CustomButton(
                    text: 'Verify Code',
                    function: () => signIn(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(padding),
                        child: CountDownTimer(
                          secondsRemaining: 45,
                          whenTimeExpires: () {},
                          countDownTimerStyle: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                          resendCode: () => submit(widget.user!.mobile),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(padding),
                        child: CircleAvatar(
                          backgroundColor: greenColor,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Get.back(),
                          ),
                        ),
                      ),
                      Text('Back'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submit(number) async {
    final PhoneVerificationCompleted verificationSuccess = (AuthCredential credential) {};

    final PhoneVerificationFailed phoneVerificationFailed = (FirebaseAuthException exception) {
      print(exception.message);
      showRedAlert(exception.message!);
    };

    final PhoneCodeSent phoneCodeSent = (String verId, [int? forceCodeResend]) {
      this.verificationCode = verId;
    };

    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
      this.verificationCode = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verificationSuccess,
      verificationFailed: phoneVerificationFailed,
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: autoRetrievalTimeout,
    );
  }

  signIn() async {
    utilService.showLoading();
  //  userController.currentUser.value = null;
    try {
      AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationCode!, smsCode: otpTEC.text);
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      if (widget.user!.email != null) {
        String ipAddress = await getIPAddress();
        HttpsCallableResult? result = await cloudFunctionValueReturn(
          functionName: 'appUserRegistration',
          parameters: {
            'userID': Uuid().v1(),
            'firstName': widget.user!.firstName,
            'lastName': widget.user!.lastName,
            'livePostcodeDocId': widget.user!.livePostcodeDocId,
            'email': widget.user!.email,
            'mobile': widget.user!.mobile,
            'employerName': null,
            'employerID': null,
            'niNumber': '',
            'workPostcodeDocId': '',
            'usedPromoCodes': widget.user!.usedPromoCodes!.isNotEmpty ? widget.user!.usedPromoCodes : [],
            'usedSignUpCode': widget.user!.usedPromoCodes!.isEmpty ? false : true,
            'acceptAppPrivacyPolicy': true,
            'acceptAppTermsAndConditions': true,
            'promoCode': widget.user!.usedPromoCodes!.isNotEmpty ? widget.user!.usedPromoCodes![0] : '',
            'preferences': widget.preferences,
            'ipAddress': ipAddress,
          },
        );
        if (result!.data['success'])
          await proceedToHomePage();
        else {
          await Preferences.setUser('');
          await FirebaseAuth.instance.signOut();
        }
      } else {
        Get.back();
        proceedToHomePage();
      }
    } catch (e) {
      print(' ******************************* ERROR ****************************** ');
      print(e);
      Get.back();
      showRedAlert(e.toString());
    }
  }

  proceedToHomePage() async {
    await firestoreService.setCurrentUserViaMobile(widget.user!.mobile!);
    await firestoreService.getCurrentAccount();
    await Preferences.setUser(userController.currentUser.value.userID!);
    if (widget.user!.email != null)
      utilService.showPersonaliseDialog(widget.user!.mobile!);
    else
      Get.offAll(() => HomePage());
  }
}

getIPAddress() async {
  return await utilService.getIpAddress();
}
