import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/screens/admin/business/business_dashboard.dart';
import 'package:eatoutroundabout/screens/admin/account/edit_account.dart';
import 'package:eatoutroundabout/screens/admin/voucher/buy_voucher.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_list_tile.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/venue_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/screens/admin/venue/add_a_venue.dart';
import 'package:eatoutroundabout/screens/admin/account/payments_invoices.dart';


class AdminHome extends StatelessWidget {
  final userController = Get.find<UserController>();
  final firestoreService = Get.find<FirestoreService>();
  final utilService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Heading(title: 'ADMIN'),
          Expanded(
            child: Obx(
                  () {
                return Container(
                  color: appBackground,
                  child: userController.isVenueStaff()
                      ? ListView.builder(
                    padding: const EdgeInsets.only(top: padding),
                    itemCount: userController.currentUser.value.venueStaff!.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      return FutureBuilder(
                        builder: (context, AsyncSnapshot<DocumentSnapshot<Venue>> snapshot) {
                          if (snapshot.hasData) {
                            Venue venue = snapshot.data!.data() as Venue;
                            return VenueItem(venue: venue, isMyVenue: true);
                          } else
                            return Container();
                        },
                        future: firestoreService.getVenueByVenueID(userController.currentUser.value.venueStaff![i]),
                      );
                    },
                  )
                      : SingleChildScrollView(
                    padding: const EdgeInsets.all(padding),
                    child: Column(
                      children: [
                        if (userController.isAccountAdmin())
                          Padding(
                            padding: const EdgeInsets.all(padding),
                            child: CustomButton(
                              color: greenColor,
                              text: 'Buy Vouchers',
                              function: () => Get.to(() => BuyVoucher()),
                            ),
                          ),

                        // CustomListTile(
                        //   onTap: () => Get.to(() => BuyVoucher()),
                        //   leading: Icon(Icons.shopping_basket, color: greenColor, size: 30),
                        //   title: Text(
                        //     'Buy Vouchers',
                        //     style: TextStyle(color: greenColor, fontSize: 18.0),
                        //   ),
                        //   trailing: Icon(Icons.keyboard_arrow_right_rounded, color: greenColor),
                        // ),
                        if (userController.isAccountAdmin())
                          Padding(
                            padding: const EdgeInsets.all(padding),
                            child: CustomButton(
                              color: primaryColor,
                              text: 'Social Value',
                              function: () => Get.to(() => BusinessDashboard()),
                            ),
                          ),
                        // CustomListTile(
                        //   onTap: () => Get.to(() => BusinessDashboard()),
                        //   leading: Icon(Icons.qr_code, color: primaryColor, size: 30),
                        //   title: Text(
                        //     'Local Impact',
                        //     style: TextStyle(color: primaryColor, fontSize: 18.0),
                        //   ),
                        //   trailing: Icon(Icons.keyboard_arrow_right_rounded, color: greenColor),
                        // ),
                        if (userController.isAccountAdmin())
                          Padding(
                            padding: const EdgeInsets.all(padding),
                            child: CustomButton(
                              color: primaryColor,
                              text: 'My Account',
                              function: () => Get.to(() => EditAccount()),
                            ),
                          ),
                        // CustomListTile(
                        //   onTap: () => Get.to(() => EditAccount()),
                        //   leading: Icon(Icons.edit, color: primaryColor, size: 30),
                        //   title: Text(
                        //     'Account',
                        //     style: TextStyle(color: primaryColor, fontSize: 18.0),
                        //   ),
                        //   trailing: Icon(Icons.keyboard_arrow_right_rounded, color: primaryColor),
                        // ),
                        if (userController.isAccountAdmin() && userController.isVenueAdmin())
                          Padding(
                            padding: const EdgeInsets.all(padding),
                            child: CustomButton(
                              color: orangeColor,
                              text: 'Add a Venue',
                              function: () => Get.to(() => AddNewVenue()),
                            ),
                          ),
                        // CustomListTile(
                        //   onTap: () => Get.to(() => AddNewVenue()),
                        //   leading: Icon(Icons.restaurant, color: orangeColor, size: 30),
                        //   title: Text(
                        //     'Add a Venue',
                        //     style: TextStyle(color: orangeColor, fontSize: 18.0),
                        //   ),
                        //   trailing: Icon(Icons.keyboard_arrow_right_rounded, color: orangeColor),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(padding),
                          child: CustomButton(
                            color: orangeColor,
                            text: 'Payments and Invoices',
                            function: () => Get.to(() => PaymentsInvoices()),
                          ),
                        ),
                        // CustomListTile(
                        //   onTap: () => Get.to(() => PaymentsInvoices()),
                        //   leading: Icon(Icons.credit_card, color: orangeColor, size: 30),
                        //   title: Text(
                        //     'Payments and Invoices',
                        //     style: TextStyle(color: orangeColor, fontSize: 18.0),
                        //   ),
                        //   trailing: Icon(Icons.keyboard_arrow_right_rounded, color: orangeColor),
                        // ),

                        SizedBox(height: padding),
                        buildList((userController.currentUser.value.accountAdmin! + userController.currentUser.value.venueAdmin! + userController.currentUser.value.venueStaff!).toSet().toList()),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  buildList(List venues) {
    print(venues);
    return ListView.builder(
      itemCount: venues.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return FutureBuilder(
          builder: (context, AsyncSnapshot<DocumentSnapshot<Venue>> snapshot) {
            if (snapshot.hasData) {
              Venue venue = snapshot.data!.data() as Venue;
              return VenueItem(venue: venue, isMyVenue: true);
            } else
              return Container();
          },
          future: firestoreService.getVenueByVenueID(venues[i]),
        );
      },
    );
  }
}

