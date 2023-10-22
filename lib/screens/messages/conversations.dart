import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/conversation_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/conversation_item.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Conversations extends StatefulWidget {
  @override
  _ConversationsState createState() => _ConversationsState();
}

class _ConversationsState extends State<Conversations> {
  TextEditingController searchTEC = new TextEditingController();
  bool isSearching = false;
  final messageService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();

  @override
  void initState() {
    searchTEC.addListener(() {
      if (searchTEC.text.length > 2)
        isSearching = true;
      else
        isSearching = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15)),
      body: Column(
        children: [
          Heading(title: 'CONVERSATIONS'),
          Padding(
            padding: const EdgeInsets.all(padding),
            child: CustomTextField(label: '', hint: 'Search'),
          ),
          Expanded(
            child: StreamBuilder(
              stream: messageService.getConversations(),
              builder: (context, AsyncSnapshot<QuerySnapshot<Conversation>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    return Column(
                      children: [
                        Expanded(
                          child: snapshot.data!.docs.isNotEmpty
                              ? ListView.separated(
                                  padding: const EdgeInsets.all(padding / 2),
                                  itemCount: snapshot.data!.docs.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) {
                                    return Column(
                                      children: [
                                        ConversationItem(conversation: snapshot.data!.docs[i].data()),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (BuildContext context, int index) {
                                    return Divider(height: 1);
                                  },
                                )
                              : EmptyBox(text: 'No conversations to show'),
                        ),
                      ],
                    );
                  } else {
                    return EmptyBox(text: 'No messages');
                  }
                } else {
                  return LoadingData();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserShortcut(Conversation conversation) {
    conversation.users!.remove(userController.currentUser.value.userID);
    return conversation.lastMessage != '' ? userShortcut(userID: conversation.users![0]) : Container();
  }

  showUserShortcuts(snapshot) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(left: 10),
      width: double.infinity,
      child: ListView.builder(
        itemCount: snapshot.data.docs.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return buildUserShortcut(Conversation.fromDocument(snapshot.data.docs[index]));
        },
      ),
    );
  }

  userShortcut({String? userID}) {
    return Padding(
      padding: const EdgeInsets.all(padding),
      child: CachedImage(url: 'profile', height: 50, circular: true),
    );
  }
}
