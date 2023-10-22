import 'package:eatoutroundabout/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  getLocation() async {
    bool checkIfGranted = await requestLocationPermission();
    if (checkIfGranted) {
      await getLocation();
    } else {
      showPermissionSettingsDialog('This app needs Location access to show your nearby venues');
    }
  }

  checkIfLocationEnabled() async {
    var location = loc.Location();
    bool enabled = await location.serviceEnabled();
    if (enabled)
      return true;
    else {
      await location.requestService();
      showRedAlert('Please enable location and try again');
      return false;
    }
  }

  requestLocationPermission() async {
    PermissionStatus status = await Permission.locationWhenInUse.status;
    if (status.isDenied) status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;
    print(status);
    if (status == PermissionStatus.denied) status = await Permission.camera.request();
    return status.isGranted;
  }

  showPermissionSettingsDialog(String description) {
    Get.defaultDialog(
      radius: padding / 2,
      title: 'Permission required',
      content: Text(description),
      actions: <Widget>[
        TextButton(
          child: Text('Deny'),
          onPressed: () => Get.back(),
        ),
        TextButton(
          child: Text('Settings'),
          onPressed: () {
            Get.back();
            openAppSettings();
          },
        ),
      ],
    );
  }
}
