import 'dart:convert';
import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:eatoutroundabout/models/users_model.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:eatoutroundabout/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewUsers extends StatefulWidget {
  final List? users;
  final String? title;

  ViewUsers({this.users, this.title});

  @override
  State<ViewUsers> createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {
  HttpsCallableResult? result;
  RxBool isLoading = true.obs;
  UserList? userList;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    HttpsCallable addVoucherCall = FirebaseFunctions.instanceFor(region: 'europe-west2').httpsCallable('getMultipleUsers');
    result = await addVoucherCall({'userIDs': widget.users});
    log(json.encode(result!.data));
    userList = UserList.fromJson(result!.data);
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Obx(() {
        return isLoading.value
            ? LoadingData()
            : Column(
                children: [
                  Heading(title: widget.title),
                  Expanded(
                    child: userList!.userList!.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.all(padding),
                            itemBuilder: (context, i) {
                              return UserTile(userID: userList!.userList![i].userID);
                            },
                            itemCount: userList!.userList!.length,
                          )
                        : EmptyBox(text: 'Nothing to show'),
                  ),
                ],
              );
      }),
    );
  }
}
