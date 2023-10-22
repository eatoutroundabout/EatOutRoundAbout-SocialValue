import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/greetings_model.dart';
import 'package:eatoutroundabout/screens/buy/checkout.dart';
import 'package:eatoutroundabout/services/buy_service.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/utils/preferences.dart';
import 'package:eatoutroundabout/widgets/cached_image.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class BuyGreetings extends StatefulWidget {
  final String? venueID;
  final String? venueLogo;

  BuyGreetings({this.venueID, this.venueLogo});

  @override
  _BuyGreetingsState createState() => _BuyGreetingsState();
}

class _BuyGreetingsState extends State<BuyGreetings> {
  num uploadProgress = 0;
  TextEditingController mobileTEC = TextEditingController();
  TextEditingController toTEC = TextEditingController();
  TextEditingController fromTEC = TextEditingController();
  TextEditingController displayMessageTEC = TextEditingController();
  List packageTitle = ['Buy 1 Voucher', 'Buy 3 Vouchers ', 'Buy 8 Vouchers'];
  List freeItems = ['', 'Get 1 free', 'Get 3 free'];
  List qty = [1, 3, 8];
  List freeQty = [0, 1, 3];
  List price = [10, 30, 80];
  File? imageUrl;
  num discount = 0;
  int currentStep = 1;
  String selectedCard = '';

  final buyService = Get.find<BuyService>();
  final userController = Get.find<UserController>();

