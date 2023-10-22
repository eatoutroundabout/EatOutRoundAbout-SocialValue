import 'package:eatoutroundabout/services/buy_service.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyFeature extends StatefulWidget {
  @override
  State<BuyFeature> createState() => _BuyFeatureState();
}

class _BuyFeatureState extends State<BuyFeature> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15)),
      body: Column(
        children: [
          Heading(title: 'UNLOCK A FEATURE', textScaleFactor: 1.75),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }

  buy(num amount) async {
    final buyService = Get.find<BuyService>();
    final utilService = Get.find<UtilService>();
    utilService.showLoading();
    bool success = await buyService.processPayment(amountToPay: amount);

    if (success) {
      utilService.showLoading();
    } else {
      showRedAlert('Payment not successful. Please try again');
    }
  }
}
