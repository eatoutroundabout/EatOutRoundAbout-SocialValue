import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/screens/admin/business/edit_business_profile.dart';
import 'package:eatoutroundabout/screens/admin/voucher/vouchers_dashboard.dart';
import 'package:eatoutroundabout/screens/business/view_business_profile.dart';
import 'package:eatoutroundabout/screens/admin/business/reports.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:eatoutroundabout/widgets/my_products_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eatoutroundabout/widgets/heading.dart';

import '../../Sample/get_document.dart';

class BusinessProfileDetails extends StatelessWidget {
  final BusinessProfile? businessProfile;
  final int? userType;

  BusinessProfileDetails({this.businessProfile, this.userType});

  final firestoreService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: FutureBuilder(
          future: firestoreService.getBusinessByBusinessID(businessProfile!.businessProfileID!),
          builder: (context, AsyncSnapshot<DocumentSnapshot<BusinessProfile>> snapshot) {
            if (!snapshot.hasData)
              return LoadingData();
            else {
              BusinessProfile businessProfile = snapshot.data!.data() as BusinessProfile;
              return Column(
                children: [
                  Heading(title: 'SOCIAL VALUE'),
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    //color: Colors.grey,
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(businessProfile.businessName!, textScaleFactor: 1.25, textAlign: TextAlign.center, style: TextStyle(color: purpleColor, fontWeight: FontWeight.bold)),
                        ),
                        Text(businessProfile.streetAddress!, textScaleFactor: 1, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),

                  Divider(height: 1),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(padding * 2, padding * 2, padding * 2, 0),
                      color: appBackground,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (userController.isAccountAdmin())
                              CustomButton(
                                color: primaryColor,
                                text: 'Edit Social Value Profile',
                                function: () => Get.to(() => EditBusinessProfile(businessProfile: businessProfile)),
                              ),
                            SizedBox(height: padding),
                            CustomButton(
                              color: primaryColor,
                              text: 'View Social Value Profile',
                              function: () => Get.to(() => ViewBusinessProfile(businessProfile: businessProfile)),
                            ),
                            SizedBox(height: padding),
                            Divider(height: 50, color: Colors.grey),
                            CustomButton(
                              text: 'Vouchers',
                              function: () => Get.to(() => VouchersDashboard(businessProfile: businessProfile)),
                            ),
                            SizedBox(height: padding),
                            CustomButton(
                              text: 'Social Value Reporting',
                              function: () => Get.to(() => ViewSocialValueReports()),
                            ),

                            CustomButton(
                              color: primaryColor,
                              text: 'Get Sample Document',
                              function: () => Get.to(() => GetSampleDocument(businessProfile: businessProfile)),
                            ),
                            SizedBox(height: padding),
                            MyProductsButton(businessProfile: businessProfile),
                            SizedBox(height: padding),
                            //MyEventsButton(),
                            SizedBox(height: padding),
                            // CustomButton(
                            //   text: 'Add Offers',
                            //   color: purpleColor,
                            //   function: () => Get.to(() => OfferDashboard(businessProfile: businessProfile)),
                            // ),
                            // SizedBox(height: padding),
                            // CustomButton(
                            //   text: 'Add Community',
                            //   color: blueColor,
                            //   function: () => Get.to(() => CommunitiesDashboard(businessProfile: businessProfile)),
                            // ),
                            //MyOffersButton(businessProfile: businessProfile),
                            //   CustomButton(
                            //     color: primaryColor,
                            //     text: 'Manage Staff',
                            //     function: () => Get.to(() => AddBusinessStaff(businessProfile: businessProfile)),
                            //   ),
                            // SizedBox(height: padding),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}