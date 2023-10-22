import 'dart:io';

import 'package:eatoutroundabout/controllers/user_controller.dart';
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

class EditProduct extends StatefulWidget {
  final Product? product;

  EditProduct({this.product});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController productNameTEC = TextEditingController();
  final TextEditingController priceTEC = TextEditingController();
  final TextEditingController descriptionTEC = TextEditingController();
  final TextEditingController websiteTEC = TextEditingController();
  final Rx<File> logoFile = File('').obs;
  final firestoreService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();
  final storageService = Get.find<StorageService>();
  final RxList images = [].obs;
  String? logo;
  List? productImages;

  @override
  void initState() {
    productNameTEC.text = widget.product!.productName!;
    priceTEC.text = widget.product!.price.toString();
    descriptionTEC.text = widget.product!.description!;
    websiteTEC.text = widget.product!.website!;
    logo = widget.product!.promoImage;
    productImages = widget.product!.images;
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
          Heading(title: 'EDIT PRODUCT', textScaleFactor: 1.75),
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
                    CustomTextField(
                        validate: true,
                        label: 'Product Name *',
                        hint: 'Enter name',
                        controller: productNameTEC,
                        textInputType: TextInputType.text),
                    CustomTextField(
                        validate: true,
                        label: 'Price *',
                        hint: 'Enter price',
                        controller: priceTEC,
                        textInputType: TextInputType.numberWithOptions(
                            signed: false, decimal: true)),
                    CustomTextField(
                        validate: true,
                        label: 'Description *',
                        hint: 'Enter description',
                        controller: descriptionTEC,
                        textInputType: TextInputType.multiline,
                        maxLines: 5),
                    // CustomTextField(validate: true,
                    //     label: 'YouTube Link *',
                    //     hint: 'Enter link',
                    //     controller: youtubeLinkTEC,
                    //     textInputType: TextInputType.text),
                    CustomTextField(
                        validate: true,
                        label: 'Website *',
                        hint: 'Enter link',
                        controller: websiteTEC,
                        textInputType: TextInputType.url),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20, top: 30, bottom: 15),
                    //   child: Text('Product Gallery *'),
                    // ),
                    // Container(
                    //   height: 120,
                    //   child: Row(
                    //     children: [
                    //       addImageButton(),
                    //       Expanded(
                    //         child: Obx(
                    //           () => ListView.builder(
                    //             scrollDirection: Axis.horizontal,
                    //             itemCount: images.length,
                    //             itemBuilder: (context, i) {
                    //               return Padding(
                    //                 padding: const EdgeInsets.only(right: 10),
                    //                 child: InkWell(
                    //                   onTap: () => images.remove(images[i]),
                    //                   child: Stack(
                    //                     children: [
                    //                       CachedImage(height: 120, roundedCorners: true, imageFile: images[i]),
                    //                       Padding(
                    //                         padding: const EdgeInsets.only(left: 90),
                    //                         child: Icon(Icons.remove_circle, color: Colors.red, size: 25),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               );
                    //             },
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: 25),
                    CustomButton(
                      color: redColor,
                      text: 'Edit Product',
                      function: () async {
                        if (!formKey.currentState!.validate()) {
                          showRedAlert('Please fill all the necessary details');
                          return;
                        }
                        final utilService = Get.find<UtilService>();
                        utilService.showLoading();
                        // List finalImages = widget.product.images;
                        // for (int i = 0; i < images.length; i++) {
                        //   finalImages.add(await storageService.uploadImage(images[i]));
                        // }
                        String logo = logoFile.value.path != ''
                            ? await storageService.uploadImage(logoFile.value)
                            : widget.product!.promoImage;
                        Product product = Product(
                          userID: userController.currentUser.value.userID,
                          productID: widget.product!.productID,
                          creationDate: widget.product!.creationDate,
                          accountID: widget.product!.accountID,
                          businessProfileID: widget.product!.businessProfileID,
                          website: websiteTEC.text,
                          promoImage: logo,
                          description: descriptionTEC.text,
                          images: widget.product!.images,
                          price: num.parse(priceTEC.text),
                          productName: productNameTEC.text,
                          venues: widget.product!.venues,
                          category: widget.product!.category,
                        );
                        await firestoreService.editProduct(product);
                        Get.back();
                        Get.back();
                        showGreenAlert('Product updated successfully');
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
            Text('Add Image',
                textScaleFactor: 1, style: TextStyle(color: primaryColor)),
          ],
        ),
      ),
    );
  }
}
