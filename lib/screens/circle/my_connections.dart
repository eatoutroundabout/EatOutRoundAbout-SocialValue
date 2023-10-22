import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/connection_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyConnections extends StatelessWidget {
  final userController = Get.find<UserController>();
  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'MY CONNECTIONS'),
          Divider(height: 1),
          Expanded(
            child: FutureBuilder(
              future: firestoreService.getUserConnections(userController.currentUser!.value.userID!),
              builder: (context, AsyncSnapshot<DocumentSnapshot<Connection>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    Connection connection = snapshot.data!.data() as Connection;
                    return connection != null
                        ? ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: padding),
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              return UserTile(userID: connection.connections![i]);
                            },
                            separatorBuilder: (context, i) {
                              return Divider(height: 1);
                            },
                            itemCount: connection.connections!.length,
                          )
                        : EmptyBox(text: 'No connections yet.\nStart building up your network');
                  } else {
                    return EmptyBox(text: 'No connections yet.\nStart building up your network');
                  }
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
