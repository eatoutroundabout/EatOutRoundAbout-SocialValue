import 'dart:io';

import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/models/offer_model.dart';
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

class EditOffer extends StatefulWidget {
  final Offer? offer;

  EditOffer({this.offer});

  @override
  State<EditOffer> createState() => _EditOfferState();
}

class _EditOfferState extends State<EditOffer> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleTEC = TextEditingController();
  final TextEditingController offeringTEC = TextEditingController();
  final TextEditingController descriptionTEC = TextEditingController();
  final TextEditingController websiteTEC = TextEditingController();
  final TextEditingController quoteTEC = TextEditingController();
  final TextEditingController postCodeTEC = TextEditingController();
  String offerType = 'culture';
  final Rx<File> logoFile = File('').obs;
  final storageService = Get.find<StorageService>();
  final RxString businessProfileID = ''.obs;
  final RxString businessProfileName = ''.obs;
  String? businessProfileLocalAuth;
  final userController = Get.find<UserController>();
  final firestoreService = Get.find<FirestoreService>();
  String? logo;

  @override
  void initState() {
    titleTEC.text = widget.offer!.title!;
    offeringTEC.text = widget.offer!.offering!;
    descriptionTEC.text = widget.offer!.description!;
    websiteTEC.text = widget.offer!.website!;
    quoteTEC.text = widget.offer!.quote!;
    postCodeTEC.text = widget.offer!.postCode!;
    logo = widget.offer!.promoImage;
    offerType = widget.offer!.type!;
    websiteTEC.text = widget.offer!.website!;
    businessProfileID.value = widget.offer!.businessProfileID!;
    getBusinessName();
    super.initState();
  }

  getBusinessName() async {
    BusinessProfile? n = (await firestoreService
            .getBusinessByBusinessID(businessProfileID.value))
        .data();
    businessProfileName.value = n!.businessName!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Image.asset('assets/images/applogo.png',
              height: AppBar().preferredSize.height - 15)),
      body: Column(
        children: [
          Heading(title: 'EDIT OFFER', textScaleFactor: 1.75),
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
                            url: logo,
                          ),
                        );
                      }),
                    ),
                    // Obx(() {
                    //   return InkWell(
                    //     onTap: () {
                    //       Get.defaultDialog(
                    //           title: 'Select the business',
                    //           content: Container(
                    //             height: userController.currentUser.value.businessProfileAdmin.length * 45.0 + 30,
                    //             width: Get.width,
                    //             child: ListView.builder(
                    //               padding: EdgeInsets.symmetric(horizontal: padding),
                    //               itemCount: userController.currentUser.value.businessProfileAdmin.length,
                    //               shrinkWrap: true,
                    //               physics: NeverScrollableScrollPhysics(),
                    //               itemBuilder: (context, i) {
                    //                 return FutureBuilder(
                    //                   builder: (context, AsyncSnapshot<DocumentSnapshot<BusinessProfile>> snapshot) {
                    //                     if (snapshot.hasData) {
                    //                       BusinessProfile businessProfile = snapshot.data.data();
                    //                       return ListTile(
                    //                         onTap: () {
                    //                           Get.back();
                    //                           businessProfileID.value = businessProfile.businessProfileID;
                    //                           businessProfileName.value = businessProfile.businessName;
                    //                           businessProfileLocalAuth = businessProfile.localAuth;
                    //                         },
                    //                         title: Text(businessProfile.businessName),
                    //                         trailing: Text('SELECT', textScaleFactor: 0.9, style: TextStyle(color: greenColor)),
                    //                       );
                    //                     } else
                    //                       return LoadingData();
                    //                   },
                    //                   future: firestoreService.getBusinessByBusinessID(userController.currentUser.value.businessProfileAdmin[i]),
                    //                 );
                    //               },
                    //             ),
                    //           ));
                    //     },
                    //     child: CustomTextField(enabled: false, controller: TextEditingController(text: businessProfileName.value), label: 'Business *', hint: 'Select a Business Profile'),
                    //   );
                    // }),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20, top: 30, bottom: 15),
                    //   child: Text('Offer Type *'),
                    // ),
                    // DropdownButtonFormField<String>(
                    //   decoration: InputDecoration(
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(50.0),
                    //         borderSide: BorderSide(width: 2, color: Colors.teal.shade400),
                    //       ),
                    //       filled: true,
                    //       fillColor: Colors.white,
                    //       contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                    //   isExpanded: true,
                    //   style: TextStyle(color: primaryColor, fontSize: 17),
                    //   value: offerType,
                    //   items: [
                    //     DropdownMenuItem(child: Text('Culture', textScaleFactor: 1, style: TextStyle(color: Colors.black)), value: 'culture'),
                    //     DropdownMenuItem(child: Text('Staff Benefits', textScaleFactor: 1, style: TextStyle(color: Colors.black)), value: 'staffBenefits'),
                    //     DropdownMenuItem(child: Text('Business Offer', textScaleFactor: 1, style: TextStyle(color: Colors.black)), value: 'businessOffer'),
                    //   ],
                    //   onChanged: (value) => offerType = value,
                    // ),
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
                      text: 'Edit Offer',
                      function: () async {
                        if (!formKey.currentState!.validate()) {
                          showRedAlert('Please fill all the necessary details');
                          return;
                        }
                        final utilService = Get.find<UtilService>();
                        utilService.showLoading();
                        String logo = logoFile.value.path != ''
                            ? await storageService.uploadImage(logoFile.value)
                            : widget.offer!.promoImage;
                        Offer offer = Offer(
                          accountID: widget.offer!.accountID,
                          businessProfileID: businessProfileID.value,
                          creationDate: widget.offer!.creationDate,
                          description: descriptionTEC.text,
                          offerID: widget.offer!.offerID,
                          offering: offeringTEC.text,
                          postCode: postCodeTEC.text
                              .replaceAll(" ", "")
                              .toLowerCase(),
                          businessProfileLocalAuth: businessProfileLocalAuth,
                          promoImage: logo,
                          title: titleTEC.text,
                          type: offerType,
                          quote: quoteTEC.text,
                          website: websiteTEC.text,
                        );
                        await firestoreService.editOffer(offer);
                        Get.back();
                        Get.back();
                        showGreenAlert('Offer created successfully');
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
