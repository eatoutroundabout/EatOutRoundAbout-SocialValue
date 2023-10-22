import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/screens/buy/checkout.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BuyVouchers extends StatefulWidget {
  @override
  _BuyVouchersState createState() => _BuyVouchersState();
}

class _BuyVouchersState extends State<BuyVouchers> {
  num uploadProgress = 0;
  TextEditingController mobileTEC = TextEditingController();
  TextEditingController displayMessageTEC = TextEditingController();
  TextEditingController discountCodeTEC = TextEditingController();
  List packageTitle = ['Buy 1 Voucher', 'Buy 3 Vouchers ', 'Buy 8 Vouchers'];
  List freeItems = ['', 'Get 1 free', 'Get 3 free'];
  List qty = [1, 3, 8];
  List freeQty = [0, 1, 3];
  List price = [10, 30, 80];
  File? imageUrl;
  num discount = 0;
  String? imageURL;

  final userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showIntro();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'BUY VOUCHERS'),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.only(left: 45, top: 25, bottom: 25),
                    child: Row(
                      children: [
                        Text(
                          'Select a Package',
                          textScaleFactor: 1.25,
                          style: TextStyle(color: Colors.teal),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Swiper(
                      loop: false,
                      viewportFraction: 0.85,
                      itemBuilder: (context, i) {
                        return Container(
                          height: double.infinity,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(right: 15, bottom: 25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(padding / 2),
                            border: Border.all(color: Colors.teal, width: 2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text(packageTitle[i], textScaleFactor: 1.35, style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Text(freeItems[i], textScaleFactor: 1.2, style: TextStyle(fontWeight: FontWeight.bold, color: greenColor)),
                              SizedBox(height: 25),
                              Expanded(
                                child: Image.asset(
                                  'assets/images/buy${i + 1}.jpeg',
                                ),
                              ),
                              SizedBox(height: 25),
                              Text('£' + price[i].toString(), textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold, color: orangeColor)),
                              SizedBox(height: 25),
                              CustomButton(
                                text: 'Buy Now',
                                function: () async {
                                  String mobileNumber = userController.currentUser!.value.mobile!;
                                  String displayMessage = 'Save 50% on food and soft drinks off-peak up to £10 per voucher. T&C\'s apply.';

                                  if (mobileTEC.text.startsWith("0")) mobileTEC.text = mobileTEC.text.substring(1, mobileTEC.text.length);
                                  if (!mobileTEC.text.startsWith("+44")) mobileTEC.text = "+44" + mobileTEC.text;

                                  Get.off(Checkout(
                                    displayMessage: displayMessage,
                                    mobile: mobileNumber,
                                    voucherImageUrl: imageURL,
                                    total: price[i],
                                    quantity: qty[i],
                                    freeQuantity: freeQty[i],
                                    discountCode: discountCodeTEC.text,
                                  ));
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: 3,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  voucherItem() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: greenColor,
        image: DecorationImage(image: imageUrl == null ? CachedNetworkImageProvider('') as ImageProvider : FileImage(imageUrl!), fit: BoxFit.cover),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.black38,
        ),
        padding: const EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.black38),
                  child: CachedImage(height: 100, url: '', roundedCorners: true, circular: false),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(displayMessageTEC.text.isEmpty ? 'Type a message to display here' : displayMessageTEC.text, textScaleFactor: 1.9, maxLines: 5, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            Text('Save 50% on food and soft drinks off-peak up to £10 per voucher. T&C\'s apply.', textScaleFactor: 1.2, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Expiry : ' + DateFormat('dd MMM yyyy').format(Timestamp.now().toDate().add(Duration(days: 365))), textScaleFactor: 1, style: TextStyle(color: lightGreenColor)),
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      decoration: BoxDecoration(
                        color: redColor,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Text('CLOSE', textScaleFactor: 1, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ),
              ],
            ),
            //Text(showDate(), textScaleFactor: 0.8, style: TextStyle(color: greenColor)),
          ],
        ),
      ),
    );
  }

  buyVoucher(int i) async {
    try {
      String voucherImageUrl = '';
      String mobileNumber = userController.currentUser.value.mobile!;
      String displayMessage = 'Save 50% on food and soft drinks off-peak up to £10 per voucher. T&C\'s apply.';
      if (mobileTEC.text.startsWith("0")) mobileTEC.text = mobileTEC.text.substring(1, mobileTEC.text.length);
      if (!mobileTEC.text.startsWith("+44")) mobileTEC.text = "+44" + mobileTEC.text;

      await cloudFunction(
          functionName: 'inAppPurchase',
          parameters: {
            'orderTotal': price[i],
            'userID': userController.currentUser.value.userID,
            'voucherQty': qty[i],
            'voucherImageUrl': voucherImageUrl,
            'displayMessage': displayMessage,
            'mobileNumber': mobileNumber,
          },
          action: () => Get.back());
    } catch (e) {
      Get.back();

      Get.back();
      print('@@@@@@@@@@@@@@');
      print(e);
      showRedAlert('Something went wrong. Please try again.');
    }
  }

  showIntro() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(padding / 2), child: Image.asset('assets/images/appetiser_intro.png')),
              SizedBox(height: 15),
              CustomButton(
                function: () => Get.back(),
                text: 'Proceed',
              ),
            ],
          ),
        );
      },
    );
  }
}
