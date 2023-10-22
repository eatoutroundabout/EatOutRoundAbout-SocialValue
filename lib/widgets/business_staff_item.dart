import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/users_model.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessStaffItem extends StatelessWidget {
  final User? user;
  final String? businessProfileID;

  BusinessStaffItem({this.user, this.businessProfileID});

  final firestoreService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding / 2)),
      child: ListTile(
        title: Text(user!.firstName! + ' ' + user!.lastName!, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: userController.currentUser.value.userID != user!.userID
            ? IconButton(
                icon: Icon(Icons.remove_circle, color: redColor),
                onPressed: () {
                   Get.defaultDialog(
                    radius: padding / 2,
                    title: 'Remove Staff',
                    content: Text('Are you sure you want to remove ${user!.firstName}?', textScaleFactor: 1),
                    actions: [
                      CustomButton(
                        text: 'Remove',
                        function: () async {
                          Map parameters = {
                            'mobile': user!.mobile,
                            'businessProfileID': businessProfileID,
                          };
                          await cloudFunction(
                              functionName: 'removeBusinessStaff',
                              parameters: parameters,
                              action: () {
                                Get.back();
                                Get.back();
                              });
                        },
                      ),
                      CustomButton(text: 'Cancel', color: Colors.grey, function: () => Get.back()),
                    ],
                  );
                },
              )
            : SizedBox(height: 10, width: 10),
      ),
    );
  }
}
