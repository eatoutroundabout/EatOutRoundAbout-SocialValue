import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/offer_model.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/empty_box.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:eatoutroundabout/widgets/loading.dart';
import 'package:eatoutroundabout/widgets/offer_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Offers extends StatefulWidget {
  final int? userType;

  Offers({@required this.userType});

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  final userController = Get.find<UserController>();
  HttpsCallableResult? result;
  RxBool isLoading = true.obs;
  OfferModel? offer;
  RxString offerTypeQuery = 'High Street'.obs;
  Rx<String> offerType = 'High Street'.obs;
  List offerTypes = ['High Street', 'Retail Offers'];
  List offerTypeQueries = ['highStreet', 'retail'];

  @override
  void initState() {
    switch (widget.userType) {
      case 0: // All Users
        offerTypes = ['High Street', 'Retail Offers', 'Culture'];
        offerTypeQueries = ['highStreet', 'retail', 'culture'];
        break;
      case 1: // Staff
        offerTypes = ['High Street', 'Retail Offers', 'Culture', 'Staff Benefits', 'Celebrate'];
        offerTypeQueries = ['highStreet', 'retail', 'culture', 'staffBenefits', 'celebrate'];
        break;
      case 2: // Admin
        offerTypes = ['Corporate Hospitality', 'Work Place Well-Being'];
        offerTypeQueries = ['corporateHospitality', 'wellBeing'];
        if (userController.isVenueAdmin()) {
          offerTypes += ['Hospitality Business Offers'];
          offerTypeQueries += ['hospitalityBusinessOffer'];
        }
        break;
    }
    offerType.value = offerTypes[0];
    offerTypeQuery.value = offerTypeQueries[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15)),
      body: Column(
        children: [
          Heading(title: 'OFFERS'),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  CustomTextField(dropdown: dropDown(offerTypes, 1), label: 'Select Offer Type'),
                  Expanded(
                    child: Obx(() {
                      return FutureBuilder<HttpsCallableResult<dynamic>?>(
                        future: cloudFunctionValueReturn(functionName: 'getOffers', parameters: {'postcode': userController.currentUser.value.livePostcodeDocId, 'offerType': offerTypeQuery.value}, showLoading: false),
                        builder: (context, AsyncSnapshot<HttpsCallableResult?> snapshot) {
                          print(offerTypeQuery.value);
                          if (snapshot.hasData) {
                            HttpsCallableResult? response = snapshot.data;
                            print(response!.data);
                            if (response.data['success']) {
                              offer = OfferModel.fromJson(json.decode(json.encode(response.data)) as Map<String, dynamic>);
                              return offer != null || offer!.data != null || offer!.data!.isNotEmpty
                                  ? ListView.builder(
                                      itemBuilder: (context, i) {
                                        return OfferItem(offer: offer!.data![i]);
                                      },
                                      itemCount: offer!.data!.length,
                                    )
                                  : EmptyBox(text: 'No offers to show');
                            } else
                              return EmptyBox(text: 'No offers to show');
                          } else
                            return LoadingData();
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  dropDown(List items, int i) {
    return DropdownButtonFormField<String>(
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
      value: offerType.value,
      items: items.map((value) {
        return DropdownMenuItem<String>(value: value, child: Text(value, textScaleFactor: 1, style: TextStyle(color: Colors.black)));
      }).toList(),
      onChanged: (value) {
        offerType.value = value!;
        int index = offerTypes.indexOf(offerType.value);
        offerTypeQuery.value = offerTypeQueries[index];
      },
    );
  }
}
