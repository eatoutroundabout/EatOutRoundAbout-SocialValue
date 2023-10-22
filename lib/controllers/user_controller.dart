import 'package:eatoutroundabout/models/account_model.dart';
import 'package:eatoutroundabout/models/users_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  Rx<User> currentUser = User().obs;
  Rx<Account> currentAccount = Account().obs;

  isPartnerUser() {
    final userController = Get.find<UserController>();
    return userController.currentAccount.value != null &&
        userController.currentAccount.value.isPartner!;
  }

  isAccountAdmin() {
    final userController = Get.find<UserController>();
    return userController.currentUser.value.accountID != null;
  }

  isAccountAdminForVenueOrBusiness(String accountID) {
    final userController = Get.find<UserController>();
    return userController.currentUser.value.accountID == accountID;
  }

  isVenueAdmin() {
    final userController = Get.find<UserController>();
    return userController.currentUser.value.venueAdmin!.isNotEmpty;
  }

  isBusinessAdmin() {
    final userController = Get.find<UserController>();
    return userController.currentUser.value.businessProfileAdmin!.isNotEmpty;
  }

  isVenueStaff() {
    final userController = Get.find<UserController>();
    return userController.currentUser.value.venueStaff!.isNotEmpty;
  }

  isBusinessStaff() {
    final userController = Get.find<UserController>();
    return userController.currentUser.value.businessProfileStaff!.isNotEmpty;
  }

  double myLatitude = 51.509865;
  double myLongitude = -0.118092;
}
