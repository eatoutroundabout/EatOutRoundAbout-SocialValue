import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/user_vouchers_model.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:eatoutroundabout/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VenueOrders extends StatefulWidget {
  final Venue? venue;

  VenueOrders({this.venue});

  @override
  _VenueOrdersState createState() => _VenueOrdersState();
}

class _VenueOrdersState extends State<VenueOrders> {
  final voucherService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: <Widget>[
          Heading(title: 'VOUCHER REDEMPTIONS', textScaleFactor: 1.5),
          Expanded(
            child: Container(
                width: double.infinity,
                child: StreamBuilder(
                    stream: voucherService.getVenueVouchers(widget.venue!.venueID!),
                    builder: (context, AsyncSnapshot<QuerySnapshot<UserVoucher>> snapshot) {
                      if (snapshot.hasData)
                        return snapshot.data!.docs.isNotEmpty
                            ? ListView.builder(
                                padding: EdgeInsets.all(padding),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, i) {
                                  return OrderItem(userVoucher: snapshot.data!.docs[i].data());
                                },
                              )
                            : EmptyBox(text: 'No vouchers redeemed yet');
                      else
                        return LoadingData();
                    })),
          ),
        ],
      ),
    );
  }
}
