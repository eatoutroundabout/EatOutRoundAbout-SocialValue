import 'package:dotted_border/dotted_border.dart';
import 'package:eatoutroundabout/models/event_model.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';

class ViewEventCode extends StatelessWidget {
  final Event? event;

  ViewEventCode({this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'EVENT CODE', textScaleFactor: 1.75),
          Expanded(
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(padding),
                color: appBackground,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text('Step 1: Download the app. Scan the QR below using your phone\'s Camera', textScaleFactor: 1.25, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                      SizedBox(height: padding),
                      Image.asset('assets/images/qr.png', height: 150),
                      Divider(height: 50),
                      Text('Step 2: Go to the event and check-in using the event code below', textScaleFactor: 1.25, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                      SizedBox(height: 30),
                      DottedBorder(
                        color: Colors.black,
                        dashPattern: [8, 4],
                        strokeWidth: 3,
                        strokeCap: StrokeCap.butt,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(event!.eventCode!, textScaleFactor: 2, style: TextStyle(fontWeight: FontWeight.bold, color: redColor)),
                        ),
                      ),
                      SizedBox(height: padding),
                      Text('Promo Code', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
