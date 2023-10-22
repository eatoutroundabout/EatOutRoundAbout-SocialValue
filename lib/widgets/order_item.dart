import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/user_vouchers_model.dart';
import 'package:eatoutroundabout/models/users_model.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatelessWidget {
  final UserVoucher? userVoucher;
  final firestoreService = Get.find<FirestoreService>();

  OrderItem({this.userVoucher});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //onTap: () => Get.to(()=> VenueDetails()),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(padding),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(userVoucher!.voucherRedemptionCode!, style: TextStyle(color: greenColor, fontWeight: FontWeight.bold)),
                    Text('Redeemed', textScaleFactor: 0.8, style: TextStyle(color: greenColor)),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat('dd MMMM yyyy, hh:mm a').format(userVoucher!.redeemedDate!.toDate()), textScaleFactor: 0.9, style: TextStyle(color: greenColor)),
                    FutureBuilder(
                        future: firestoreService.getUser(userVoucher!.redeemedVenueUserID),
                        builder: (context, AsyncSnapshot<DocumentSnapshot<User>> snapshot) {
                          if (snapshot.hasData) {
                            User? user = snapshot.data!.data();
                            return Text('Redeemed by : ' + user!.firstName!, textScaleFactor: 0.9, maxLines: 1, style: TextStyle(color: primaryColor));
                          } else
                            return Container();
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
