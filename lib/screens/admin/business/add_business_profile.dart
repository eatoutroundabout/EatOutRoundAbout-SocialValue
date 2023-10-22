import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/storage_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddBusinessProfile extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController businessNameTEC = TextEditingController(), summaryTEC = TextEditingController(), descriptionTEC = TextEditingController();
  final TextEditingController streetAddressTEC = TextEditingController(), townTEC = TextEditingController(), postCodeTEC = TextEditingController();
  final TextEditingController fbTEC = TextEditingController(), instaTEC = TextEditingController(), twTEC = TextEditingController(), liTEC = TextEditingController();
  final Rx<File> logoFile = File('').obs;
  final storageService = Get.find<StorageService>();
  final tnc = true.obs;
  final utilService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15)),
      body: Column(
        children: [
          Heading(title: 'ADD A LOCAL BUSINESS PROFILE', textScaleFactor: 1.75),
          Expanded(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(padding),
                child: Column(
                  children: [
                    Text('Make your business visible in the community.  When you create a business profile it works like a page that is visible from your personal profile and any additional marketing you do on Eat Out Round About!'),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        logoFile.value = await storageService.pickImage();
                      },
                      child: Obx(() {
                        return CachedImage(
                          roundedCorners: true,
                          imageFile: logoFile.value.path == '' ? null : logoFile.value,
                          height: 150,
                          circular: false,
                          url: 'add',
                        );
                      }),
                    ),
                    CustomTextField(validate: true, label: 'Business Name *', hint: 'Enter Business Name', controller: businessNameTEC, textInputType: TextInputType.text),
                    CustomTextField(validate: true, label: 'Summary *', hint: 'Enter summary', controller: summaryTEC, textInputType: TextInputType.multiline, maxLines: 3),
                    CustomTextField(validate: true, label: 'Description *', hint: 'Enter description', controller: descriptionTEC, textInputType: TextInputType.multiline, maxLines: 5),
                    CustomTextField(label: 'Street Address', hint: 'Enter Street Address', controller: streetAddressTEC, textInputType: TextInputType.text),
                    CustomTextField(label: 'Town', hint: 'Enter town', controller: townTEC, textInputType: TextInputType.text),
                    CustomTextField(validate: true, label: 'Postcode *', hint: 'Enter postcode', controller: postCodeTEC, textInputType: TextInputType.text),
                    CustomTextField(controller: fbTEC, hint: 'Enter Facebook Link', label: 'Facebook Link', textInputType: TextInputType.url),
                    CustomTextField(controller: instaTEC, hint: 'Enter Instagram Link', label: 'Instagram Link', textInputType: TextInputType.url),
                    CustomTextField(controller: twTEC, hint: 'Enter Twitter Link', label: 'Twitter Link', textInputType: TextInputType.url),
                    CustomTextField(controller: liTEC, hint: 'Enter LinkedIn Link', label: 'LinkedIn Link', textInputType: TextInputType.url),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: tnc.value,
                            focusColor: Colors.teal,
                            activeColor: Colors.green,
                            onChanged: (bool? newValue) => tnc.value = !tnc.value,
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: InkWell(
                            onTap: () => utilService.openLink('https://eatoutroundabout.co.uk/legals/purchaser-terms-and-conditions'),
                            child: Text('I agree to the Business Terms and Conditions', textScaleFactor: 0.95),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => utilService.openLink('https://eatoutroundabout.co.uk/legals/privacy-policy/'),
                      child: Text('To understand more about how we will use your information please see our privacy policy.', textAlign: TextAlign.center, textScaleFactor: 0.95, style: TextStyle(decoration: TextDecoration.underline)),
                    ),
                    SizedBox(height: 25),
                    CustomButton(
                      color: purpleColor,
                      text: 'Add Business Profile',
                      function: () async {
                        if (!formKey.currentState!.validate()) {
                          showRedAlert('Please fill all the necessary details');
                          return;
                        }
                        if (!tnc.value) return showRedAlert('Please accept the Terms and Conditions to proceed');

                        if (logoFile.value.path == '') {
                          showRedAlert('Please add the logo');
                          return;
                        }
                        final utilService = Get.find<UtilService>();
                        final userController = Get.find<UserController>();
                        final firestoreService = Get.find<FirestoreService>();
                        String documentID = Uuid().v1();
                        utilService.showLoading();
                        String logo = await storageService.uploadImage(logoFile.value);
                        String localAuth = await firestoreService.getLAUAForPostcode(postCodeTEC.text.replaceAll(" ", "").toLowerCase());

                        BusinessProfile businessProfile = BusinessProfile(
                          businessProfileID: documentID,
                          userID: userController.currentUser.value.userID,
                          accountID: userController.currentUser.value.accountID,
                          businessName: businessNameTEC.text,
                          summary: summaryTEC.text,
                          description: descriptionTEC.text,
                          facebook: fbTEC.text,
                          instagram: instaTEC.text,
                          twitter: twTEC.text,
                          linkedIn: liTEC.text,
                          logo: logo,
                          postcode: postCodeTEC.text.replaceAll(" ", "").toLowerCase(),
                          localAuth: localAuth,
                          streetAddress: streetAddressTEC.text,
                          townCity: townTEC.text,
                          creationDate: Timestamp.now(),
                          privacyPolicy: true,
                          tnc: true,
                          lm3ImpactValue: 0,
                        );
                        await firestoreService.addBusinessProfile(businessProfile);
                        userController.currentUser.value.businessProfileAdmin!.add(businessProfile.businessProfileID);
                        await firestoreService.updateUser({'businessProfileAdmin': userController.currentUser.value.businessProfileAdmin});
                        Get.back();
                        Get.back();
                        showGreenAlert('Business Profile added successfully');
                      },
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
