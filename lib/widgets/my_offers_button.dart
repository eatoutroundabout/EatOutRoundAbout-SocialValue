import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/screens/admin/offer/offers_dashboard.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyOffersButton extends StatelessWidget {
  final userController = Get.find<UserController>();
  final utilService = Get.find<UtilService>();
  final BusinessProfile? businessProfile;

  MyOffersButton({this.businessProfile});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      color: blueColor,
      function: () async {
        if (userController.currentAccount.value.offerExpiryDate!.toDate().isBefore(DateTime.now()))
          utilService.showUnlockDialog(
            10,
            VIEW_OFFER,
            'Promote your offer locally and reward business and people for keeping their purchases local.\n\nIncludes Staff benefit suppliers, workplace wellbeing, food & drink, corporate hospitality, celebration parties, local culture, high street, retail and services for hospitality.',
          );
        else
          Get.to(() => OfferDashboard(businessProfile: businessProfile!));
      },
      text: 'Add Business Offers',
      icon: Icon(userController.currentAccount.value.offerExpiryDate!.toDate().isBefore(DateTime.now()) ? Icons.lock_outline : Icons.lock_open, color: userController.currentAccount.value.offerExpiryDate!.toDate().isBefore(DateTime.now()) ? Colors.white38 : Colors.white),
    );
  }
}
