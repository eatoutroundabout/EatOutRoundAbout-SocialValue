import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/community_members_model.dart';
import 'package:eatoutroundabout/models/community_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:eatoutroundabout/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class CommunityRequests extends StatefulWidget {
  final Community? community;

  CommunityRequests({this.community});

  @override
  _CommunityRequestsState createState() => _CommunityRequestsState();
}

class _CommunityRequestsState extends State<CommunityRequests> {
  final communityService = Get.find<FirestoreService>();
  PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();
  final UniqueKey key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: communityService.getCommunityRequests(widget.community!),
        builder: (context, AsyncSnapshot<QuerySnapshot<CommunityMember>> snapshot) {
          if (snapshot.hasData)
            return snapshot.data!.docs.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, i) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(padding),
                          child: Column(
                            children: [
                              Text('You have a community join request from:', style: TextStyle(color: Colors.grey)),
                              UserTile(userID: snapshot.data!.docs[i].data().userID),
                              Row(
                                children: [
                                  Expanded(child: TextButton(child: Text('Reject', style: TextStyle(color: redColor)), onPressed: () => communityService.rejectMember(widget.community!, snapshot.data!.docs[i].data().userID!))),
                                  Expanded(child: TextButton(child: Text('Accept'), onPressed: () => communityService.approveMember(widget.community!, snapshot.data!.docs[i].data().userID!))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                : EmptyBox(text: 'No pending requests');
          else
            return LoadingData();
        });
  }

  page() {
    return RefreshIndicator(
      onRefresh: () async => refreshChangeListener.refreshed = true,
      child: PaginateFirestore(
        key: key,
        itemBuilderType: PaginateBuilderType.listView,
        onEmpty: EmptyBox(text: 'No more requests'),
        itemBuilder: (context, docSnapshot, index) {
          CommunityMember community = docSnapshot[index].data() as CommunityMember;
          return Row(
            children: [
              Expanded(
                child: UserTile(userID: community.userID),
              ),
              IconButton(icon: Icon(Icons.close), onPressed: () => communityService.rejectMember(widget.community!, community.userID!)),
              IconButton(icon: Icon(Icons.check), onPressed: () => communityService.approveMember(widget.community!, community.userID!)),
            ],
          );
        },
        listeners: [refreshChangeListener],
        query: communityService.getCommunityRequestsQuery(widget.community!),
      ),
    );
  }
}
