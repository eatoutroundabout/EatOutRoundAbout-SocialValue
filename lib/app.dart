import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/screens/auth/splash_screen.dart';
import 'package:eatoutroundabout/services/authentication_service.dart';
import 'package:eatoutroundabout/services/buy_service.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/location_service.dart';
import 'package:eatoutroundabout/services/notification_service.dart';
import 'package:eatoutroundabout/services/permissions_service.dart';
import 'package:eatoutroundabout/services/storage_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum Flavor { development, production }

class App extends StatelessWidget {
  final Flavor? appFlavor;

  App({@required this.appFlavor});

  @override
  Widget build(BuildContext context) {
    addServices();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      title: 'Eat Out Round ABout',
      themeMode: ThemeMode.light,
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaleFactor: 1),
          child: child!,
        );
      },
      theme: theme(),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

addServices() {
  Get.put(LocationService());
  Get.put(StorageService());
  Get.put(UserController());
  Get.put(FirestoreService());
  Get.put(UtilService());
  Get.put(NotificationService());
  Get.put(PermissionsService());
  Get.put(AuthService());
  Get.put(BuyService());
}
