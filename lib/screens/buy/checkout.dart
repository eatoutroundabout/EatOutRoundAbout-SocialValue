import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/models/discount_codes_model.dart';
import 'package:eatoutroundabout/services/buy_service.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Checkout extends StatefulWidget {
  final String? displayMessage;
  final String? mobile;
  final String? voucherImageUrl;
  final num? total;
  final num? quantity;
  final num? freeQuantity;
  final String? discountCode;

  Checkout({this.mobile, this.displayMessage, this.voucherImageUrl, this.total, this.quantity, this.freeQuantity, this.discountCode});

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  num amountToPay = 0;
  num discount = 0;
  TextEditingController discountCodeTEC = TextEditingController();
  Rx<bool> checkedMarketing = false.obs;
  Rx<bool> checkedPrivacy = true.obs;
  Rx<bool> checkedTnC = true.obs;

  final voucherService = Get.find<FirestoreService>();
  final buyService = Get.find<BuyService>();
  final utilService = Get.find<UtilService>();

  @override
  void initState() {
    amountToPay = widget.total! - discount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'CHECKOUT'),
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(padding / 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Details', style: TextStyle(fontWeight: FontWeight.bold)),
                Divider(color: Colors.transparent),
                Text('Mobile number of recipient'),
                Text(widget.mobile!, style: TextStyle(color: greenColor)),
                Divider(color: Colors.transparent),
                Text('Message on the voucher'),
                Text(widget.displayMessage!, style: TextStyle(color: greenColor)),
                Divider(color: Colors.transparent),
                Text('Number of vouchers'),
                Text(widget.quantity.toString() + ' vouchers + ' + widget.freeQuantity.toString() + ' free vouchers', style: TextStyle(color: greenColor)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(padding / 2),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Amount'),
                            Text('£' + widget.total.toString()),
                          ],
                        ),
                        Divider(color: Colors.transparent),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount', style: TextStyle(color: greenColor)),
                            Text('£' + discount.toString(), style: TextStyle(color: greenColor)),
                          ],
                        ),
                        Divider(color: Colors.transparent),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Amount to Pay', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('£' + amountToPay.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 30),
                  Row(
                    children: [
                      Obx(() {
                        return Checkbox(
                            value: checkedTnC.value,
                            focusColor: Colors.teal,
                            activeColor: Colors.green,
                            onChanged: (bool? newValue) {
                              checkedTnC.value = !checkedTnC.value;
                            });
                      }),
                      Expanded(
                        flex: 8,
                        child: InkWell(
                          onTap: () => utilService.openLink('https://eatoutroundabout.co.uk/legals/app-products-purchase-terms-and-conditions/'),
                          child: Text(
                            'I accept the app purchase terms and conditions',
                            textScaleFactor: 0.9,
                            style: TextStyle(color: Colors.teal),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() {
                        return Checkbox(
                            value: checkedPrivacy.value,
                            focusColor: Colors.teal,
                            activeColor: Colors.green,
                            onChanged: (bool? newValue) {
                              checkedPrivacy.value = !checkedPrivacy.value;
                            });
                      }),
                      Expanded(
                        flex: 8,
                        child: InkWell(
                          onTap: () => utilService.openLink('https://eatoutroundabout.co.uk/legals/privacy-policy/'),
                          child: Text(
                            'I agree to the Privacy Policy',
                            textScaleFactor: 0.9,
                            style: TextStyle(color: Colors.teal),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() {
                        return Checkbox(
                            value: checkedMarketing.value,
                            focusColor: Colors.teal,
                            activeColor: Colors.green,
                            onChanged: (bool? newValue) {
                              checkedMarketing.value = !checkedMarketing.value;
                            });
                      }),
                      Expanded(
                        flex: 8,
                        child: Text(
                          'I would like to receive marketing updates with offers and new products',
                          textScaleFactor: 0.9,
                          style: TextStyle(color: Colors.teal),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1),
          TextButton(onPressed: () => applyCode(), child: Text('Apply Discount Code')),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
            child: CustomButton(
              function: () async {
                if (checkedPrivacy.value && checkedTnC.value) {
                  await buyService.buyMethod(
                    context: context,
                    total: amountToPay,
                    quantity: (widget.quantity! + widget.freeQuantity!),
                    image: widget.voucherImageUrl,
                    message: widget.displayMessage,
                    mobile: widget.mobile,
                    discountCode: widget.discountCode,
                    setState: () => setState(() {}),
                  );
                  Get.back();
                } else
                  showRedAlert('Please agree to the Privacy Policy and Terms and Conditions to proceed');
              },
              text: 'Proceed to Payment',
            ),
          ),
        ],
      ),
    );
  }

  applyCode() {
    Get.defaultDialog(
        radius: padding / 2,
        title: 'Apply Discount Code',
        content: CustomTextField(
          label: 'Apply discount code',
          hint: 'Enter discount code',
          labelColor: greenColor,
          controller: discountCodeTEC,
          maxLines: 1,
          validate: false,
          textInputType: TextInputType.text,
        ),
        actions: [
          ElevatedButton(
              onPressed: () async {
                if (discountCodeTEC.text.isNotEmpty) {
                  Get.back();

                  utilService.showLoading();
                  QuerySnapshot<DiscountCode> querySnapshot = await voucherService.getDiscountFromDiscountCode(discountCodeTEC.text.replaceAll(" ", "").toUpperCase());
                  Get.back();

                  if (querySnapshot.docs.isNotEmpty) {
                    DiscountCode discountCode = querySnapshot.docs[0].data();
                    discount = discountCode.discount! / 100 * widget.total!;

                    setState(() {
                      amountToPay = widget.total! - discount;
                    });
                  } else
                    showRedAlert('Invalid discount code');
                }
              },
              child: Text('Apply')),
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
        ]);
  }
}
