import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/screens/admin/product/products_dashboard.dart';
import 'package:eatoutroundabout/screens/auth/section_splash.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProductsButton extends StatelessWidget {
  MyProductsButton({this.businessProfile});

  final BusinessProfile? businessProfile;
  final userController = Get.find<UserController>();
  final utilService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      color: purpleColor,
      function: () => Get.to(
        () => SectionSplash(
          title: 'List a Product',
          description: 'We help and incentivise our venues to source with local suppliers. \n\nPromote your locally produced products to local hospitality and their customers!',
          image: 'assets/images/products_block.png',
          function: () async {
            if (userController.currentAccount.value.productExpiryDate!.toDate().isBefore(DateTime.now()))
              utilService.showUnlockDialog(
                10,
                VIEW_PRODUCT,
                'We help and incentivise our venues to source with local suppliers.  \n\nPromote your locally produced products to local hospitality',
              );
            else
              Get.off(() => ProductDashboard(businessProfile: businessProfile!));
          },
        ),
      ),
      text: 'Local supply chains',
      icon: Icon(userController.currentAccount.value.productExpiryDate!.toDate().isBefore(DateTime.now()) ? Icons.lock_outline : Icons.lock_open, color: userController.currentAccount.value.productExpiryDate!.toDate().isBefore(DateTime.now()) ? Colors.white38 : Colors.white),
    );
  }
}