  @override
  void initState() {
    toTEC.text = 'To ';
    fromTEC.text = 'From ';
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await Preferences.showGreetingIntro()) await showIntro();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'SEND VOUCHERS'),
          Divider(height: 1),
          SizedBox(height: 25),
          Text('Step $currentStep of 3', textScaleFactor: 1.5, style: TextStyle(color: greenColor)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: StepProgressIndicator(
              roundedEdges: Radius.circular(5),
              totalSteps: 3,
              padding: 5,
              currentStep: currentStep,
              selectedColor: greenColor,
              unselectedColor: Colors.grey.shade400,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  if (currentStep == 1) step1(),
                  if (currentStep == 2) step2(),
                  if (currentStep == 3) step3(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  step2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Enter details', textScaleFactor: 1.5),
          CustomTextField(
            validate: true,
            isEmail: false,
            hint: 'Enter a 10 digit mobile number',
            label: 'Mobile Number of Voucher Receiver',
            textInputType: TextInputType.phone,
            controller: mobileTEC,
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Preview',
                  function: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context1) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 100),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: voucherItem(true),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: CustomButton(
                  text: 'Proceed',
                  function: () {
                    if (mobileTEC.text.isNotEmpty)
                      setState(() => currentStep++);
                    else
                      showRedAlert('Please enter the mobile number to proceed');
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  step1() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('What is the occasion?', textScaleFactor: 1.5),
        FutureBuilder(
          future: buyService.getGreetings(widget.venueID!),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return LoadingData();
            else {
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, i) {
                  return greetingItem(Greeting.fromDocument(snapshot.data!.docs[i].data() as Map<String,Object>));
                },
              );
            }
          },
        ),
      ],
    );
  }

  step3() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 45, top: 25, bottom: 10),
          child: Row(
            children: [
              Text(
                'Select Package',
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
                    Image.asset(
                      'assets/images/buy${i + 1}.jpeg',
                      height: MediaQuery.of(context).size.height * 0.175,
                    ),
                    SizedBox(height: 25),
                    Text('£' + price[i].toString(), textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold, color: orangeColor)),
                    SizedBox(height: 25),
                    CustomButton(
                      text: 'Buy Now',
                      function: () async {
                        String mobileNumber = userController.currentUser.value.mobile!;
                        if (mobileTEC.text.startsWith("0")) mobileTEC.text = mobileTEC.text.substring(1, mobileTEC.text.length);
                        if (!mobileTEC.text.startsWith("+44")) mobileTEC.text = "+44" + mobileTEC.text;

                        mobileNumber = mobileTEC.text;
                        setState(() {
                          currentStep = 1;
                        });
                        Get.to(() => Checkout(
                              displayMessage: toTEC.text + '\n' + displayMessageTEC.text + '\n' + fromTEC.text,
                              mobile: mobileNumber,
                              voucherImageUrl: selectedCard,
                              total: price[i],
                              quantity: qty[i],
                              freeQuantity: freeQty[i],
                            ));
                      },
                    ),
                  ],
                ),
              );
            },
            itemCount: 3,
          ),
        ),
      ],
    );
  }

  greetingItem(Greeting greeting) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(left: 45, top: 25, bottom: 10),
          child: Text(
            'Select a ' + greeting.type! + ' voucher',
            textScaleFactor: 1.25,
            style: TextStyle(color: Colors.teal),
          ),
        ),
        Container(
          height: 300,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 30),
            itemCount: greeting.cards!.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) {
              return InkWell(
                onTap: () {
                  selectedCard = greeting.cards![i];
                  showDialog(
                    context: context,
                    builder: (BuildContext context1) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: voucherItem(false),
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CachedImage(
                    height: 200,
                    url: greeting.cards![i],
                    roundedCorners: true,
                    circular: false,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  voucherItem(bool isPreview) {
    return Container(
      height: MediaQuery.of(context).size.height - 200,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        image: DecorationImage(
          image: CachedNetworkImageProvider(selectedCard),
          fit: BoxFit.cover,
          colorFilter: new ColorFilter.mode(Colors.black38, BlendMode.darken),
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.black38),
                      child: CachedImage(height: 100, url: widget.venueLogo, roundedCorners: true, circular: false),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MediaQuery(
                      data: MediaQueryData(textScaleFactor: 1.5),
                      child: Theme(
                        data: ThemeData(),
                        child: TextField(
                          maxLines: 2,
                          style: TextStyle(color: Colors.white),
                          controller: toTEC,
                          decoration: InputDecoration(border: InputBorder.none, hintText: 'To', hintStyle: TextStyle(color: Colors.white54)),
                        ),
                      ),
                    ),
                    MediaQuery(
                      data: MediaQueryData(textScaleFactor: 1.5),
                      child: Theme(
                        data: ThemeData(),
                        child: TextField(
                          maxLines: 4,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(color: Colors.white),
                          controller: displayMessageTEC,
                          decoration: InputDecoration(isCollapsed: true, isDense: true, border: InputBorder.none, hintText: 'Tap Here to add your custom Greeting', hintStyle: TextStyle(color: Colors.white54)),
                        ),
                      ),
                    ),
                    MediaQuery(
                      data: MediaQueryData(textScaleFactor: 1.5),
                      child: Theme(
                        data: ThemeData(),
                        child: TextField(
                          maxLines: 2,
                          style: TextStyle(color: Colors.white),
                          controller: fromTEC,
                          decoration: InputDecoration(border: InputBorder.none, hintText: 'From', hintStyle: TextStyle(color: Colors.white54)),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Save 50% on food and soft drinks off-peak up to £10 per voucher. T&C\'s apply.', textScaleFactor: 1.2, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Expiry : ' + DateFormat('dd MMM yyyy').format(Timestamp.now().toDate().add(Duration(days: 365))), textScaleFactor: 1, style: TextStyle(color: lightGreenColor)),
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                            ),
                            child: Text('VOUCHER', textScaleFactor: 1, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                      ],
                    ),
                    SizedBox(height: 15),
                    isPreview
                        ? CustomButton(
                            text: 'Close',
                            function: () => Get.back(),
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  text: 'Try another',
                                  function: () => Get.back(),
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: CustomButton(
                                  text: 'Proceed',
                                  function: () {
                                    Get.back();

                                    setState(() {
                                      currentStep++;
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
              ClipRRect(borderRadius: BorderRadius.circular(padding / 2), child: Image.asset('assets/images/greeting_intro.png')),
              SizedBox(height: 15),
              CustomButton(
                function: () async {
                  await Preferences.hideGreetingIntro();
                  Get.back();
                },
                text: 'Proceed',
              ),
            ],
          ),
        );
      },
    );
  }

  showCustomDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(padding / 2)),
          title: Text('Welcome to the future of Greeting Cards!'),
          content: Text(
            '🌿 100% good for the environment\n💰 200% good for the economy\n💡 100% imaginative\n💚 100% good for the soul\n🍔 1000% tasty!',
            style: TextStyle(color: orangeColor, fontWeight: FontWeight.bold),
          ),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  Get.back();
                },
                child: Text('Proceed')),
          ],
        );
      },
    );
  }

  buyVoucher(int i) async {
    try {
      String voucherImageUrl = '';
      String mobileNumber = userController.currentUser.value.mobile!;
      String displayMessage = 'Save 50% on food and soft drinks off-peak up to £10 per voucher. T&C\'s apply.';
      if (mobileTEC.text.startsWith("0")) mobileTEC.text = mobileTEC.text.substring(1, mobileTEC.text.length);
      if (!mobileTEC.text.startsWith("+44")) mobileTEC.text = "+44" + mobileTEC.text;

      mobileNumber = mobileTEC.text;
      displayMessage = displayMessageTEC.text;
      voucherImageUrl = selectedCard; //await uploadImage(PickedFile(imageUrl.path), 'inAppPurchase-' + Uuid().v1() + '.jpg');

      await cloudFunction(
          functionName: 'inAppPurchase',
          parameters: {
            'orderTotal': price[i],
            'userID': userController.currentUser.value.userID,
            'voucherQty': qty[i],
            'voucherImageUrl': voucherImageUrl,
            'displayMessage': displayMessage,
            'mobileNumber': mobileNumber,
            'venueID': '',
          },
          action: () => Get.back());
    } catch (e) {
      Get.back();
      print('@@@@@@@@@@@@@@');
      print(e);
      showRedAlert('Something went wrong. Please try again.');
    }
  }
}
