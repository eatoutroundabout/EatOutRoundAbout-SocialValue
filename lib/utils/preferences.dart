import 'package:eatoutroundabout/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static getNotificationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('NotificationStatus') ?? true;
  }

  static setNotificationStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('NotificationStatus', value);
  }

  static getOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('OnboardingStatus') ?? false;
  }

  static setOnboardingStatus(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('OnboardingStatus', value);
  }

  static getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userID');
  }

  static setUser(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userID', value);
  }

  static getTipsPopupUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('TipsPopupUser') ?? true;
  }

  static setTipsPopupUser(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('TipsPopupUser', value);
  }

  static getBusinessPopup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('BusinessPopup') ?? true;
  }

  static setBusinessPopup(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('BusinessPopup', value);
  }

  static showGreetingIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt('GreetingsIntroCount') ?? 3;
    return count > 0;
  }

  static hideGreetingIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt('GreetingsIntroCount') ?? 3;
    prefs.setInt('GreetingsIntroCount', --count);
  }

  static getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('myRole') ?? SELECT_ROLE;
  }

  static setUserRole(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('myRole', value);
  }
}
