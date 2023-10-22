import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/models/offer_model.dart';
import 'package:eatoutroundabout/services/buy_service.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
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

class AddOffer extends StatefulWidget {
  final BusinessProfile? businessProfile;

  final bool? isBusinessOffer;
  final bool? isHospitalityOffer;
  final bool? isRetailOffer;

  AddOffer(
      {this.isBusinessOffer,
      this.isHospitalityOffer,
      this.isRetailOffer,
      this.businessProfile});

  @override
  State<AddOffer> createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOffer> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleTEC = TextEditingController();
  final TextEditingController offeringTEC = TextEditingController();
  final TextEditingController descriptionTEC = TextEditingController();
  final TextEditingController websiteTEC = TextEditingController();
  final TextEditingController quoteTEC = TextEditingController();
  final TextEditingController postCodeTEC = TextEditingController();
  final TextEditingController noVouchersTEC = TextEditingController();
  String offerType = 'select';
  final Rx<File> logoFile = File('').obs;
  final storageService = Get.find<StorageService>();
  final firestoreService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();
  List<DropdownMenuItem<String>> offerTypeItems = [];

  @override
  void initState() {
    if (widget!.isBusinessOffer!) {
      offerType = 'staffBenefits';
      offerTypeItems = [
        DropdownMenuItem(
            child: Text('Staff Benefits',
                textScaleFactor: 1, style: TextStyle(color: Colors.black)),
            value: 'staffBenefits'),
        DropdownMenuItem(
            child: Text('Hospitality Business Offer',
                textScaleFactor: 1, style: TextStyle(color: Colors.black)),
            value: 'hospitalityBusinessOffer'),
        DropdownMenuItem(
            child: Text('Work Place Well-being',
                textScaleFactor: 1, style: TextStyle(color: Colors.black)),
            value: 'wellBeing'),
      ];
    }
    if (widget!.isHospitalityOffer!) {
      offerType = 'celebrate';
      offerTypeItems = [
        DropdownMenuItem(
            child: Text('Celebrate',
                textScaleFactor: 1, style: TextStyle(color: Colors.black)),
            value: 'celebrate'),
        DropdownMenuItem(
            child: Text('Corporate Hospitality',
                textScaleFactor: 1, style: TextStyle(color: Colors.black)),
            value: 'corporateHospitality'),
      ];
    }
    if (widget!.isRetailOffer!) {
      offerType = 'retail';
      offerTypeItems = [
        DropdownMenuItem(
            child: Text('Retail Offer',
                textScaleFactor: 1, style: TextStyle(color: Colors.black)),
            value: 'retail'),
        DropdownMenuItem(
            child: Text('Culture',
                textScaleFactor: 1, style: TextStyle(color: Colors.black)),
            value: 'culture'),
        DropdownMenuItem(
            child: Text('High Street',
                textScaleFactor: 1, style: TextStyle(color: Colors.black)),
            value: 'highStreet'),
      ];
    }
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
          Heading(title: 'CREATE AN OFFER', textScaleFactor: 1.75),
          Expanded(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Create your offer for the Eat Out Round About business community.  Do you have a product or service that can help boost business culture, that you can offer to local staff as a benefit, or an offer you would like to provide local hospitality when they source locally with you?'),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        logoFile.value = await storageService.pickImage();
                      },
                      child: Obx(() {
                        return Center(
                          child: CachedImage(
                            roundedCorners: true,
                            imageFile: logoFile.value.path == ''
                                ? null
                                : logoFile.value,
                            height: 150,
                            circular: false,
                            url: 'add',
                          ),
                        );
                      }),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 30, bottom: 15),
                      child: Text('Offer Type *'),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide(
                                width: 2, color: Colors.teal.shade400),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                      isExpanded: true,
                      style: TextStyle(color: primaryColor, fontSize: 17),
                      value: offerType,
                      items: offerTypeItems,
                      onChanged: (value) => offerType = value!,
                    ),
                    CustomTextField(
                        validate: true,
                        label: 'No. of Vouchers *',
                        hint: 'Enter count',
                        controller: noVouchersTEC,
                        textInputType: TextInputType.numberWithOptions(
                            decimal: false, signed: false)),
                    CustomTextField(
                        validate: true,
                        label: 'Offer Title *',
                        hint: 'Enter title',
                        controller: titleTEC,
                        textInputType: TextInputType.text),
                    CustomTextField(
                        validate: true,
                        label: 'Offer Highlight *',
                        hint: 'E.g. : 20% OFF or Flat 10% OFF',
                        controller: offeringTEC,
                        textInputType: TextInputType.text),
                    CustomTextField(
                        validate: true,
                        label: 'Description *',
                        hint: 'Enter description',
                        controller: descriptionTEC,
                        textInputType: TextInputType.multiline,
                        maxLines: 5),
                    CustomTextField(
                        validate: true,
                        label: 'Postcode *',
                        hint: 'Enter postcode',
                        controller: postCodeTEC,
                        textInputType: TextInputType.text),
                    CustomTextField(
                        validate: true,
                        label: 'Offer Code *',
                        hint: 'Enter the code to quote for your offer',
                        controller: quoteTEC,
                        textInputType: TextInputType.text),
                    CustomTextField(
                        validate: true,
                        label: 'Website *',
                        hint: 'Enter link',
                        controller: websiteTEC,
                        textInputType: TextInputType.url),
                    SizedBox(height: 25),
                    CustomButton(
                      color: purpleColor,
                      text: 'Add Offer',
                      function: () async {
                        if (!formKey.currentState!.validate()) {
                          showRedAlert('Please fill all the necessary details');
                          return;
                        }
                        if (logoFile.value.path == '') {
                          showRedAlert('Please add the logo');
                          return;
                        }
                        final buyService = Get.find<BuyService>();
                        final utilService = Get.find<UtilService>();
                        utilService.showLoading();

                        bool success = widget!.isRetailOffer!
                            ? await buyService.processPayment(
                                amountToPay: num.parse(noVouchersTEC.text) * 10)
                            : true;
                        if (success) {
                          String documentID = Uuid().v1();
                          utilService.showLoading();
                          String logo =
                              await storageService.uploadImage(logoFile.value);
                          Offer offer = Offer(
                            accountID:
                                userController.currentUser.value.accountID,
                            businessProfileID:
                                widget.businessProfile!.businessProfileID,
                            creationDate: Timestamp.now(),
                            description: descriptionTEC.text,
                            offerID: documentID,
                            offering: offeringTEC.text,
                            postCode: postCodeTEC.text
                                .replaceAll(" ", "")
                                .toLowerCase(),
                            promoImage: logo,
                            title: titleTEC.text,
                            type: offerType,
                            quote: quoteTEC.text,
                            website: websiteTEC.text,
                          );
                          await firestoreService.addOffer(offer);
                          if (widget.isRetailOffer!) {
                            Map parameters = {
                              'accountID':
                                  userController.currentUser.value.accountID,
                              'campaignName': titleTEC.text,
                              'campaignStart':
                                  Timestamp.now().millisecondsSinceEpoch,
                              'campaignEnd': DateTime.now()
                                  .add(Duration(days: 7))
                                  .millisecondsSinceEpoch,
                              'displayMessage': descriptionTEC.text,
                              'voucherLogo': logo,
                              'voucherImage': logo,
                              'maxClaimsPerUser': 1,
                              'noVouchers': num.parse(noVouchersTEC.text),
                              'voucherOffer': "50% off up to £10",
                              'voucherType': offerType,
                            };
                            await cloudFunction(
                                functionName: 'createVouchers',
                                parameters: parameters,
                                action: () {
                                  Get.back();
                                  // showGreenAlert('Voucher created successfully');
                                });
                          }
                          Get.back();
                          Get.back();
                          showGreenAlert('Offer created successfully');
                        } else {
                          showRedAlert(
                              'Payment not successful. Please try again');
                        }
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
