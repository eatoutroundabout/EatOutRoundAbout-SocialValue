import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatoutroundabout/models/voucher_model.dart';
import 'package:eatoutroundabout/screens/admin/voucher/share_voucher.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'view_voucher_claims.dart';

class VoucherDetails extends StatelessWidget {
  final Voucher? voucher;
  final String? campaignName;

  VoucherDetails({this.voucher, this.campaignName});

  final firestoreService = Get.find<FirestoreService>();
  final utilService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            color: Colors.white,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(campaignName!, textScaleFactor: 1.25, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text('${voucher!.remainingVouchers} vouchers remaining', textScaleFactor: 0.9, style: TextStyle(color: redColor)),
              ],
            ),
          ),
          Divider(height: 1),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(padding),
              color: appBackground,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    item('Campaign Name', campaignName!),
                    item('Display Message', voucher!.displayMessage!),
                    item('Voucher Offer', voucher!.voucherOffer!),
                    item('Remaining Vouchers', voucher!.remainingVouchers.toString()),
                    item('Max claims per user', voucher!.maxClaimsPerUser.toString()),
                    CustomButton(
                      text: 'Preview',
                      function: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context1) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              insetPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 100),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              child: voucherItem(true),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: padding),
                    CustomButton(
                      text: 'View Claims and Redemptions',
                      function: () => Get.to(() => ViewVoucherClaims(voucherID: voucher!.voucherID!)),
                    ),
                    SizedBox(height: padding),
                    CustomButton(
                      color: redColor,
                      text: 'Give Voucher',
                      function: () => Get.to(() => ShareVoucher(voucher: voucher!)),
                    ),
                    SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  item(String name, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(color: Colors.teal.shade400, fontWeight: FontWeight.bold)),
            SizedBox(height: 15, width: double.infinity),
            Text(value),
          ],
        ),
      ),
    );
  }

  voucherItem(bool isPreview) {
    return Container(
      height: Get.height - 200,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        image: DecorationImage(
          image: CachedNetworkImageProvider(voucher!.voucherImage!),
          fit: BoxFit.cover,
          colorFilter: new ColorFilter.mode(Colors.black38, BlendMode.darken),
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.black38),
                      child: CachedImage(height: 100, url: voucher!.voucherLogo, roundedCorners: true, circular: false),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MediaQuery(
                      data: MediaQueryData(textScaleFactor: 1.5),
                      child: Theme(
                        data: ThemeData(),
                        child: TextField(
                          enabled: false,
                          maxLines: 2,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(border: InputBorder.none, hintText: 'To', hintStyle: TextStyle(color: Colors.white54)),
                        ),
                      ),
                    ),
                    MediaQuery(
                      data: MediaQueryData(textScaleFactor: 1.5),
                      child: Theme(
                        data: ThemeData(),
                        child: TextField(
                          enabled: false,
                          maxLines: 4,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(color: Colors.white),
                          controller: TextEditingController(text: voucher!.displayMessage),
                          decoration: InputDecoration(isCollapsed: true, isDense: true, border: InputBorder.none, hintText: 'Tap Here to add your custom Greeting', hintStyle: TextStyle(color: Colors.white54)),
                        ),
                      ),
                    ),
                    MediaQuery(
                      data: MediaQueryData(textScaleFactor: 1.5),
                      child: Theme(
                        data: ThemeData(),
                        child: TextField(
                          enabled: false,
                          maxLines: 2,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(border: InputBorder.none, hintText: 'From', hintStyle: TextStyle(color: Colors.white54)),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Save 50% on food and soft drinks off-peak up to £10 per voucher. T&C\'s apply.', textScaleFactor: 1.2, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Expiry : ' + DateFormat('dd MMM yyyy').format(voucher!.definedExpiryDate!.toDate()), textScaleFactor: 1, style: TextStyle(color: lightGreenColor)),
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                            ),
                            child: Text(voucher!.promoCode!, textScaleFactor: 1, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ],
                    ),
                    SizedBox(height: 15),
                    CustomButton(
                      text: 'Close',
                      function: () => Get.back(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
