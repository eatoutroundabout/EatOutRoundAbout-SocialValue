import 'dart:io';

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

class EditBusinessProfile extends StatefulWidget {
  final BusinessProfile? businessProfile;

  EditBusinessProfile({this.businessProfile});

  @override
  State<EditBusinessProfile> createState() => _EditBusinessProfileState();
}

class _EditBusinessProfileState extends State<EditBusinessProfile> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController businessNameTEC = TextEditingController(),
      summaryTEC = TextEditingController(),
      descriptionTEC = TextEditingController();
  final TextEditingController streetAddressTEC = TextEditingController(),
      townTEC = TextEditingController(),
      postCodeTEC = TextEditingController();
  final TextEditingController fbTEC = TextEditingController(),
      instaTEC = TextEditingController(),
      twTEC = TextEditingController(),
      liTEC = TextEditingController();
  final Rx<File> logoFile = File('').obs;
  final storageService = Get.find<StorageService>();
  String? logo;

  @override
  void initState() {
    businessNameTEC.text = widget.businessProfile!.businessName!;
    summaryTEC.text = widget.businessProfile!.summary!;
    descriptionTEC.text = widget.businessProfile!.description!;
    streetAddressTEC.text = widget.businessProfile!.streetAddress!;
    townTEC.text = widget.businessProfile!.townCity!;
    postCodeTEC.text = widget.businessProfile!.postcode!;
    fbTEC.text = widget.businessProfile!.facebook!;
    instaTEC.text = widget.businessProfile!.instagram!;
    twTEC.text = widget.businessProfile!.twitter!;
    liTEC.text = widget.businessProfile!.linkedIn!;
    logo = widget.businessProfile!.logo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Image.asset('assets/images/applogo.png',
              height: AppBar().preferredSize.height - 15)),
      body: Column(
        children: [
          Heading(title: 'EDIT BUSINESS PROFILE', textScaleFactor: 1.75),
          Expanded(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(padding),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        logoFile.value = await storageService.pickImage();
                      },
                      child: Obx(() {
                        return CachedImage(
                          roundedCorners: true,
                          imageFile:
                              logoFile.value.path == '' ? null : logoFile.value,
                          height: 150,
                          circular: false,
                          url: logo,
                        );
                      }),
                    ),
                    CustomTextField(
                        validate: true,
                        label: 'Business Name *',
                        hint: 'Enter Business Name',
                        controller: businessNameTEC,
                        textInputType: TextInputType.text),
                    CustomTextField(
                        validate: true,
                        label: 'Summary *',
                        hint: 'Enter summary',
                        controller: summaryTEC,
                        textInputType: TextInputType.multiline,
                        maxLines: 3),
                    CustomTextField(
                        validate: true,
                        label: 'Description *',
                        hint: 'Enter description',
                        controller: descriptionTEC,
                        textInputType: TextInputType.multiline,
                        maxLines: 5),
                    CustomTextField(
                        label: 'Street Address ',
                        hint: 'Enter Street Address',
                        controller: streetAddressTEC,
                        textInputType: TextInputType.text),
                    CustomTextField(
                        label: 'Town ',
                        hint: 'Enter town',
                        controller: townTEC,
                        textInputType: TextInputType.text),
                    CustomTextField(
                        validate: true,
                        label: 'Postcode *',
                        hint: 'Enter postcode',
                        controller: postCodeTEC,
                        textInputType: TextInputType.text),
                    CustomTextField(
                        controller: fbTEC,
                        hint: 'Enter Facebook Link',
                        label: 'Facebook Link',
                        textInputType: TextInputType.url),
                    CustomTextField(
                        controller: instaTEC,
                        hint: 'Enter Instagram Link',
                        label: 'Instagram Link',
                        textInputType: TextInputType.url),
                    CustomTextField(
                        controller: twTEC,
                        hint: 'Enter Twitter Link',
                        label: 'Twitter Link',
                        textInputType: TextInputType.url),
                    CustomTextField(
                        controller: liTEC,
                        hint: 'Enter LinkedIn Link',
                        label: 'LinkedIn Link',
                        textInputType: TextInputType.url),
                    SizedBox(height: 25),
                    CustomButton(
                      color: purpleColor,
                      text: 'Edit Business Profile',
                      function: () async {
                        if (!formKey.currentState!.validate()) {
                          showRedAlert('Please fill all the necessary details');
                          return;
                        }
                        final utilService = Get.find<UtilService>();
                        final firestoreService = Get.find<FirestoreService>();
                        utilService.showLoading();
                        String logo = logoFile.value.path != ''
                            ? await storageService.uploadImage(logoFile.value)
                            : widget.businessProfile!.logo;
                        String localAuth = await firestoreService
                            .getLAUAForPostcode(postCodeTEC.text
                                .replaceAll(" ", "")
                                .toLowerCase());
                        BusinessProfile businessProfile = BusinessProfile(
                          businessName: businessNameTEC.text,
                          summary: summaryTEC.text,
                          description: descriptionTEC.text,
                          facebook: fbTEC.text,
                          instagram: instaTEC.text,
                          twitter: twTEC.text,
                          linkedIn: liTEC.text,
                          logo: logo,
                          postcode: postCodeTEC.text
                              .replaceAll(" ", "")
                              .toLowerCase(),
                          localAuth: localAuth,
                          streetAddress: streetAddressTEC.text,
                          townCity: townTEC.text,
                          creationDate: widget.businessProfile!.creationDate,
                          userID: widget.businessProfile!.userID,
                          businessProfileID:
                              widget.businessProfile!.businessProfileID,
                          accountID: widget.businessProfile!.accountID,
                        );
                        await firestoreService
                            .editBusinessProfile(businessProfile);
                        Get.back();
                        Get.back();
                        showGreenAlert('Business Profile updated successfully');
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
