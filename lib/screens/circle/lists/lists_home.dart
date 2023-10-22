import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListsHome extends StatelessWidget {
  final userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(padding),
      child: Column(
        children: [
          Expanded(child: Container()),
          if (userController.currentUser.value.accountID != null) CustomButton(text: 'Add a new List'),
        ],
      ),
    );
  }
}
