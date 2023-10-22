import 'package:eatoutroundabout/utils/constants.dart';
import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final String? title;
  final double? textScaleFactor;

  Heading({this.title, this.textScaleFactor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(horizontal: BorderSide(color: Colors.grey.shade400)),
      ),
      alignment: Alignment.center,
      width: double.infinity,
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title ?? '', textScaleFactor: textScaleFactor ?? 2, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontFamily: 'Font1')),
        ],
      ),
    );
  }
}
