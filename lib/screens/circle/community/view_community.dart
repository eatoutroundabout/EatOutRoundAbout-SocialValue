import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/community_model.dart';
import 'package:eatoutroundabout/screens/circle/community/community_info.dart';
import 'package:eatoutroundabout/screens/circle/community/community_members.dart';
import 'package:eatoutroundabout/screens/circle/community/community_requests.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewCommunity extends StatelessWidget {
  final Community? community;

  ViewCommunity({this.community});

  final userController = Get.find<UserController>();
  final communityService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'VIEW COMMUNITY'),
          Expanded(
            child: DefaultTabController(
              length: community!.admin!.contains(userController.currentUser.value.userID) ? 3 : 2,
              child: Column(
                children: [
                  Container(
                    height: 45,
                    margin: const EdgeInsets.all(padding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade400,
                    ),
                    child: TabBar(
                      labelPadding: EdgeInsets.zero,
                      labelColor: Colors.white,
                      indicatorColor: primaryColor,
                      indicator: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      unselectedLabelColor: primaryColor,
                      isScrollable: false,
                      indicatorSize: TabBarIndicatorSize.tab,
                      //labelStyle: TextStyle(fontSize: 18),
                      tabs: [
                        Text('Info', textScaleFactor: 1),
                        Text('Members', textScaleFactor: 1),
                        if (community!.admin!.contains(userController.currentUser.value.userID)) Text('Requests', textScaleFactor: 1),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        CommunityInfo(community: community!),
                        CommunityMembers(community: community!),
                        if (community!.admin!.contains(userController.currentUser.value.userID)) CommunityRequests(community: community!),
                      ],
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
}
