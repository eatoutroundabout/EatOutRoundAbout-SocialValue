import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final double? height;
  final String? url;
  final bool? roundedCorners;
  final bool? circular;
  final File? imageFile;
  final String? text;

  CachedImage({this.height, this.url, this.roundedCorners, this.circular, this.imageFile, this.text = 'Add Image'});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(circular ?? false
          ? 100
          : roundedCorners ?? true
              ? padding / 2
              : 0),
      child: imageFile != null
          ? Image.file(
              imageFile!,
              fit: BoxFit.cover,
              height: height,
              width: height,
            )
          : CachedNetworkImage(
              imageUrl: url ?? '',
              fit: BoxFit.cover,
              height: height,
              width: height,
              placeholder: (context, url) => showImage(url),
              errorWidget: (context, url, error) => errorImage(url),
            ),
    );
  }

  showImage(String url) {
    return Image.asset('assets/images/loading.gif', height: height);
  }

  errorImage(String url) {
    if (url == 'profile') return Image.asset('assets/images/profile.png', height: height, fit: BoxFit.cover);
    if (url == 'add')
      return Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(padding / 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 30, color: primaryColor),
            SizedBox(height: 10),
            Text(text!, textScaleFactor: 1, style: TextStyle(color: primaryColor)),
          ],
        ),
      );
    if (url == 'promo')
      return Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(padding / 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 30, color: primaryColor),
            SizedBox(height: 10),
            Text('Add Promotional Image', textScaleFactor: 1, style: TextStyle(color: primaryColor)),
          ],
        ),
      );
    if (url == 'voucherImage')
      return Container(
        width: 120,
        height: 240,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(padding / 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 30, color: primaryColor),
            SizedBox(height: 10),
            Text('Voucher Image', textScaleFactor: 1, style: TextStyle(color: primaryColor)),
          ],
        ),
      );
    else
      return Image.asset('assets/images/placeholder.png', height: height);
  }
}
