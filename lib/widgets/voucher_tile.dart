import 'package:eatoutroundabout/models/voucher_model.dart';
import 'package:eatoutroundabout/screens/admin/voucher/voucher_details.dart';
import 'package:eatoutroundabout/models/voucher_campaigns_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'loading.dart';

class VoucherTile extends StatelessWidget {
  final Voucher? voucher;
  final firestoreService = Get.find<FirestoreService>();

  VoucherTile({this.voucher});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firestoreService.getVoucherCampaign(voucher!.campaignID!),
      builder:(context, snapshot) {
        if(snapshot.hasData){
          final VoucherCampaign? voucherCampaign = snapshot.data;
          return ListTile(
            onTap: () => Get.to(() => VoucherDetails(voucher: voucher!, campaignName: voucherCampaign!.campaignName)),
            contentPadding: const EdgeInsets.only(top: 15),
            leading: CachedImage(url: voucher!.voucherLogo, height: 60),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(voucherCampaign!.campaignName ?? ""),
                Text(voucher!.displayMessage!, style: TextStyle(color: greenColor)),
              ],
            ),
            trailing: Text('${voucher!.remainingVouchers} left', textScaleFactor: 0.9, style: TextStyle(color: redColor)),
          );
        }
        else if(snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        else {
          return LoadingData();
        }
      },
    );
  }
}
