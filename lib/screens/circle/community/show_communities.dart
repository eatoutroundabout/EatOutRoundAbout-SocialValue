import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/community_members_model.dart';
import 'package:eatoutroundabout/screens/circle/community/communities_search.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/community_tile.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ShowCommunities extends StatelessWidget {
  final userController = Get.find<UserController>();
  final communityService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'COMMUNITIES'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(padding),
              child: Column(
                children: [
                  MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                    child: InkWell(
                      onTap: () => Get.to(() => CommunitySearch()),
                      child: Container(
                        height: 45,
                        child: TextFormField(
                          enabled: false,
                          textInputAction: TextInputAction.search,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            hintText: 'Search',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xff6E7FAA),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      return PaginateFirestore(
                        padding: const EdgeInsets.only(top: 20),
                        shrinkWrap: true,
                        isLive: true,
                        itemBuilder: (context, docSnapshotList, index) {
                          CommunityMember community = docSnapshotList[index].data() as CommunityMember;
                          return CommunityTile(communityID: community.communityID, showMembers: false);
                        },
                        query: communityService.getUserCommunitiesQuery(null!),
                        onEmpty: Padding(
                          padding: EdgeInsets.only(bottom: Get.height / 2 - 100),
                          child: EmptyBox(text: 'You are not a part of any community yet.'),
                        ),
                        itemBuilderType: PaginateBuilderType.listView,
                        initialLoader: LoadingData(),
                        bottomLoader: LoadingData(),
                      );
                    }),
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
