import 'package:eatoutroundabout/models/community_members_model.dart';
import 'package:eatoutroundabout/models/community_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:eatoutroundabout/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class CommunityMembers extends StatefulWidget {
  final Community? community;

  CommunityMembers({this.community});

  @override
  _CommunityMembersState createState() => _CommunityMembersState();
}

class _CommunityMembersState extends State<CommunityMembers> {
  final communityService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return PaginateFirestore(
      isLive: true,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      itemBuilder: (context, docSnapshot, index) {
        CommunityMember communityMember = docSnapshot[index].data() as CommunityMember;
        return UserTile(userID: communityMember.userID);
      },
//      itemBuilder: (context, docSnapshot, index) => CommunityUserTile(community: widget.community, userID: CommunityMember.fromDocument(docSnapshot[index]).userID),
      query: communityService.getCommunityMembersQuery(widget.community!),
      onEmpty: Padding(
        padding: EdgeInsets.only(bottom: Get.height / 2 - 100),
        child: EmptyBox(text: 'No members yet'),
      ),
      itemBuilderType: PaginateBuilderType.listView,
      initialLoader: LoadingData(),
      bottomLoader: LoadingData(),
    );
  }
}
