import 'package:eatoutroundabout/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Help extends StatelessWidget {
  const Help({this.title, this.description, this.image});

  final String? title;
  final String? description;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: Column(
        children: [
          Container(
            height: Get.height * 0.7,
            margin: EdgeInsets.symmetric(horizontal: padding),
            padding: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/$image'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(padding / 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(title!,
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.75,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(height: 25),
                Text(description!,
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.15,
                    style: TextStyle(color: Colors.white54)),
                SizedBox(height: 25),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
