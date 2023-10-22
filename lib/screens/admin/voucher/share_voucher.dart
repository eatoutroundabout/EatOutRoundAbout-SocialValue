import 'package:dotted_border/dotted_border.dart';
import 'package:eatoutroundabout/models/voucher_model.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ShareVoucher extends StatelessWidget {
  final Voucher? voucher;

  ShareVoucher({this.voucher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'SHARE VOUCHER', textScaleFactor: 1.75),
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
                      Text('Step 2: Claim your Voucher using\nthe red QR button', textScaleFactor: 1.25, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                      SizedBox(height: padding),
                      PrettyQr(
                        typeNumber: 3,
                        size: 150,
                        data: voucher!.voucherID!,
                        roundEdges: true,
                      ),
                      SizedBox(height: 30),
                      DottedBorder(
                        color: Colors.black,
                        dashPattern: [8, 4],
                        strokeWidth: 3,
                        strokeCap: StrokeCap.butt,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(voucher!.promoCode!, textScaleFactor: 2, style: TextStyle(fontWeight: FontWeight.bold, color: redColor)),
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
