import 'package:eatoutroundabout/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

theme() {
  final double textSize = 16;
  final double buttonTextSize = 16;

  return ThemeData(
    scaffoldBackgroundColor: appBackground,
    backgroundColor: appBackground,
    fontFamily: 'Font2',
    primaryColor: Colors.teal,
    brightness: Brightness.light,
    primarySwatch: Colors.teal,
    cardTheme: CardTheme(margin: EdgeInsets.only(bottom: padding), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding / 2)), elevation: 0.5),
    checkboxTheme: CheckboxThemeData(checkColor: MaterialStateProperty.all(Colors.white)),
    dialogTheme: DialogTheme(titleTextStyle: textStyle(buttonTextSize * 1.25), contentTextStyle: textStyle(textSize), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding / 2))),
    textTheme: TextTheme(headline6: textStyle(textSize), bodyText2: textStyle(textSize), subtitle2: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontFamily: 'Font2', fontSize: textSize)),
    appBarTheme: AppBarTheme(centerTitle: true, color: primaryColor, systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark), elevation: 0, iconTheme: IconThemeData(color: Colors.white), titleTextStyle: textStyle(textSize)),
    tabBarTheme: TabBarTheme(
      labelStyle: textStyle(textSize),
      unselectedLabelStyle: textStyle(textSize),
      indicator: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(padding / 2)),
      labelColor: Colors.white,
      unselectedLabelColor: primaryColor,
      indicatorSize: TabBarIndicatorSize.tab,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: primaryColor, type: BottomNavigationBarType.fixed, selectedItemColor: Colors.white, unselectedItemColor: Colors.white38),
    textButtonTheme: TextButtonThemeData(style: ButtonStyle(textStyle: MaterialStateProperty.all(TextStyle(decoration: TextDecoration.underline, fontSize: buttonTextSize)), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding / 2))), foregroundColor: MaterialStateProperty.all(Colors.teal), minimumSize: MaterialStateProperty.all(Size(double.infinity, 45)))),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(redColor), textStyle: MaterialStateProperty.all(TextStyle(color: Colors.white, fontSize: buttonTextSize)), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding / 2))), minimumSize: MaterialStateProperty.all(Size(double.infinity, 45)))),
    inputDecorationTheme: InputDecorationTheme(border: inputBorder(primaryColor), focusedBorder: inputBorder(greenColor), enabledBorder: inputBorder(primaryColor), disabledBorder: inputBorder(primaryColor), errorBorder: inputBorder(Colors.red.shade400), hintStyle: TextStyle(color: Colors.grey), filled: true, fillColor: Colors.white, contentPadding: EdgeInsets.only(left: 20)),
  );
}

inputBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(padding / 2),
    borderSide: BorderSide(width: 1, color: color),
  );
}

textStyle(double textSize) {
  return TextStyle(
    color: primaryColor,
    fontFamily: 'Font2',
    fontSize: textSize,
  );
}
