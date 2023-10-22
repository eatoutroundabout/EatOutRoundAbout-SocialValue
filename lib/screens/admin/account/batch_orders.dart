import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/user_vouchers_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BatchOrders extends StatelessWidget {
  final String? batchNo;
  final num? invoiceRef;

  BatchOrders({this.batchNo, this.invoiceRef});

  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: orangeColor,
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: <Widget>[
          Heading(title: 'SUMMARY'),
          Expanded(
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: FutureBuilder(
                    future: firestoreService.getVouchersForBatchNo(batchNo!),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData)
                        return snapshot.data!.docs.isNotEmpty
                            ? Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(padding / 2)),
                                  color: Colors.white,
                                ),
                                child: ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, i) {
                                    UserVoucher userVoucher = snapshot.data!.docs[i].data() as UserVoucher;

                                    return Padding(
                                      padding: const EdgeInsets.all(padding),
                                      child: Row(
                                        children: [
                                          Expanded(child: Text(userVoucher.voucherRedemptionCode!, style: TextStyle(fontWeight: FontWeight.bold, color: greenColor))),
                                          Expanded(
                                            flex: 2,
                                            child: Text(DateFormat('dd MMM yyyy, hh:mm a').format(userVoucher.redeemedDate!.toDate()), style: TextStyle(color: primaryColor), textScaleFactor: 1),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : EmptyBox(text: 'No vouchers redeemed yet');
                      else
                        return LoadingData();
                    })),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(25, 0, 25, 15),
            child: CustomButton(
              color: greenColor,
              text: 'Download Invoice',
              function: () async {
                try {
                  //final HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'europe-west2').httpsCallable('xeroGetInvoice');
                  //dynamic resp = await callable.call(<String, dynamic>{'invoiceRef': widget.invoiceRef});
                } catch (e) {
                  print('@@@@@@@@@@@@@@');
                  print(e);
                  showRedAlert('Something went wrong. Please try again.');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
