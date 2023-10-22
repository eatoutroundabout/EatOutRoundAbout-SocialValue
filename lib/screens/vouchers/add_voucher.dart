import 'dart:io';

import 'package:eatoutroundabout/controllers/user_controller.dart';
import 'package:eatoutroundabout/services/cloud_function.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class AddVoucher extends StatefulWidget {
  @override
  _AddVoucherState createState() => _AddVoucherState();
}

class _AddVoucherState extends State<AddVoucher> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  final userController = Get.find<UserController>();

  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) controller!.pauseCamera();
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'ADD A VOUCHER'),
          Expanded(
            child: _buildQrView(context),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(borderColor: Colors.red, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Text('Scan the QR Code to claim the voucher', textAlign: TextAlign.center, textScaleFactor: 1.5, style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    var scannedDataStream;
    scannedDataStream = controller.scannedDataStream.listen((scanData) async {
      scannedDataStream.cancel();
      String? voucherID = scanData.code;
      HapticFeedback.vibrate();
      Get.back();
      Map voucher = {
        'voucherID': voucherID,
        'userID': userController.currentUser.value.userID,
        'latitude': userController.myLatitude,
        'longitude': userController.myLongitude,
      };
      await cloudFunction(
          functionName: 'addVoucher',
          parameters: voucher,
          action: () {
            showGreenAlert('Great News! We will let the issuing party know you claimed your voucher.');
          });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
