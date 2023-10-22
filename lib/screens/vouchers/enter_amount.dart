import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/post_code_model.dart';
import 'package:eatoutroundabout/models/user_vouchers_model.dart';
import 'package:eatoutroundabout/models/venue_model.dart';
import 'package:eatoutroundabout/models/voucher_model.dart';
import 'package:eatoutroundabout/screens/vouchers/redeem_voucher.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/services/permissions_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:uuid/uuid.dart';

class EnterAmount extends StatefulWidget {
  final Venue? venue;

  EnterAmount({this.venue});

  @override
  _EnterAmountState createState() => _EnterAmountState();
}

class _EnterAmountState extends State<EnterAmount> {
  TextEditingController amountTEC = TextEditingController();
  TextEditingController voucherTEC = TextEditingController();
  List discounts = [];
  List discountedVoucherCodes = [];
  num amountToPay = 0;

  final firestoreService = Get.find<FirestoreService>();
  final voucherService = Get.find<FirestoreService>();
  final userController = Get.find<UserController>();
  final permissionsService = Get.find<PermissionsService>();
  final utilService = Get.find<UtilService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Column(
          children: [
            Heading(title: 'REDEEM VOUCHER'),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(padding),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              'Enter the full amount of the bill below before discount',
                              textScaleFactor: 1.25,
                              textAlign: TextAlign.center,
                            ),
                            CustomTextField(
                              validate: false,
                              controller: amountTEC,
                              maxLines: 1,
                              label: 'Enter transaction value including VAT',
                              hint: 'Enter Amount',
                              textInputType: TextInputType.numberWithOptions(decimal: true, signed: false),
                            ),
                            SizedBox(height: 25),
                            CustomButton(
                              text: 'Add a voucher',
                              color: primaryColor,
                              function: () async {
                                if (amountTEC.text.isNotEmpty) {
                                  int maxPeople = (num.parse(amountTEC.text) / 20).floor();
                                  if (discounts.length < maxPeople)
                                    enterVoucher();
                                  else
                                    showRedAlert('Only $maxPeople vouchers can be redeemed on this bill');
                                } else
                                  showRedAlert('Please add the total amount');
                              },
                            ),
                            Visibility(
                              visible: discountedVoucherCodes.isNotEmpty,
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 25),
                                padding: const EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(padding / 2),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Total Amount'),
                                        Text('£' + amountTEC.text),
                                      ],
                                    ),
                                    Divider(color: Colors.transparent),
                                    for (int i = 0; i < discounts.length; i++)
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Discount (${discountedVoucherCodes[i]})', style: TextStyle(color: greenColor)),
                                          Text('- £' + discounts[i].toString(), style: TextStyle(color: greenColor)),
                                        ],
                                      ),
                                    Divider(height: 30),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Payable Amount', style: TextStyle(fontWeight: FontWeight.bold)),
                                        Text('£' + amountToPay.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: discountedVoucherCodes.isNotEmpty,
                      child: CustomButton(
                        color: primaryColor,
                        text: 'Confirm Transaction',
                        function: () {
                          if (amountTEC.text.isEmpty && discountedVoucherCodes.isEmpty)
                            showRedAlert('Enter amount and valid voucher code to proceed');
                          else
                            confirmTransaction();
                          // redeemTheVoucher(voucherCodeTEC.text.toUpperCase());
                          //Get.off( RedeemVoucher(venueID: widget.venueID, amount: double.parse(amountTEC.text.trim())));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  enterVoucher() async {
    FocusScope.of(context).unfocus();

    showDialog(
      context: context,
      builder: (BuildContext context1) {
        return Dialog(
          insetPadding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding / 2)),
          child: Padding(
            padding: const EdgeInsets.all(padding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Voucher Code', textScaleFactor: 1.25),
                Divider(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        validate: false,
                        controller: voucherTEC,
                        maxLines: 1,
                        labelColor: Colors.grey,
                        label: '',
                        hint: 'Enter Code',
                        textInputType: TextInputType.text,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text('OR', textScaleFactor: 1, style: TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          CustomButton(
                            text: 'Scan Code',
                            function: () async {
                              Get.back();

                              FocusScope.of(context).unfocus();
                              bool checkIfGranted = await permissionsService.requestCameraPermission();
                              if (checkIfGranted) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => RedeemVoucher())).then((value) => setState(() {
                                      voucherTEC.text = value.toString();
                                      enterVoucher();
                                    }));
                              } else {
                                permissionsService.showPermissionSettingsDialog('This app needs Camera access to scan QR Codes');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  '*Only one voucher can be redeemed per person',
                  textScaleFactor: 0.95,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: orangeColor),
                ),
                SizedBox(height: 25),
                CustomButton(
                  color: primaryColor,
                  text: 'Apply Voucher',
                  function: () async {
                    Get.back();

                    bool checkIfValid = await redeemTheVoucher(voucherTEC.text.toUpperCase());
                    if (checkIfValid) {
                      discounts.add(10);
                      discountedVoucherCodes.add(voucherTEC.text.toUpperCase());
                    }
                    await calculatePayableAmount();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  calculatePayableAmount() async {
    amountToPay = num.parse(amountTEC.text);
    num totalAmount = amountToPay;
    num sumOfDiscounts = discounts.fold(0, (p,c) => p + c);
    amountToPay = totalAmount - sumOfDiscounts;
    voucherTEC.clear();
    //if (sumOfDiscounts > 0) await showRateVenueDialog();
    setState(() {});
  }

  showRateVenueDialog() async {
    bool enableRating = false;
    QuerySnapshot querySnapshot = await firestoreService.getMyReviewForVenue(widget.venue!.venueID!);
    if (querySnapshot.docs.isEmpty) enableRating = true;

    if (enableRating)
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return RatingDialog(
              starColor: orangeColor,
              image: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedImage(roundedCorners: true, circular: false, height: 75, url: widget.venue!.logo),
                ],
              ),
              title: Text("Rate ${widget.venue!.venueName}"),
              initialRating: 0,
              force: true,
              message: Text("Tap a star to set your rating and press submit"),
              commentHint: 'Tell us what you think...',
              submitButtonText: "SUBMIT",
              // alternativeButton: "Contact us instead?",
              // // optional
              // positiveComment: "Great news!",
              // // optional
              // negativeComment: "Oh dear!",
              // // optional
              // accentColor: Colors.red,
              // optional
              onSubmitted: (response) async {
                if (response.comment.isNotEmpty && response.rating > 0) {
                  Get.back();

                  await cloudFunction(
                      functionName: 'addReview',
                      parameters: {
                        'userID': userController.currentUser.value.userID,
                        'flagged': false,
                        'comment': response.comment,
                        'rating': response.rating.toDouble(),
                        'reviewID': Uuid().v1(),
                        'venueID': widget.venue!.venueID,
                      },
                      action: () {
                        setState(() {
                          enableRating = false;
                        });
                      });
                } else
                  showRedAlert('Please tap a star and enter a comment');
              },
              //onAlternativePressed: () => openLink('tel:${venue.venuePhoneNumber}'),
            );
          });
  }

  Future<bool> redeemTheVoucher(String voucherCode) async {
    utilService.showLoading();

    //Get User Voucher
    QuerySnapshot userVoucherDocumentSnapshot = await firestoreService.getVoucherByUniqueID(voucherCode);
    if (userVoucherDocumentSnapshot.docs.isNotEmpty) {
      UserVoucher userVoucher = userVoucherDocumentSnapshot.docs[0].data() as UserVoucher;

      //Get Voucher
      DocumentSnapshot voucherDocumentSnapshot = await firestoreService.getVoucherByVoucherID(userVoucher.voucherID!);
      Voucher voucher = voucherDocumentSnapshot.data() as Voucher;

      //Get Voucher Campaign
      //DocumentSnapshot voucherCampaignDocumentSnapshot = await voucherService.getVoucherCampaignByCampaignID(voucher.campaignID);
      //VoucherCampaign voucherCampaign = VoucherCampaign.fromDocument(voucherCampaignDocumentSnapshot);

      //Get PostCode Data
      DocumentSnapshot postCodeDocumentSnapshot = await voucherService.getPostCodeData(widget.venue!.postCode!);
      PostCode postCode = postCodeDocumentSnapshot.data() as PostCode;

      Get.back();

      if (userVoucher.redeemed!) {
        showRedAlert('This voucher is already redeemed');
        return false;
      }

      if (!userVoucher.redeemable!) {
        showRedAlert('This voucher is not redeemable');
        return false;
      }

      Duration duration = (DateTime.now().difference(userVoucher.expiryDate!.toDate()));
      if (!duration.isNegative) {
        showRedAlert('This voucher is expired');
        return false;
      }

      if (voucher.bidRestricted != '' && postCode.bid != voucher.bidRestricted) {
        showRedAlert('This voucher is BID Restricted');
        return false;
      }

      if (voucher.lepRestricted != '' && postCode.lep1 != voucher.lepRestricted) {
        showRedAlert('This voucher is LEP Restricted');
        return false;
      }

      if (voucher.localAuthRestricted != '' && postCode.laua != voucher.localAuthRestricted) {
        showRedAlert('This voucher is Local Authority Restricted');
        return false;
      }

      if (voucher.wardRestricted != '' && postCode.ward != voucher.wardRestricted) {
        showRedAlert('This voucher is Ward Restricted');
        return false;
      }

      if (voucher.venueRestricted != '' && widget.venue!.venueID != voucher.venueRestricted) {
        showRedAlert('This voucher is can only be redeemed at ${widget.venue!.venueName}');
        return false;
      }

      return true;
    } else {
      Get.back();

      showRedAlert('Enter a valid voucher code to proceed');
      return false;
    }
  }

  checkIfVoucherExpired(UserVoucher voucher) {
    Timestamp claimedDate = voucher.claimedDate!;
    claimedDate.toDate().add(Duration(days: voucher.daysValid as int));
  }

  confirmTransaction() async {
    // await redeemVoucher(userVoucherDocumentSnapshot.docs[0].id, userVoucher, widget.venue.venueID, double.parse(amountTEC.text));
    try {
      HttpsCallableResult? resp;
      utilService.showLoading();
      for (int i = 0; i < discountedVoucherCodes.length; i++) {
        final HttpsCallable callable = FirebaseFunctions.instanceFor(region: 'europe-west2').httpsCallable('voucherRedemption');
        resp = await callable.call(<String, dynamic>{
          'amount': amountToPay / discountedVoucherCodes.length,
          'redeemedVenueUserID': userController.currentUser.value.userID,
          'voucherRedemptionCode': discountedVoucherCodes[i].toString().toUpperCase().trim(),
          'venueID': widget.venue!.venueID,
        });
      }
      Get.back();

      if (resp!.data['success']) {
        setState(() {
          discounts = [];
          discountedVoucherCodes = [];
          amountTEC.clear();
        });
        showGreenAlert('Voucher redeemed successfully');
      } else {
        showRedAlert(resp!.data['message']);
      }
    } catch (e) {
      print('@@@@@@ ERROR @@@@@@@@');
      print(e);
      showRedAlert(e.toString());
      showRedAlert('Something went wrong. Please try again.');
      Get.back();
    }
  }
}
