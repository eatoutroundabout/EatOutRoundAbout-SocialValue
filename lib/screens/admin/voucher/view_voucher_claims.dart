import 'package:cloud_functions/cloud_functions.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:eatoutroundabout/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewVoucherClaims extends StatefulWidget {
  final String? voucherID;

  ViewVoucherClaims({this.voucherID});

  @override
  State<ViewVoucherClaims> createState() => _ViewVoucherClaimsState();
}

class _ViewVoucherClaimsState extends State<ViewVoucherClaims> {
  HttpsCallableResult? result;
  RxBool isLoading = true.obs;
  List userList = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    HttpsCallableResult? result = await cloudFunctionValueReturn(functionName: 'getClaimedUsers', parameters: {"voucherID": widget.voucherID}, showLoading: false);
    if (result!.data['sucess']) for (int i = 0; i < result!.data['data'].length; i++) userList.add(result.data['data'][i]['userID']);
    isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15)),
      body: Column(
        children: [
          Heading(title: 'VOUCHER CLAIMS', textScaleFactor: 1.75),
          Expanded(
            child: Obx(() {
              return isLoading.value
                  ? LoadingData()
                  : userList.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.all(padding),
                          itemBuilder: (context, i) {
                            return UserTile(userID: userList[i]);
                          },
                          itemCount: userList.length,
                        )
                      : EmptyBox(text: 'No one has claimed this voucher yet');
            }),
          ),
        ],
      ),
    );
  }
}
