import 'package:eatoutroundabout/screens/messages/view_image.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageBox extends StatelessWidget {
  final String? imageURL;
  final String? message;
  final bool? isSent;
  final int? time;
  final String? docID;

  const MessageBox({
    this.imageURL,
    @required this.message,
    @required this.isSent,
    this.time,
    this.docID,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isSent! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: isSent! ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: isAllEmoji(message!)
                      ? null
                      : isSent!
                          ? primaryColor
                          : lightGreenColor,
                  borderRadius: BorderRadius.circular(padding / 2),
                ),
                margin: EdgeInsets.fromLTRB(isSent! ? MediaQuery.of(context).size.width * 0.1 : 0, padding * 2, isSent! ? 0 : MediaQuery.of(context).size.width * 0.1, 0),
                padding: EdgeInsets.symmetric(horizontal: imageURL == null ? 20 : 0, vertical: imageURL == null ? 10 : 0),
                child: imageURL == null
                    ? Text(
                        message!,
                        textScaleFactor: isAllEmoji(message!) ? 2 : 1,
                        style: TextStyle(color: isSent! ? Colors.white : primaryColor, fontStyle: message == 'This message was deleted' ? FontStyle.italic : FontStyle.normal),
                        maxLines: 100,
                      )
                    : InkWell(
                        onTap: () => Get.to(() => ViewImages(images: [imageURL], index: 0)),
                        child: Padding(
                          padding: const EdgeInsets.all(1),
                          child: CachedImage(roundedCorners: true, height: 200, url: imageURL!),
                        ),
                      ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(4),
          child: Text(timeago.format(DateTime.fromMillisecondsSinceEpoch(time!)), textScaleFactor: 0.8, style: TextStyle(color: primaryColor)),
        ),
      ],
    );
  }

  bool isAllEmoji(String text) {
    for (String s in EmojiParser().unemojify(text).split(" ")) if (!s.startsWith(":") || !s.endsWith(":")) return false;
    return true;
  }
}
