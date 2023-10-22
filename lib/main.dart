import 'package:eatoutroundabout/app.dart';
import 'package:eatoutroundabout/config.dart';
import 'package:eatoutroundabout/screens/home/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  await initialSetup(Flavor.development);
  //runApp(HomePage());
  runApp(App(appFlavor: Flavor.development));
}
