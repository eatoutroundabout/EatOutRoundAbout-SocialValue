import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/models/product_model.dart';
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

class AddProduct extends StatelessWidget {
  final BusinessProfile? businessProfile;

  AddProduct({this.businessProfile});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController productNameTEC = TextEditingController();
  final TextEditingController priceTEC = TextEditingController();
  final TextEditingController descriptionTEC = TextEditingController();
  final TextEditingController websiteTEC = TextEditingController();
//  final TextEditingController youtubeLinkTEC = TextEditingController();
  final Rx<File> logoFile = File('').obs;
  final firestoreService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();
  final storageService = Get.find<StorageService>();
  final RxList images = [].obs;
  final privacyPolicy = true.obs;
  final tnc = true.obs;
  final utilService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15)),
      body: Column(
        children: [
          Heading(title: 'ADD A NEW PRODUCT', textScaleFactor: 1.75),
          Expanded(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('We promote venues that source with local producers. We market to app users to discover local products during hospitality visits. If you are a local producer then you can promote your products for local venue owners and managers to discover, promote and see other stockists for just £2.50 + VAT per month per product.'),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        File file = await storageService.pickImage();
                        if (file != null) logoFile.value = file;
                      },
                      child: Obx(() {
                        return Center(
                          child: CachedImage(
                            roundedCorners: true,
                            imageFile: logoFile.value.path == '' ? null : logoFile.value,
                            height: 150,
                            circular: false,
                            url: 'add',
                          ),
                        );
                      }),
                    ),
                    CustomTextField(validate: true, label: 'Product Name *', hint: 'Enter name', controller: productNameTEC, textInputType: TextInputType.text),
                    CustomTextField(validate: true, label: 'Price *', hint: 'Enter price', controller: priceTEC, textInputType: TextInputType.numberWithOptions(signed: false, decimal: true)),
                    CustomTextField(validate: true, label: 'Description *', hint: 'Enter description', controller: descriptionTEC, textInputType: TextInputType.multiline, maxLines: 5),
                    //CustomTextField(validate: true, label: 'YouTube Link *', hint: 'Enter link', controller: youtubeLinkTEC, textInputType: TextInputType.text),
                    CustomTextField(validate: true, label: 'Website *', hint: 'Enter link', controller: websiteTEC, textInputType: TextInputType.url),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 30, bottom: 15),
                      child: Text('Product Gallery *'),
                    ),
                    Container(
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
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: privacyPolicy.value,
                            focusColor: Colors.teal,
                            activeColor: Colors.green,
                            onChanged: (bool? newValue) => privacyPolicy.value = !privacyPolicy.value,
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: InkWell(
                            onTap: () => utilService.openLink('https://eatoutroundabout.co.uk/legals/privacy-policy/'),
                            child: Text('I agree to the Privacy Policy', textScaleFactor: 0.95),
                          ),
                        ),
                      ],
                    ),
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
                    SizedBox(height: 25),
                    CustomButton(
                      color: redColor,
                      text: 'Add Product',
                      function: () async {
                        if (!formKey.currentState!.validate()) {
                          showRedAlert('Please fill all the necessary details');
                          return;
                        }
                        if (images.isEmpty || logoFile.value.path == '') {
                          showRedAlert('Please add all the necessary images');
                          return;
                        }
                        final utilService = Get.find<UtilService>();
                        String documentID = Uuid().v1();
                        utilService.showLoading();
                        List finalImages = [];
                        for (int i = 0; i < images.length; i++) {
                          finalImages.add(await storageService.uploadImage(images[i]));
                        }
                        String logo = await storageService.uploadImage(logoFile.value);
                        Product product = Product(
                          userID: userController.currentUser.value.userID,
                          productID: documentID,
                          creationDate: Timestamp.now(),
                          accountID: userController.currentUser.value.accountID,
                          businessProfileID: businessProfile!.businessProfileID,
                          website: websiteTEC.text,
                          promoImage: logo,
                          description: descriptionTEC.text,
                          images: finalImages,
                          price: num.parse(priceTEC.text),
                          productName: productNameTEC.text,
                          venues: [],
                          category: '',
                          privacyPolicy: true,
                          tnc: true,
                        );
                        await firestoreService.addProduct(product);
                        Get.back();
                        Get.back();
                        showGreenAlert('Product added successfully');
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
}
