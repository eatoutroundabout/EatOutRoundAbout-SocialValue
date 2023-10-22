import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/users_model.dart' as u;
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/utils/preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  final userController = Get.find<UserController>();
  final firestoreService = Get.find<FirestoreService>();

  signOut() async {
    await Preferences.setUser('');
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
  }

  signUp(u.User user, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user.email!, password: password);
      await cloudFunction(
          functionName: 'appUserRegistration',
          parameters: {
            'userID': Uuid().v1(),
            'firstName': user.firstName,
            'lastName': user.lastName,
            'livePostcodeDocId': user.livePostcodeDocId,
            'email': user.email,
            'mobile': user.mobile,
            'employerName': null,
            'employerID': null,
            'niNumber': '',
            'workPostcodeDocId': '',
            'usedPromoCodes': [user.usedPromoCodes![0]],
            'usedSignUpCode': user.usedPromoCodes![0].isEmpty ? false : true,
            'acceptAppPrivacyPolicy': true,
            'acceptAppTermsAndConditions': true,
            'promoCode': user.usedPromoCodes![0],
          },
          action: () {});
    } on FirebaseAuthException catch (e) {
      Get.back();
      showRedAlert(e.message!);
    } catch (e) {
      print(e);
      Get.back();
      showRedAlert('Something went wrong');
    }
  }

  void changePassword(String password) async {
    //Create an instance of the current user.
    User? user = FirebaseAuth.instance.currentUser;

    //Pass in the password to updatePassword.
    user!.updatePassword(password).then((_) {
      Get.back();
      showGreenAlert('Password changed');
    }).catchError((error) {
      Get.back();
      showRedAlert('Something went wrong. Please login again and try again');
      print(error);
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }

  resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    showGreenAlert('Password reset instructions sent to your email');
  }
}
