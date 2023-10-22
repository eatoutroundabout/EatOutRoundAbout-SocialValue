import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/self_billing_model.dart';
import 'package:eatoutroundabout/screens/admin/account/batch_orders.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PaymentsInvoices extends StatelessWidget {
  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: <Widget>[
          Heading(title: 'PAYMENTS'),
          Expanded(
            child: Container(
              width: double.infinity,
              color: appBackground,
              child: FutureBuilder(
                future: firestoreService.getInvoicesForAccount(),
                builder: (context, AsyncSnapshot<QuerySnapshot<SelfBilling>> snapshot) {
                  if (snapshot.hasData)
                    return snapshot.data!.docs.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.all(padding),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, i) {
                              SelfBilling selfBilling = snapshot.data!.docs[i].data();
                              return Card(
                                child: ListTile(
                                  onTap: () => Get.to(() => BatchOrders(batchNo: selfBilling.batchNumber, invoiceRef: selfBilling.invoiceRef)),
                                  title: Text('Invoice Date : ' + DateFormat('dd MMM yyyy').format(selfBilling.date!.toDate()), style: TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Total : ' + selfBilling.total.toString(), textScaleFactor: 0.9),
                                      Text(selfBilling.paid! ? 'Paid' : 'Unpaid', textScaleFactor: 0.9, style: TextStyle(color: selfBilling.paid! ? greenColor : redColor)),
                                    ],
                                  ),
                                  trailing: Icon(Icons.keyboard_arrow_right),
                                ),
                              );
                            },
                          )
                        : EmptyBox(text: 'No invoices to show');
                  else
                    return LoadingData();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
