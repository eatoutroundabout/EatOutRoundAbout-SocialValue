import 'dart:convert';
import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

final utilService = Get.find<UtilService>();

cloudFunction({@required String? functionName, @required Map? parameters, @required Function? action}) async {
  utilService.showLoading();
  try {
    HttpsCallable addVoucherCall = FirebaseFunctions.instanceFor(region: 'europe-west2').httpsCallable(functionName!);
    HttpsCallableResult results = await addVoucherCall(parameters);
    Get.back(); //closes loading dialog;
    action!();
    log(json.encode(results.data));
    if (results.data['success'] == false)
      showRedAlert(results.data['message']);
    else
      showGreenAlert(results.data['message']);
    return;
  } catch (e) {
    print('************ ERROR IN FUNCTION $functionName **************');
    print(e);
    Get.back();
    showRedAlert('Something went wrong. Please try again');
    return false;
  }
}

Future<HttpsCallableResult?> cloudFunctionValueReturn({@required String? functionName, @required Map? parameters, bool? showLoading}) async {
  if (showLoading ?? true) utilService.showLoading();
  try {
    HttpsCallable addVoucherCall = FirebaseFunctions.instanceFor(region: 'europe-west2').httpsCallable(functionName!);
    HttpsCallableResult results = await addVoucherCall(parameters);
    if (showLoading ?? true) Get.back(); //closes loading dialog;
    print(results.data);
    return results;
  } catch (e) {
    print('************ ERROR IN FUNCTION $functionName **************');
    print(e);
    Get.back();
    showRedAlert('Something went wrong. Please try again');
    return null;
  }
}

cloudFunctionUpdateUser({@required String? functionName, @required Map? parameters, @required Function? action}) async {
  try {
    if (functionName == 'updateUser') {
      final userController = Get.find<UserController>();
      if (parameters!['userID'] == null) parameters['userID'] = userController.currentUser.value.userID;
    }
    HttpsCallable addVoucherCall = FirebaseFunctions.instanceFor(region: 'europe-west2').httpsCallable(functionName!);
    HttpsCallableResult results = await addVoucherCall(parameters);
    action!();
    print(results.data);
    return;
  } catch (e) {
    print(e);
    return;
  }
}
