import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/screens/admin/account/payments_invoices.dart';
import 'package:eatoutroundabout/screens/admin/venue/add_a_venue.dart';
import 'package:eatoutroundabout/services/authentication_service.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/venue_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';

class VenueDashboard extends StatelessWidget {
  final accountService = Get.find<FirestoreService>();
  final authService = Get.find<AuthService>();
  final firestoreService = Get.find<FirestoreService>();
  final utilService = Get.find<UtilService>();
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15),
        actions: [
          IconButton(onPressed: () => utilService.openLink('https://wa.me/message/DT4CD67J67LNK1'), icon: Icon(Icons.help_outline_rounded)),
        ],
      ),
      body: Column(
        children: [
          Heading(title: 'MY VENUES'),
          Expanded(
            child: Container(
              color: appBackground,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (userController.isAccountAdmin())
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(padding),
                            child: CustomButton(
                              color: orangeColor,
                              text: 'Add a Venue',
                              function: () => Get.to(() => AddNewVenue()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: padding),
                            child: CustomButton(
                              color: orangeColor,
                              text: 'Payments and Invoices',
                              function: () => Get.to(() => PaymentsInvoices()),
                            ),
                          ),
                          SizedBox(height: padding),
                        ],
                      ),

                  ],
                ),
              ),
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

  accountApprovalPending() {
    return buildText('Your account is awaiting approval. If you have not heard from us within 48 hours, please contact support@EatOutRoundAbout.co.uk');
  }

  notRegistered() {
    return buildText('Do you own or manage an Eat Out venue? If so, you can register to participate on the programme. Visit https://www.EatOutRoundAbout.co.uk/venues for further details. ');
  }

  buildText(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(padding),
        child: Linkify(
          text: text,
          onOpen: (link) async => await utilService.openLink(link.url),
          options: LinkifyOptions(humanize: true),
          linkStyle: TextStyle(color: primaryColor),
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
          textScaleFactor: 1.1,
        ),
      ),
    );
  }
}
