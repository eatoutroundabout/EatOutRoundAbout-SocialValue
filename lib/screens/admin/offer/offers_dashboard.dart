import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/models/offer_model.dart';
import 'package:eatoutroundabout/screens/admin/offer/add_offer.dart';
import 'package:eatoutroundabout/screens/auth/section_splash.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:eatoutroundabout/widgets/offer_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class OfferDashboard extends StatelessWidget {
  final userController = Get.find<UserController>();
  final firestoreService = Get.find<FirestoreService>();
  final utilService = Get.find<UtilService>();

  final BusinessProfile? businessProfile;

  OfferDashboard({this.businessProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15)),
      body: Column(
        children: [
          Heading(title: 'MY OFFERS'),
          Expanded(
            child: Container(
              color: appBackground,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: padding),
                    Padding(
                      padding: const EdgeInsets.all(padding),
                      child: CustomButton(
                        color: purpleColor,
                        function: () => showHospitalitySplash(),
                        text: 'Create a Hospitality Offer',
                        icon: Icon(userController.currentAccount.value.offerExpiryDate!.toDate().isBefore(DateTime.now()) ? Icons.lock_outline : Icons.lock_open, color: userController.currentAccount.value.offerExpiryDate!.toDate().isBefore(DateTime.now()) ? Colors.white38 : Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: padding),
                      child: CustomButton(
                        color: purpleColor,
                        function: () => showBusinessSplash(),
                        text: 'Create a Business Offer',
                        icon: Icon(userController.currentAccount.value.offerExpiryDate!.toDate().isBefore(DateTime.now()) ? Icons.lock_outline : Icons.lock_open, color: userController.currentAccount.value.offerExpiryDate!.toDate().isBefore(DateTime.now()) ? Colors.white38 : Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(padding),
                      child: CustomButton(
                        color: purpleColor,
                        text: 'Create a Retail Offer',
                        function: () => Get.to(
                          () => SectionSplash(
                            title: 'Attract Customers',
                            description: 'Promote to users of Eat Out Round About that they can claim Eat Out vouchers when they meet your spend criteria and visit your retail store, salon, cultural or high street venue!',
                            image: 'assets/images/high_street_add_purple.png',
                            function: () => Get.off(() => AddOffer(businessProfile: businessProfile, isBusinessOffer: false, isHospitalityOffer: false, isRetailOffer: true)),
                          ),
                        ),
                      ),
                    ),
                    PaginateFirestore(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      isLive: true,
                      key: GlobalKey(),
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      itemBuilderType: PaginateBuilderType.listView,
                      itemBuilder: (context, documentSnapshot, i) {
                        Offer offer = documentSnapshot[i].data() as Offer;
                        return OfferTile(offer: offer, isMyOffer: true);
                      },
                      query: firestoreService.getBusinessOffersQuery(businessProfile!.businessProfileID!),
                      onEmpty: Padding(
                        padding: EdgeInsets.only(bottom: Get.height / 2 - 200, left: 25, right: 25),
                        child: Text(
                          'Promote your offer locally and reward business and people for keeping their purchases local.\n\nIncludes Staff benefit suppliers, workplace wellbeing, food & drink, corporate hospitality, celebration parties, local culture, high street, retail and services for hospitality.',
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.15,
                        ),
                      ),
                      itemsPerPage: 10,
                      bottomLoader: LoadingData(),
                      initialLoader: LoadingData(),
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

  showHospitalitySplash() {
    return Get.to(
      () => SectionSplash(
        title: 'Attract more group bookings!',
        description: 'Promote offers to local staff to enjoy savings for block bookings and your corporate hospitality offer to local businesses!',
        image: userController.currentAccount.value.isVenueAccount! ? 'assets/images/hospitality_offers.png' : 'assets/images/create_business_offer.png',
        function: () async {
          if (userController.currentAccount.value.offerExpiryDate!.toDate().isBefore(DateTime.now()))
            utilService.showUnlockDialog(
              10,
              VIEW_OFFER,
              'Promote offers to local staff to enjoy savings for block bookings and your corporate hospitality offer to local businesses!',
            );
          else
            Get.off(() => AddOffer(businessProfile: businessProfile, isBusinessOffer: false, isHospitalityOffer: true, isRetailOffer: false));
        },
      ),
    );
  }

  showBusinessSplash() {
    return Get.to(
      () => SectionSplash(
        title: 'Business Promotion',
        description: 'Promote your workplace wellbeing and hospitality business offers to local businesses!',
        image: userController.currentAccount.value.isVenueAccount! ? 'assets/images/hospitality_offers.png' : 'assets/images/create_business_offer.png',
        function: () async {
          if (userController.currentAccount.value.offerExpiryDate!.toDate().isBefore(DateTime.now()))
            utilService.showUnlockDialog(
              10,
              VIEW_OFFER,
              'Promote your workplace wellbeing and hospitality business offers to local businesses!',
            );
          else
            Get.off(() => AddOffer(businessProfile: businessProfile, isBusinessOffer: true, isHospitalityOffer: false, isRetailOffer: false));
        },
      ),
    );
  }
}
