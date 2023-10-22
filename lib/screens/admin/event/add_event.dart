import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/models/event_model.dart';
import 'package:eatoutroundabout/services/buy_service.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/storage_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/utils/dietary_constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nanoid/async.dart';
import 'package:uuid/uuid.dart';

class AddEvent extends StatelessWidget {
  final BusinessProfile? businessProfile;

  AddEvent({this.businessProfile});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController eventTitleTEC = TextEditingController(), summaryTEC = TextEditingController(), descriptionTEC = TextEditingController(), noAttendeesTEC = TextEditingController(), eventTypeTEC = TextEditingController(), priceTEC = TextEditingController(), startDateTEC = TextEditingController(), endDateTEC = TextEditingController();
  final TextEditingController streetAddressTEC = TextEditingController(), townTEC = TextEditingController(), postCodeTEC = TextEditingController();
  final TextEditingController fbTEC = TextEditingController(), bookingLinkTEC = TextEditingController(), otherLinkTEC = TextEditingController(), liTEC = TextEditingController(), ebeID = TextEditingController(), eboID = TextEditingController();
  final RxList images = [].obs;
  final RxBool isPublic = true.obs;
  final storageService = Get.find<StorageService>();
  RxString eventType = 'business'.obs;
  DateTime? startDate, endDate;
  Rx<String> category = 'Business & Professional'.obs;
  final tnc = true.obs;
  final utilService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15)),
      body: Column(
        children: [
          Heading(title: 'ADD A NEW EVENT', textScaleFactor: 1.75),
          Expanded(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      height: 120,
                      child: Row(
                        children: [
                          addImageButton(),
                          Expanded(
                            child: Obx(
                              () => ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: images.length,
                                itemBuilder: (context, i) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: InkWell(
                                      onTap: () => images.remove(images[i]),
                                      child: Stack(
                                        children: [
                                          CachedImage(height: 120, roundedCorners: true, imageFile: images[i]),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 90),
                                            child: Icon(Icons.remove_circle, color: Colors.red, size: 25),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => selectDate(0),
                            child: CustomTextField(validate: true, enabled: false, label: 'Start Date *', hint: 'Select Date', controller: startDateTEC),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: InkWell(
                            onTap: () => selectDate(1),
                            child: CustomTextField(validate: true, enabled: false, label: 'End Date *', hint: 'Select Date', controller: endDateTEC),
                          ),
                        ),
                      ],
                    ),
                    CustomTextField(validate: true, label: 'Event Title *', hint: 'Enter title', controller: eventTitleTEC, textInputType: TextInputType.text),
                    CustomTextField(validate: true, label: 'Summary *', hint: 'Enter summary', controller: summaryTEC, textInputType: TextInputType.multiline, maxLines: 3),
                    CustomTextField(validate: true, label: 'Description *', hint: 'Enter description', controller: descriptionTEC, textInputType: TextInputType.multiline, maxLines: 5),
                    CustomTextField(dropdown: dropDown(), label: 'Category *'),
                    CustomTextField(validate: true, label: 'Attendees Capacity *', hint: 'Enter count', controller: noAttendeesTEC, textInputType: TextInputType.numberWithOptions(signed: false, decimal: false)),
                    CustomTextField(validate: true, label: 'Price Per Head *', hint: 'Enter price', controller: priceTEC, textInputType: TextInputType.numberWithOptions(signed: false, decimal: true)),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 30, bottom: 15),
                      child: Text('Event Type *'),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide(width: 2, color: Colors.teal.shade400),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                      isExpanded: true,
                      style: TextStyle(color: primaryColor, fontSize: 17),
                      value: eventType.value,
                      items: [
                        DropdownMenuItem(child: Text('Online', textScaleFactor: 1, style: TextStyle(color: Colors.black)), value: 'online'),
                        DropdownMenuItem(child: Text('Face To Face', textScaleFactor: 1, style: TextStyle(color: Colors.black)), value: 'faceToface'),
                        DropdownMenuItem(child: Text('Festival', textScaleFactor: 1, style: TextStyle(color: Colors.black)), value: 'festival'),
                        DropdownMenuItem(child: Text('Business', textScaleFactor: 1, style: TextStyle(color: Colors.black)), value: 'business'),
                      ],
                      onChanged: (value) => eventType.value = value!,
                    ),
                    Obx(() {
                      if (eventType.value != 'online')
                        return Column(
                          children: [
                            CustomTextField(label: 'Street Address', hint: 'Enter Street Address', controller: streetAddressTEC, textInputType: TextInputType.text),
                            CustomTextField(label: 'Town', hint: 'Enter town', controller: townTEC, textInputType: TextInputType.text),
                          ],
                        );
                      return Container();
                    }),
                    CustomTextField(validate: true, label: 'Postcode *', hint: 'Enter postcode', controller: postCodeTEC, textInputType: TextInputType.text),
                    CustomTextField(controller: fbTEC, hint: 'Enter Facebook Link', label: 'Facebook Link', textInputType: TextInputType.url),
                    CustomTextField(controller: liTEC, hint: 'Enter LinkedIn Link', label: 'LinkedIn Link', textInputType: TextInputType.url),
                    CustomTextField(controller: bookingLinkTEC, hint: 'Enter Booking Link', label: 'Booking Link', textInputType: TextInputType.url),
                    CustomTextField(controller: otherLinkTEC, hint: 'Enter Link', label: 'Other Link', textInputType: TextInputType.url),
                    //CustomTextField(label: 'Eventbrite Event ID', hint: 'Enter ID', controller: ebeID, textInputType: TextInputType.text),
                    //CustomTextField(label: 'Eventbrite Organization ID', hint: 'Enter ID', controller: eboID, textInputType: TextInputType.text),
                    SizedBox(height: 15),
                    Obx(
                      () => CheckboxListTile(
                        title: Text('Promote this event to business members'),
                        onChanged: (val) => isPublic.value = val!,
                        value: isPublic.value,
                      ),
                    ),
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
                            child: Text('I agree to the Terms and Conditions', textScaleFactor: 0.95),
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
                      color: greenColor,
                      text: 'Proceed',
                      function: () async {
                        if (!formKey.currentState!.validate()) {
                          showRedAlert('Please fill all the necessary details');
                          return;
                        }
                        if (!tnc.value) return showRedAlert('Please accept the Terms and Conditions to proceed');
                        if (images.isEmpty) {
                          showRedAlert('Please add at least one event image');
                          return;
                        }
                        final buyService = Get.find<BuyService>();
                        final userController = Get.find<UserController>();
                        bool success = userController.currentAccount.value.isPartner! ? true : await buyService.processPayment(amountToPay: num.parse(noAttendeesTEC.text) * 10);

                        if (success) {
                          final utilService = Get.find<UtilService>();
                          final userController = Get.find<UserController>();
                          final firestoreService = Get.find<FirestoreService>();
                          String documentID = Uuid().v1();
                          utilService.showLoading();
                          List finalImages = [];
                          for (int i = 0; i < images.length; i++) {
                            finalImages.add(await storageService.uploadImage(images[i]));
                          }
                          String eventCode = await customAlphabet('1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ', 6);

                          Event event = Event(
                            eventID: documentID,
                            eventCode: eventCode,
                            businessProfileID: businessProfile!.businessProfileID,
                            userID: userController.currentUser.value.userID,
                            accountID: userController.currentUser.value.accountID,
                            eventTitle: eventTitleTEC.text,
                            summary: summaryTEC.text,
                            streetAddress: streetAddressTEC.text,
                            townCity: townTEC.text,
                            postCode: postCodeTEC.text.replaceAll(" ", "").toLowerCase(),
                            description: descriptionTEC.text,
                            category: category.value,
                            capacity: num.parse(noAttendeesTEC.text),
                            bookingLink: bookingLinkTEC.text,
                            facebookLink: fbTEC.text,
                            linkedInLink: liTEC.text,
                            otherLink: otherLinkTEC.text,
                            eventType: eventType.value,
                            publicEvent: isPublic.value,
                            eventImages: finalImages,
                            eventBriteEventID: ebeID.text,
                            eventBriteOrgID: eboID.text,
                            eventDateTimeFrom: Timestamp.fromDate(startDate!),
                            eventDateTimeTo: Timestamp.fromDate(endDate!),
                            creationDate: Timestamp.now(),
                            pricePerHead: num.parse(priceTEC.text),
                            attendeeUserIDs: [],
                            checkedInUserIDs: [],
                            privacyPolicy: true,
                            tnc: true,
                            approved: false,
                          );
                          Map parameters = {
                            'accountID': userController.currentUser.value.accountID,
                            'campaignName': eventTitleTEC.text,
                            'campaignStart': startDate!.millisecondsSinceEpoch,
                            'campaignEnd': endDate!.add(Duration(days: 7)).millisecondsSinceEpoch,
                            'displayMessage': summaryTEC.text,
                            'voucherLogo': finalImages[0],
                            'voucherImage': finalImages[0],
                            'maxClaimsPerUser': 1,
                            'noVouchers': num.parse(noAttendeesTEC.text),
                            'voucherOffer': "50% off up to £10",
                            'voucherType': 'event',
                          };
                          await firestoreService.addEvent(event);
                          await cloudFunction(
                              functionName: 'createVouchers',
                              parameters: parameters,
                              action: () {
                                Get.back();
                                // showGreenAlert('Voucher created successfully');
                              });
                          Get.back();
                          Get.back();
                          Get.back();

                          showGreenAlert('Event added successfully');
                        } else {
                          showRedAlert('Payment not successful. Please try again');
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

  addImageButton() {
    return InkWell(
      onTap: () async {
        File file = await storageService.pickImage();
        if (file != null) images.add(file);
      },
      child: Container(
        width: 120,
        height: 120,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(padding / 2),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 30, color: primaryColor),
            SizedBox(height: 10),
            Text('Add Image', textScaleFactor: 1, style: TextStyle(color: primaryColor)),
          ],
        ),
      ),
    );
  }

  selectDate(int type) async {
    DatePicker.showDateTimePicker(
      Get.context!,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime(2100),
      onChanged: (date) {},
      onConfirm: (pickedDate) {
        if (pickedDate != null) {
          if (type == 0) {
            startDate = pickedDate;
            startDateTEC.text = DateFormat('dd MMM yyyy, hh:mm aa').format(pickedDate);
          } else {
            endDate = pickedDate;
            endDateTEC.text = DateFormat('dd MMM yyyy, hh:mm aa').format(pickedDate);
          }
        }
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }

  dropDown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0), borderSide: BorderSide(width: 2, color: Colors.teal.shade400)), filled: true, fillColor: Colors.white, contentPadding: EdgeInsets.symmetric(horizontal: 20)),
      isExpanded: true,
      style: TextStyle(color: primaryColor, fontSize: 17),
      value: category.value,
      items: eventCategories.map((value) => DropdownMenuItem<String>(value: value, child: Text(value, textScaleFactor: 1, style: TextStyle(color: Colors.black)))).toList(),
      onChanged: (value) => category.value = value!,
    );
  }
}
