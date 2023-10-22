import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/user_vouchers_model.dart';
import 'package:eatoutroundabout/models/voucher_model.dart';
import 'package:eatoutroundabout/screens/vouchers/restricted_venues.dart';
import 'package:eatoutroundabout/screens/vouchers/view_voucher.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VoucherItem extends StatefulWidget {
  final UserVoucher? userVoucher;

  VoucherItem({this.userVoucher});

  @override
  State<VoucherItem> createState() => _VoucherItemState();
}

class _VoucherItemState extends State<VoucherItem> {
  final firestoreService = Get.find<FirestoreService>();

  String? name;
  String? value;

  Future<DocumentSnapshot<Voucher>>? future;

  @override
  void initState() {
    future = firestoreService.getVoucherByVoucherID(widget.userVoucher!.voucherID!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      key: Key(widget.userVoucher!.voucherID!),
      future: future,
      builder: (context, AsyncSnapshot<DocumentSnapshot<Voucher>> snapshot) {
        if (snapshot.hasData) {
          Voucher? voucher = snapshot.data!.data();
          getNameAndValue(widget.userVoucher!);
          return InkWell(
            onTap: () => widget.userVoucher!.redeemable!
                ? widget.userVoucher!.redeemed!
                    ? showRedAlert('Voucher already redeemed')
                    : Get.to(() => ViewVoucher(userVoucher: widget.userVoucher!, name: name!, value: value!))
                : showRedAlert('This voucher is not redeemable'),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(padding),
                    margin: const EdgeInsets.fromLTRB(padding, 0, padding, padding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(padding / 2)),
                      image: voucher!.voucherImage == '' ? null : DecorationImage(image: CachedNetworkImageProvider(voucher.voucherImage!), colorFilter: widget.userVoucher!.redeemable! ? ColorFilter.mode(Colors.black45, BlendMode.srcOver) : ColorFilter.mode(Colors.grey, BlendMode.saturation), fit: BoxFit.cover),
                      color: widget.userVoucher!.redeemable! ? Colors.black38 : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (voucher.voucherType == 'Christmas' && !widget.userVoucher!.redeemed!)
                          Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: redColor,
                            ),
                            child: Text('Redeemable in January - February', style: TextStyle(color: Colors.white)),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedImage(height: 100, url: voucher.voucherLogo ?? '', roundedCorners: true, circular: false),
                            if (voucher.bidRestricted != '' || voucher.lepRestricted != '' || voucher.localAuthRestricted != '' || voucher.wardRestricted != '' || voucher.venueRestricted != '') CircleAvatar(backgroundColor: lightGreenColor, child: Icon(Icons.lock_outline, color: primaryColor, size: 30)),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 80),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(voucher.displayMessage!, textScaleFactor: 1.9, maxLines: 5, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                        Text(voucher.voucherOffer!, textScaleFactor: 1.2, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                        SizedBox(height: 10),
                        widget.userVoucher!.redeemed! ? redeemed() : normalVoucher(),
                      ],
                    ),
                  ),
                ),
                if (name != null)
                  TextButton(
                    onPressed: () => Get.to(() => RestrictedVenues(name: name!, value: value!)),
                    child: Text('Check where this voucher is valid', style: TextStyle(color: lightGreenColor)),
                  ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  redeemed() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(padding / 2)),
        ),
        child: Text('Redeemed', textScaleFactor: 1, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));
  }

  normalVoucher() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Expiry : ' + DateFormat('dd MMM yyyy').format(widget.userVoucher!.expiryDate!.toDate()), textScaleFactor: 1, style: TextStyle(color: lightGreenColor)),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(
              color: redColor,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: Text(widget.userVoucher!.redeemable! ? widget.userVoucher!.voucherRedemptionCode! : '------', textScaleFactor: 1, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      ],
    );
  }

  getNameAndValue(UserVoucher userVoucher) {
    if (userVoucher.bidRestricted != '') {
      name = 'bidRestricted';
      value = userVoucher.bidRestricted;
    }

    if (userVoucher.lepRestricted != '') {
      name = 'lepRestricted';
      value = userVoucher.lepRestricted;
    }

    if (userVoucher.wardRestricted != '') {
      name = 'wardRestricted';
      value = userVoucher.wardRestricted;
    }

    if (userVoucher.localAuthRestricted != '') {
      name = 'localAuthRestricted';
      value = userVoucher.localAuthRestricted;
    }

    if (userVoucher.venueRestricted != '') {
      name = 'venueRestricted';
      value = userVoucher.venueRestricted;
    }
  }
}
