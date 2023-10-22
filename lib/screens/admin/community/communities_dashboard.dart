import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/models/community_members_model.dart';
import 'package:eatoutroundabout/models/community_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/community_tile.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:uuid/uuid.dart';

class CommunitiesDashboard extends StatelessWidget {
  final BusinessProfile? businessProfile;

  CommunitiesDashboard({this.businessProfile});

  final userController = Get.find<UserController>();
  final communityService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'MY COMMUNITIES'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(padding),
              child: Column(
                children: [
                  CustomButton(
                    text: 'Add a new Community',
                    function: () => add(),
                  ),
                  Expanded(
                    child: PaginateFirestore(
                      padding: const EdgeInsets.only(top: 20),
                      shrinkWrap: true,
                      isLive: true,
                      itemBuilder: (context, docSnapshotList, index) {
                        Community community = docSnapshotList[index]!.data() as Community;
                        return CommunityTile(communityID: community.communityID, showMembers: false);
                      },
                      query: communityService.getMyCommunitiesQuery(businessProfile!.businessProfileID!),
                      onEmpty: Padding(
                        padding: EdgeInsets.only(bottom: Get.height / 2 - 100),
                        child: EmptyBox(text: 'Get started by adding a community'),
                      ),
                      itemBuilderType: PaginateBuilderType.listView,
                      initialLoader: LoadingData(),
                      bottomLoader: LoadingData(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  add() {
    TextEditingController communityNameTEC = TextEditingController();
    return Get.defaultDialog(
      radius: padding / 2,
      title: 'Create a new community',
      content: CustomTextField(controller: communityNameTEC, hint: 'Enter name', label: ''),
      actions: [
        CustomButton(
          color: primaryColor,
          function: () async {
            if (communityNameTEC.text.isNotEmpty) {
              String communityID = Uuid().v1();
              Get.back();
              final utilService = Get.find<UtilService>();
              utilService.showLoading();
              await communityService.createCommunity(
                Community(
                  businessProfileID: businessProfile!.businessProfileID,
                  communityName: communityNameTEC.text,
                  communityID: communityID,
                  admin: [userController.currentUser.value.userID],
                  communityIcon: 'community',
                  membersCount: 1,
                  createdDateTime: Timestamp.now().millisecondsSinceEpoch,
                  nameSearch: utilService.generateCaseSearch(communityNameTEC.text.trim().toLowerCase()),
                  public: true,
                ),
              );

              await communityService.addToCommunity(CommunityMember(
                communityID: communityID,
                userID: userController.currentUser.value.userID,
                approved: true,
                createdDateTime: Timestamp.now().millisecondsSinceEpoch,
              ));

              Get.back();
              showGreenAlert('Community Created');
            } else
              showRedAlert('Please enter the Community name');
          },
          text: 'Create',
        ),
        CustomButton(function: () => Get.back(), text: 'Cancel', color: Colors.grey),
      ],
    );
  }
}
