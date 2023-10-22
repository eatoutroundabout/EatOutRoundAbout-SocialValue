import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SectionSplash extends StatelessWidget {
  final String? title, image, description;
  final Function? function;

  const SectionSplash({this.title, this.description, this.image, this.function});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage(image!), fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.all(padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(
                  flex: 65,
                ),
                Text(
                  title!,
                  textScaleFactor: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 25),
                Text(
                  description!,
                  textScaleFactor: 1.25,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(
                  flex: 10,
                ),
                CustomButton(
                  text: 'Proceed',
                  color: redColor,
                  function: () => function!(),
                ),
                Padding(
                  padding: const EdgeInsets.all(padding),
                  child: TextButton(onPressed: ()=>Get.back(), child: Text('Go Back', style: TextStyle(color: Colors.white))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
