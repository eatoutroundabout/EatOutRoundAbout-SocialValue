import 'package:eatoutroundabout/utils/constants.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      print("return Future.error('Location services are disabled.');");
      return Future.error(1);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        print("return Future.error('Location permissions are denied');");
        return Future.error(2);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      print("return Future.error('Location permissions are permanently denied, we cannot request permissions.');");
      return Future.error(3);
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    print("return await Geolocator.getCurrentPosition();");
    Position position = await Geolocator.getCurrentPosition();
    myLatitude = position.latitude;
    myLongitude = position.longitude;
    return position;
  }
}
