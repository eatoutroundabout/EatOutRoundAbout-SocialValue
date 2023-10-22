import 'package:eatoutroundabout/models/voucher_model.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/claim_voucher_item.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class ClaimVouchers extends StatelessWidget {
  final voucherService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greenColor,
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: claimVouchers(),
    );
  }

  claimVouchers() {
    return Column(
      children: [
        Heading(title: 'CLAIM VOUCHERS'),
        Expanded(
          child: PaginateFirestore(
            padding: const EdgeInsets.only(top: padding),
            shrinkWrap: true,
            itemBuilderType: PaginateBuilderType.listView,
            itemBuilder: (context, documentSnapshot, i) {
              Voucher voucher = documentSnapshot[i].data() as Voucher;
              return ClaimVoucherItem(voucher1: voucher);
            },
            query: voucherService.getClaimVouchersQuery(),
            onEmpty: buildText('You haven’t been gifted any vouchers yet. Why not ask your employer?\nwww.EatOutRoundAbout.co.uk'),
            itemsPerPage: 10,
            bottomLoader: LoadingData(),
            initialLoader: LoadingData(),
          ),
        ),
      ],
    );
  }

  buildText(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(padding),
        child: Linkify(
          text: text,
          onOpen: (link) async {
            utilService.openLink(link.url);
          },
          options: LinkifyOptions(humanize: true),
          linkStyle: TextStyle(color: primaryColor),
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
          textScaleFactor: 1.2,
        ),
      ),
    );
  }
}
