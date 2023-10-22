import 'package:dotted_border/dotted_border.dart';
import 'package:eatoutroundabout/models/user_vouchers_model.dart';
import 'package:eatoutroundabout/screens/vouchers/restricted_venues.dart';
import 'package:eatoutroundabout/services/util_service.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/custom_button.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ViewVoucher extends StatelessWidget {
  final UserVoucher? userVoucher;
  final String? name;
  final String? value;

  ViewVoucher({this.userVoucher, this.name, this.value});

  final utilService = Get.find<UtilService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'VOUCHER'),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: Colors.grey.shade300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder(
                    stream: Stream.periodic(const Duration(seconds: 1)),
                    builder: (context, snapshot) {
                      return Text(
                        DateFormat('dd MMM yyyy, hh:mm:ss').format(DateTime.now()),
                        textScaleFactor: 1.5,
                        style: TextStyle(fontWeight: FontWeight.bold, color: greenColor),
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  PrettyQr(
                    typeNumber: 2,
                    size: 250,
                    data: userVoucher!.voucherRedemptionCode!,
                    roundEdges: true,
                  ),
                  SizedBox(height: 30),
                  Text('Voucher Code', textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                  SizedBox(height: 10),
                  DottedBorder(
                    color: Colors.black,
                    dashPattern: [8, 4],
                    strokeWidth: 3,
                    strokeCap: StrokeCap.butt,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(userVoucher!.voucherRedemptionCode!, textScaleFactor: 2.5, style: TextStyle(fontWeight: FontWeight.bold, color: redColor)),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(showDate(), textScaleFactor: 1, style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                  SizedBox(height: 30),
                  //Text('Cannot be redeemed in conjunction with venue offers', textAlign: TextAlign.center, textScaleFactor: 0.9, style: TextStyle(color: greenColor)),
                  InkWell(onTap: () => {
                    utilService.showInfoDialog("Terms and Conditions",
                      "\u2022 Please notify the server of voucher use prior to requesting the bill.\n"
                      "\u2022 This is a non-cash voucher.\n"
                      "\u2022 This voucher is not exchangeable for cash.\n"
                      "\u2022 The voucher is only valid on or before the expiry date.\n"
                      "\u2022 1 voucher may be redeemed per person, per meal.\n"
                      "\u2022 There is a minimum spend of £20 inclusive of VAT per voucher\n"
                      "\u2022 Multiple vouchers may be used by for party, as long as only 1 voucher is used per person and the average spend for each person is £20 inclusive of VAT.\n"
                      "\u2022 Once a voucher has been redeemed, it can not then be re-used\n"
                      "\u2022 If the viewing of the voucher is obstructed e.g. due to device damage or phone charge declined.\n",
                      false)
                    },
                    child: Text('Terms and Conditions Apply', textAlign: TextAlign.center, textScaleFactor: 0.9, style: TextStyle(color: greenColor, decoration: TextDecoration.underline))),
                  if (name != null)
                    Container(
                      height: 100,
                      padding: const EdgeInsets.all(20),
                      child: CustomButton(
                        color: primaryColor,
                        textColor: lightGreenColor,
                        text: 'This voucher is restricted.\nSee where you can redeem it',
                        showShadow: true,
                        function: () => Get.to(() => RestrictedVenues(name: name!, value: value!)),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  showDate() {
    if (userVoucher!.redeemed!)
      return 'Redeemed : ' + DateFormat('dd MMM yyyy').format(userVoucher!.redeemedDate!.toDate());
    else
      return 'Expiry Date : ' + DateFormat('dd MMM yyyy').format(userVoucher!.expiryDate!.toDate());
  }
}
