import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/community_model.dart';
import 'package:eatoutroundabout/screens/circle/community/community_members.dart';
import 'package:eatoutroundabout/screens/circle/community/view_community.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityTile extends StatelessWidget {
  final communityID;
  final bool? showMembers;
  final communityService = Get.find<FirestoreService>();

  CommunityTile({this.communityID, this.showMembers});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: communityService.getCommunityByCommunityIDStream(communityID),
      builder: (context, AsyncSnapshot<DocumentSnapshot<Community>> snapshot) {
        if (snapshot.hasData) {
          Community? community = snapshot.data!.data();
          return Card(
            child: ListTile(
              onTap: () {
                if (showMembers!)
                  Get.to(() => CommunityMembers(community: community!));
                else
                  Get.to(() => ViewCommunity(community: community!));
              },
              leading: CachedImage(url: community!.communityImage, height: 40, roundedCorners: true),
              title: Text(community.communityName!, maxLines: 1, textScaleFactor: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(community.membersCount.toString() + ' members', maxLines: 1, textScaleFactor: 0.8, style: TextStyle(height: 1, color: Colors.grey)),
              trailing: Icon(Icons.keyboard_arrow_right_rounded),
            ),
          );
        } else
          return Container(height: 56);
      },
    );
  }
}
