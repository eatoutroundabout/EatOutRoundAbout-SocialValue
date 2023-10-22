import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/screens/admin/business/add_business_profile.dart';
import 'package:eatoutroundabout/screens/auth/section_splash.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/business_profile_item.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessDashboard extends StatelessWidget {
  final userController = Get.find<UserController>();
  final firestoreService = Get.find<FirestoreService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15),
        actions: [
          IconButton(onPressed: () => utilService.openLink('https://wa.me/message/IC4Q25UGDJGZA1'), icon: Icon(Icons.help_outline_rounded)),
        ],
      ),
      body: Column(
        children: [
          Heading(title: 'SOCIAL VALUE'),
          Expanded(
            child: Container(
              color: appBackground,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (userController.isAccountAdmin())
                      Padding(
                        padding: const EdgeInsets.all(padding),
                        child: CustomButton(
                          color: purpleColor,
                          text: 'Add social value profile',
                          function: () => Get.to(
                                () => SectionSplash(
                              title: 'Social value profile',
                              description: 'Create social value your community. You can create one social value profile for free or subscribe for multiple profiles',
                              image: 'assets/images/add_business.png',
                              function: () {
                                if (userController.currentUser.value.businessProfileAdmin!.length == 0)
                                  Get.off(() => AddBusinessProfile());
                                else {
                                  if (userController.currentAccount.value.membership == 'social value' || userController.currentAccount.value.membership == 'mainCourse')
                                    Get.off(() => AddBusinessProfile());
                                  else
                                    utilService.showUnlockDialog(10, VIEW_MEMBERSHIP, 'You need a subscription to add more than one social impact profile');
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    userController.currentUser.value.businessProfileAdmin!.length > 0
                        ? Obx(() {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        itemCount: userController.currentUser.value.businessProfileAdmin!.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) {
                          return FutureBuilder(
                            builder: (context, AsyncSnapshot<DocumentSnapshot<BusinessProfile>> snapshot) {
                              if (snapshot.hasData) {
                                BusinessProfile businessProfile = snapshot.data!.data() as BusinessProfile;
                                return BusinessProfileItem(businessProfileID: businessProfile.businessProfileID, isMyBusinessProfile: true);
                              } else
                                return Container();
                            },
                            future: firestoreService.getBusinessByBusinessID(userController.currentUser.value.businessProfileAdmin![i]),
                          );
                        },
                      );
                    })
                        : Padding(
                      padding: EdgeInsets.only(top: Get.height / 2 - 200, left: 25, right: 25),
                      child: Text(
                        'Create a new social value profile',
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.15,
                      ),
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
}
