import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/screens/admin/event/events_dashboard.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyEventsButton extends StatelessWidget {
  final userController = Get.find<UserController>();
  final utilService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return CustomButton(
        color: greenColor,
        function: () async {
          if (userController.isPartnerUser())
            Get.to(() => EventDashboard());
          else {
            if (userController.currentAccount.value.eventExpiryDate
                !.toDate()
                .isBefore(DateTime.now()))
              utilService.showUnlockDialog(
                10,
                VIEW_EVENT,
                'Promote your event to local businesses and add Eat Out vouchers to reward attendance and allow your guests to check-in, network on the app and get a free voucher!',
              );
            else
              Get.to(() => EventDashboard());
          }
        },
        text: 'Create Events',
        icon: userController!.isPartnerUser() ? Icon(
            userController.currentAccount.value.eventExpiryDate
                    !.toDate()
                    .isBefore(DateTime.now())
                ? Icons.lock_outline
                : Icons.lock_open,
            color: userController.currentAccount.value.eventExpiryDate
                    !.toDate()
                    .isBefore(DateTime.now())
                ? Colors.white38
                : Colors.white) : null,
      );
    });
  }
}
