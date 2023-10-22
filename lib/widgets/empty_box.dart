import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';

class EmptyBox extends StatelessWidget {
  final String? text;

  EmptyBox({this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(padding),
        child: Linkify(
          text: text!,
          onOpen: (link) async {
            final utilService = Get.find<UtilService>();
            utilService.openLink(link.url);
          },
          options: LinkifyOptions(humanize: true),
          linkStyle: TextStyle(color: primaryColor),
          style: TextStyle(color: primaryColor),
          textAlign: TextAlign.center,
          textScaleFactor: 1,
        ),
      ),
    );
  }
}
