import 'package:eatoutroundabout/app.dart';
import 'package:eatoutroundabout/config.dart';
import 'package:flutter/material.dart';

void main() async {
  await initialSetup(Flavor.development);
  runApp(App(appFlavor: Flavor.development));
}
