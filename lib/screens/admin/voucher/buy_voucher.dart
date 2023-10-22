import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/models/business_profile.dart';
import 'package:eatoutroundabout/services/firestore_service.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/custom_text_field.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class BuyVoucher extends StatefulWidget {

  @override
  State<BuyVoucher> createState() => _BuyVoucherState();
}

class _BuyVoucherState extends State<BuyVoucher> {
  final TextEditingController vouchersPerEmployeeTEC = TextEditingController();
  final TextEditingController employeeNumberTEC = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isImpactReporting = true;
  double impactReporting = 0;
  double voucherAmount = 0;
  double VAT = 0;
  double totalAmount = 0;
  int totalVoucher = 0;
  String businessProfileName = 'Business Profile Name';
  List<DropdownMenuItem<String>> dropdownMenuItems = [
    DropdownMenuItem<String>(
        child: Text('Business Profile Name',
          textScaleFactor: 1,
          style: TextStyle(color: Colors.black)
        ),
        value: 'Business Profile Name'
    )
  ];
  final userController = Get.find<UserController>();
  final firestoreService = Get.find<FirestoreService>();


  @override
  void initState() {
    fetchBusinessProfiles();
    vouchersPerEmployeeTEC.addListener(() {
      // setUpVariables();
      setState(() {
        totalVoucher = getTotalVouchersNumber();
        voucherAmount = getVoucherAmount();
        impactReporting = getImpactReporting();
        VAT = getVAT();
        totalAmount = getTotalAmount();
      });
    });
    employeeNumberTEC.addListener(() {
      // setUpVariables();
      setState(() {
        totalVoucher = getTotalVouchersNumber();
        voucherAmount = getVoucherAmount();
        impactReporting = getImpactReporting();
        VAT = getVAT();
        totalAmount = getTotalAmount();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png',
          height: AppBar().preferredSize.height - 15),),
      body: Column(
        children: [
          Heading(title: 'BUY VOUCHERS', textScaleFactor: 1.75),
          Expanded(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/buy_vouchers_header.png",
                    ),
                    SizedBox(height: 20),
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
                      style: TextStyle(color: primaryColor, fontSize: 18),
                      value: businessProfileName,
                      items: dropdownMenuItems,
                      onChanged: (value) => {

                      },
                    ),
                    CustomTextField(
                      textFieldWidth: 100,
                      validate: true,
                      label: 'How many vouchers per employee?',
                      hint: 'Enter vouchers per employee',
                      controller: vouchersPerEmployeeTEC,
                      textInputType: TextInputType.numberWithOptions(
                          decimal: false, signed: false)),
                    CustomTextField(
                        textFieldWidth: 100,
                        validate: true,
                        label: 'How many employees?',
                        hint: 'Enter employee number',
                        controller: employeeNumberTEC,
                        textInputType: TextInputType.numberWithOptions(
                            decimal: false, signed: false)),
                    SizedBox(height: 25,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Would you like impact reporting £2.50 + VAT per voucher?"),
                        Row(
                          children: [
                            Radio<bool>(
                              value: true,
                              groupValue: isImpactReporting,
                              onChanged: (value) {
                                setState(() {
                                  isImpactReporting = value!;
                                  impactReporting = getImpactReporting();
                                  totalAmount = getTotalAmount();
                                });
                              },
                              toggleable: true,
                            ),
                            Text('Yes'),
                            SizedBox(width: 50),
                            Radio<bool>(
                              value: false,
                              groupValue: isImpactReporting,
                              onChanged: (value) {
                                setState(() {
                                  isImpactReporting = value!;
                                  impactReporting = getImpactReporting();
                                  totalAmount = getTotalAmount();
                                });
                              },
                              toggleable: true,
                            ),
                            Text('No'),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 25,),
                    // Obx(() =>),
                    Table(
                      children: [
                        TableRow(
                            children: [
                              Text("Total vouchers"),
                              Container(
                                // key: ValueKey(totalVoucher.toString()),
                                child: Text(totalVoucher.toString()),
                                alignment: Alignment.centerRight,
                              ),
                            ]
                        ),
                        TableRow(
                            children: [
                              Text("Voucher amount"),
                              Container(
                                // key: ValueKey(voucherAmount.toString()),
                                child: Text("£ " + voucherAmount.toString()),
                                alignment: Alignment.centerRight,
                              ),
                            ]
                        ),
                        TableRow(
                            children: [
                              Text("Impact Reporting"),
                              Container(
                                // key: ValueKey(impactReporting.toString()),
                                child: Text("£ " + impactReporting.toString()),
                                alignment: Alignment.centerRight,
                              ),
                            ]
                        ),
                        TableRow(
                            children: [
                              Text("VAT"),
                              Container(
                                // key: ValueKey(VAT.toString()),
                                child: Text("£ " + VAT.toString()),
                                alignment: Alignment.centerRight,
                              ),
                            ]
                        ),
                        TableRow(
                            children: [
                              Text(""),
                              Container(
                                child: Text(""),
                                alignment: Alignment.centerRight,
                              ),
                            ]
                        ),
                        TableRow(
                            children: [
                              Text("Total"),
                              Container(
                                // key: ValueKey(totalAmount.toString()),
                                child: Text("£ " + totalAmount.toString()),
                                alignment: Alignment.centerRight,
                              ),
                            ]
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CustomButton(
                            width: 180,
                            color: redColor,
                            function: () async {

                            },
                            text: "Buy now",
                            textColor: Colors.white,
                          ),
                        ),
                      ]
                    ),
                    SizedBox(height: 25,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void fetchBusinessProfiles() {
    userController.currentUser.value.businessProfileAdmin!.forEach((businessProfileAdminID) async {
      DocumentSnapshot<BusinessProfile> profileSnapshot = await firestoreService.getBusinessByBusinessID(businessProfileAdminID);
      if(profileSnapshot.exists) {
        BusinessProfile? businessProfile = profileSnapshot.data();
        dropdownMenuItems.add(
            DropdownMenuItem<String>(
                child: Text(
                    businessProfile!.businessName!,
                    textScaleFactor: 1,
                    style: TextStyle(color: Colors.black)
                ),
                value: businessProfile.businessName!
            )
        );
      }
    });
  }

  int getTotalVouchersNumber() {
    return int.parse(vouchersPerEmployeeTEC.text) * int.parse(employeeNumberTEC.text);
  }

  double getVoucherAmount() {
    double voucherAmount = (totalVoucher * 10.0); // $10 fixed for each voucher
    return double.parse(voucherAmount.toStringAsFixed(2));
  }

  double getImpactReporting() {
    if(!isImpactReporting) {
      return 0;
    }

    double impactReportingValue = 0;
    if(totalVoucher <= 400) {
      impactReportingValue = (totalVoucher * 2.50); // 2.5 per voucher
    }
    else { // more than 400 vouchers
      impactReportingValue = (totalVoucher * 2.00) ; // 2.0 per voucher
    }
    return double.parse(impactReportingValue.toStringAsFixed(2));
  }

  double getVAT() {
    double VAT = (totalVoucher * 0.2); // 20% VAT
    return double.parse(VAT.toStringAsFixed(2));;
  }

  double getTotalAmount() {
    double total = voucherAmount + impactReporting + VAT; // 20% VAT
    return double.parse(total.toStringAsFixed(2));;
  }

  void setUpVariables() {
    setState(() {
      totalVoucher = getTotalVouchersNumber();
      voucherAmount = getVoucherAmount();
      impactReporting = getImpactReporting();
      VAT = getVAT();
      totalAmount = getTotalAmount();
    });
  }
}
