import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/users_model.dart';
import 'package:eatoutroundabout/screens/profile/view_profile.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/notification_service.dart';
import 'package:eatoutroundabout/services/storage_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:eatoutroundabout/widgets/message_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Chats extends StatefulWidget {
  final User? user;
  final chatRoomID;

  Chats({this.chatRoomID, this.user});

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  Rx<TextEditingController> messageTEC = TextEditingController().obs;
  final messageService = Get.find<FirestoreService>();
  final notificationService = Get.find<NotificationService>();
  final userController = Get.find<UserController>();
  final storageService = Get.find<StorageService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
        widget.user!.firstName! + ' ' + widget.user!.lastName!,
        textScaleFactor: 1.25,
        style: TextStyle(color: Colors.white),
      )),
      body: Column(
        children: <Widget>[
          InkWell(
            onTap: () => Get.to(() => ViewProfile(userID: widget.user!.userID)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(padding / 1.5),
              color: Colors.grey.shade300,
              alignment: Alignment.center,
              child: Text('View Profile >'),
            ),
          ),
          Divider(height: 1),
          Expanded(
            child: StreamBuilder(
              stream: messageService.getMessages(widget.chatRoomID),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                return snapshot.hasData
                    ? snapshot.data!.docs.isNotEmpty
                        ? ListView.builder(
                            reverse: true,
                            padding: const EdgeInsets.fromLTRB(padding, 0, padding, padding),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              index = snapshot.data!.docs.length - 1 - index;
                              Map<String, dynamic> doc = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                              return MessageBox(
                                docID: snapshot.data!.docs[index].id,
                                time: doc['time'],
                                message: doc["message"],
                                imageURL: doc["imageURL"],
                                isSent: userController.currentUser.value.userID == doc["sentBy"],
                              );
                            })
                        : EmptyBox(text: 'Start a conversation')
                    : LoadingData();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Obx(() {
              return TextFormField(
                controller: messageTEC.value,
                style: TextStyle(color: primaryColor),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.attach_file, color: primaryColor),
                    onPressed: () async {
                      File image = await storageService.pickImage(crop: false);
                      if (image != null) {
                        showYellowAlert('Uploading image');
                        String profilePhotoURL = await storageService.uploadImage(image);
                        if (profilePhotoURL != null) await addImageMsg(profilePhotoURL);
                      }
                    },
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send, color: primaryColor),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      addMsg();
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  addMsg() async {
    print(widget.chatRoomID);
    print(userController.currentUser.value.userID);
    if (messageTEC.value.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        'chatRoomID': widget.chatRoomID,
        "sentBy": userController.currentUser.value.userID,
        "message": messageTEC.value.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      messageService.addMessage(widget.chatRoomID, chatMessageMap);
      notificationService.sendNotification(
        parameters: {
          'chatRoomID': widget.chatRoomID,
        },
        body: messageTEC.value.text,
        receiverUserID: widget.user!.userID,
        type: 'message',
      );
      messageTEC.value.clear();
    }
  }

  addImageMsg(photoURL) async {
    Map<String, dynamic> chatMessageMap = {
      'chatRoomID': widget.chatRoomID,
      "sentBy": userController.currentUser.value.userID,
      "message": '▶ Photo',
      'imageURL': photoURL,
      'time': DateTime.now().millisecondsSinceEpoch,
    };

    messageService.addMessage(widget.chatRoomID, chatMessageMap);
    notificationService.sendNotification(
      parameters: {
        'chatRoomID': widget.chatRoomID,
      },
      body: '▶ Photo',
      receiverUserID: widget.user!.userID,
      type: 'message',
    );
  }
}
