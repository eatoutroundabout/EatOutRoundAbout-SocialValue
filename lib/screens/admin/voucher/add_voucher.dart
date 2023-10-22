import 'dart:io';

import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
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
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';

class AddVoucher extends StatefulWidget {
  final BusinessProfile? businessProfile;

  AddVoucher({this.businessProfile});

  @override
  State<AddVoucher> createState() => _AddVoucherState();
}

class _AddVoucherState extends State<AddVoucher> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController campaignNameTEC = TextEditingController();
  final TextEditingController displayNameTEC = TextEditingController();
  final TextEditingController maxClaimsTEC = TextEditingController();
  final TextEditingController noVouchersTEC = TextEditingController();
  final TextEditingController voucherOfferTEC = TextEditingController();
  final TextEditingController campaignStartDateTEC = TextEditingController();
  final TextEditingController campaignEndDateTEC = TextEditingController();
  final Rx<File> voucherImageFile = File('').obs;
  final storageService = Get.find<StorageService>();
  final firestoreService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();
  final RxBool addName = false.obs;

  num? startDate, endDate;

  @override
  void initState() {
    campaignNameTEC.text = widget.businessProfile!.businessName! + " - " + DateFormat('dd MMM yyyy').format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15)),
      body: Column(
        children: [
          Heading(title: 'CREATE A VOUCHER', textScaleFactor: 1.75),
          Expanded(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        voucherImageFile.value = await storageService.pickImage(aspectRatio: CropAspectRatioPreset.original);
                      },
                      child: Obx(() {
                        return Center(
                          child: Container(
                            margin: EdgeInsets.all(30),
                            width: 150,
                            height: 250,
                            child: CachedImage(
                              roundedCorners: true,
                              imageFile: voucherImageFile.value.path == '' ? null : voucherImageFile.value,
                              height: double.infinity,
                              circular: false,
                              url: 'voucherImage',
                            ),
                          ),
                        );
                      }),
                    ),
                    CustomTextField(validate: true, label: 'Campaign Name *', hint: 'Enter name', controller: campaignNameTEC, textInputType: TextInputType.text),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => selectDate(0),
                            child: CustomTextField(validate: true, enabled: false, label: 'Start Date *', hint: 'Select Date', controller: campaignStartDateTEC),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: InkWell(
                            onTap: () => selectDate(1),
                            child: CustomTextField(validate: true, enabled: false, label: 'End Date *', hint: 'Select Date', controller: campaignEndDateTEC),
                          ),
                        ),
                      ],
                    ),
                    CustomTextField(validate: true, label: 'Display Message *', hint: 'Enter message', controller: displayNameTEC, textInputType: TextInputType.text),
                    Obx(() {
                      return CheckboxListTile(
                        title: Text('Add name to the end of the message'),
                        onChanged: (val) => addName.value = val!,
                        value: addName.value,
                      );
                    }),
                    //CustomTextField(validate: true, label: 'Voucher Offer *', hint: 'Enter offer', controller: voucherOfferTEC, textInputType: TextInputType.text),
                    CustomTextField(validate: true, label: 'No. of Vouchers *', hint: 'Enter count', controller: noVouchersTEC, textInputType: TextInputType.numberWithOptions(decimal: false, signed: false)),
                    CustomTextField(validate: true, label: 'Max Claims per User *', hint: 'Max Claims per user', controller: maxClaimsTEC, textInputType: TextInputType.numberWithOptions(decimal: false, signed: false)),
                    SizedBox(height: 20),
                    CustomButton(
                      color: greenColor,
                      text: 'Create Voucher',
                      function: () async {
                        if (!formKey.currentState!.validate()) {
                          showRedAlert('Please fill all the necessary details');
                          return;
                        }
                        if (voucherImageFile.value.path == '') {
                          showRedAlert('Please add the voucher image');
                          return;
                        } else {
                          final buyService = Get.find<BuyService>();
                          final utilService = Get.find<UtilService>();
                          utilService.showLoading();
                          bool success = await buyService.processPayment(amountToPay: num.parse(noVouchersTEC.text) * 10);
                          success = true;

                          if (success) {
                            utilService.showLoading();
                            String logo = widget.businessProfile!.logo!;
                            String voucherImage = await storageService.uploadImage(voucherImageFile.value);
                            Map parameters = {
                              'accountID': userController.currentUser.value.accountID,
                              'campaignName': campaignNameTEC.text,
                              'campaignStart': startDate,
                              'campaignEnd': endDate,
                              'displayMessage': displayNameTEC.text + (addName.value ? ' !@#\$%' : ''),
                              'voucherLogo': logo,
                              'voucherImage': voucherImage,
                              'maxClaimsPerUser': num.parse(maxClaimsTEC.text),
                              'noVouchers': num.parse(noVouchersTEC.text),
                              'voucherOffer': "50% off up to £10",
                              'voucherType': 'standard',
                            };
                            Get.back();
                            await cloudFunction(
                                functionName: 'createVouchers',
                                parameters: parameters,
                                action: () {
                                  Get.back();
                                  Get.back();
                                  showGreenAlert('Voucher created successfully');
                                });
                          } else {
                            showRedAlert('Payment not successful. Please try again');
                          }
                        }
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  selectDate(int type) async {
    DatePicker.showDateTimePicker(
      Get.context!,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime.now().add(Duration(days: 365)),
      onChanged: (date) {},
      onConfirm: (pickedDate) {
        if (pickedDate != null) {
          if (type == 0) {
            startDate = pickedDate.millisecondsSinceEpoch;
            campaignStartDateTEC.text = DateFormat('dd MMM yyyy, hh:mm aa').format(pickedDate);
          } else {
            endDate = pickedDate.millisecondsSinceEpoch;
            campaignEndDateTEC.text = DateFormat('dd MMM yyyy, hh:mm aa').format(pickedDate);
          }
        }
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }
}
