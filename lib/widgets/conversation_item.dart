import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/conversation_model.dart';
import 'package:eatoutroundabout/models/users_model.dart';
import 'package:eatoutroundabout/screens/messages/chats.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationItem extends StatelessWidget {
  final Conversation? conversation;

  ConversationItem({this.conversation});

  final messageService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    List users = conversation!.users!;
    users.remove(userController.currentUser.value.userID);
    String userID = users[0];
    print(userID);
    return conversation!.lastMessage != ''
        ? StreamBuilder(
            stream: messageService.getUserStream(userID),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                User user = snapshot.data!.data() as User;
                return ListTile(
                  onTap: () => Get.to(() => Chats(user: user, chatRoomID: conversation!.chatRoomID)),
                  leading: CachedImage(url: user.photoURL, height: 40, circular: true),
                  title: Row(
                    children: [
                      Expanded(child: Text(user.firstName! + ' ' + user.lastName!, textScaleFactor: 1, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold))),
                      SizedBox(width: 5),
                      Text(
                        timeago.format(DateTime.fromMillisecondsSinceEpoch(conversation!.lastMessageTime!)),
                        style: TextStyle(color: Colors.grey),
                        textScaleFactor: 0.8,
                      ),
                    ],
                  ),
                  subtitle: Text(conversation!.lastMessage!, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey), textScaleFactor: 0.95),
                );
              } else
                return Container();
            },
          )
        : Container();
  }
}
