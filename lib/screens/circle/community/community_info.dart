import 'dart:io';

import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/community_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/storage_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/join_group_button.dart';
import 'package:eatoutroundabout/widgets/user_shortcut.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

class CommunityInfo extends StatefulWidget {
  final Community? community;

  CommunityInfo({this.community});

  @override
  _CommunityInfoState createState() => _CommunityInfoState();
}

class _CommunityInfoState extends State<CommunityInfo> {
  final userController = Get.find<UserController>();
  final storageService = Get.find<StorageService>();
  final utilService = Get.find<UtilService>();
  final communityService = Get.find<FirestoreService>();
  String? rules;
  String? description;
  String? communityName;
  RxString communityImage = ''.obs;
  bool? public;

  @override
  void initState() {
    super.initState();
    rules = widget.community!.communityRules;
    description = widget.community!.communityDescription;
    communityName = widget.community!.communityName;
    communityImage.value = widget.community!.communityImage!;
    public = widget.community!.public;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: Get.height * 0.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(padding / 2),
                        color: Colors.grey.shade300,
                      ),
                      child: Obx(() {
                        return CachedImage(
                          height: Get.width,
                          url: communityImage.value,
                          roundedCorners: true,
                        );
                      }),
                    ),
                    Visibility(
                      visible: widget.community!.admin!.contains(userController.currentUser.value.userID),
                      child: Container(
                        height: Get.height * 0.25 - 10,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(right: 20),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () async {
                              File image = await storageService.pickImage(aspectRatio: CropAspectRatioPreset.ratio4x3);
                              if (image.path != '') {
                                utilService.showLoading();
                                communityImage.value = await storageService.uploadImage(image);
                                await communityService.editCommunityInfo('communityImage', communityImage.value, widget.community!.communityID!);
                                Get.back();
                              }
                            },
                            child: CircleAvatar(
                                backgroundColor: primaryColor,
                                radius: 15,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 15,
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Card(
                  child: ListTile(
                    //onTap: () => Get.to(() => CommunityMembers(community: widget.community)),
                    title: Text(
                      communityName!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textScaleFactor: 1,
                    ),
                    subtitle: Text(
                      widget.community!.membersCount.toString() + ' members',
                      style: TextStyle(height: 1, color: Colors.grey),
                      textScaleFactor: 0.9,
                    ),
                    trailing: Visibility(
                      visible: widget.community!.admin!.contains(userController.currentUser.value.userID),
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: IconButton(icon: Icon(Icons.edit, color: Colors.black), onPressed: () => editCommunityName()),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.community!.admin!.contains(userController.currentUser.value.userID),
                  child: Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 15, right: 5),
                      title: Text('Make community public', textScaleFactor: 1),
                      trailing: Switch(
                        onChanged: (val) async {
                          await communityService.editCommunityInfo('public', val, widget.community!.communityID!);
                          setState(() {
                            public = val;
                          });
                        },
                        value: public!,
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Admins',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textScaleFactor: 1,
                        ),
                      ),
                      Container(
                        height: 95,
                        child: ListView.builder(
                          padding: EdgeInsets.only(left: 15, bottom: 15),
                          itemCount: widget.community!.admin!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) {
                            return UserShortcut(userID: widget.community!.admin![i], isDark: true);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          'Description',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textScaleFactor: 1,
                        ),
                        trailing: Visibility(
                          visible: widget.community!.admin!.contains(userController.currentUser.value.userID),
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: IconButton(icon: Icon(Icons.edit, color: Colors.black), onPressed: () => edit(false)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, left: 15),
                        child: Text(description!, textScaleFactor: 0.9, style: TextStyle(fontStyle: FontStyle.italic)),
                      ),
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          'Community Guidelines',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textScaleFactor: 1,
                        ),
                        trailing: Visibility(
                          visible: widget.community!.admin!.contains(userController.currentUser.value.userID),
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: IconButton(icon: Icon(Icons.edit, color: Colors.black), onPressed: () => edit(true)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, left: 15),
                        child: Text(rules!, textScaleFactor: 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        JoinCommunityButton(community: widget.community),
      ],
    );
  }

  edit(bool isEditingCommunityRules) {
    TextEditingController controllerText = TextEditingController();
    controllerText.text = isEditingCommunityRules ? rules! : description!;
    Get.defaultDialog(
      radius: padding / 2,
      title: isEditingCommunityRules ? "Community Rules" : "Community Description",
      content: CustomTextField(controller: controllerText, hint: 'Enter here', label: '', maxLines: 5),
      actions: [
        CustomButton(
          color: primaryColor,
          function: () async {
            if (controllerText.text.isNotEmpty) {
              if (isEditingCommunityRules) {
                rules = controllerText.text;
                await communityService.editCommunityInfo('communityRules', rules, widget.community!.communityID!);
              } else {
                description = controllerText.text;
                await communityService.editCommunityInfo('communityDescription', description, widget.community!.communityID!);
              }
              setState(() {});
              Get.back();
            } else
              showRedAlert('Please enter the ' + (isEditingCommunityRules ? 'rules' : 'description'));
          },
          text: 'Save',
        ),
        CustomButton(function: () => Get.back(), text: 'Cancel', color: Colors.grey),
      ],
    );
  }

  editCommunityName() {
    TextEditingController controllerText = TextEditingController();
    controllerText.text = communityName!;
    Get.defaultDialog(
      radius: padding / 2,
      title: 'Community Name',
      content: CustomTextField(controller: controllerText, hint: 'Enter name', label: ''),
      actions: [
        CustomButton(
          color: primaryColor,
          function: () async {
            if (controllerText.text.isNotEmpty) {
              communityName = controllerText.text;
              await communityService.editCommunityInfo('communityName', communityName, widget.community!.communityID!);
              await communityService.editCommunityInfo('nameSearch', utilService.generateCaseSearch(communityName!.trim().toLowerCase()), widget.community!.communityID!);

              setState(() {});
              Get.back();
            } else
              showRedAlert('Please enter a community name');
          },
          text: 'Save',
        ),
        CustomButton(function: () => Get.back(), text: 'Cancel', color: Colors.grey),
      ],
    );
  }
}
