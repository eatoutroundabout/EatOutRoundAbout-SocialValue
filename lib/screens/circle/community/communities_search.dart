import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/community_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/community_tile.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunitySearch extends StatefulWidget {
  @override
  State<CommunitySearch> createState() => _CommunitySearchState();
}

class _CommunitySearchState extends State<CommunitySearch> {
  final userController = Get.find<UserController>();
  final communityService = Get.find<FirestoreService>();
  String searchQuery = '';
  final key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'SEARCH'),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(padding),
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                    child: TextFormField(
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (val) => searchQuery = val,
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
                // CommunityTile(communityID: '57ca80f0-05d7-11ed-bcdb-b1bb64e95c80', showMembers: false),
                Expanded(
                  child: searchQuery.isNotEmpty
                      ? StreamBuilder<QuerySnapshot>(
                          stream: communityService.searchCommunities(searchQuery.trim().toLowerCase()),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.data!.docs.isNotEmpty
                                  ? ListView.builder(
                                      padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, i) {
                                        Community community = snapshot.data!.docs[i].data() as Community;
                                        return CommunityTile(communityID: community.communityID, showMembers: false);
                                      },
                                    )
                                  : EmptyBox(text: 'No results to show');
                            } else
                              return LoadingData();
                          })
                      : EmptyBox(text: 'Search community name'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
