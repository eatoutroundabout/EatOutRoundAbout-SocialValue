import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/voucher_model.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ClaimVoucherItem extends StatelessWidget {
  final Voucher? voucher1;

  ClaimVoucherItem({this.voucher1});

  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(padding),
      margin: const EdgeInsets.fromLTRB(padding, 0, padding, padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(padding / 2)),
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/${voucher1!.voucherType}.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          CachedImage(url: voucher1!.voucherLogo, roundedCorners: true, height: 80),
          Padding(
            padding: const EdgeInsets.all(padding),
            child: Text(voucher1!.voucherType == 'christmas' ? 'Claim me to eat out in January / February' : voucher1!.displayMessage!, textScaleFactor: 0.9, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: greenColor)),
          ),
          InkWell(
            onTap: () async {
              String voucherID = voucher1!.voucherID!;
              HapticFeedback.vibrate();
              Map voucher = {
                'voucherID': voucherID,
                'userID': userController.currentUser.value.userID,
                'latitude': userController.myLatitude,
                'longitude': userController.myLongitude,
              };
              await cloudFunction(functionName: 'addVoucher', parameters: voucher, action: () {});
            },
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: voucher1!.voucherType != 'standard' ? redColor : primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Text('Claim voucher', style: TextStyle(color: Colors.white))),
          ),
          Text('You can claim this voucher ${voucher1!.maxClaimsPerUser} times', textScaleFactor: 0.9, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
