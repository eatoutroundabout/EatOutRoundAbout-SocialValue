import 'package:eatoutroundabout/screens/profile/view_profile.dart';
import 'package:eatoutroundabout/utils/constants.dart';
import 'package:eatoutroundabout/widgets/heading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanUser extends StatefulWidget {
  @override
  _ScanUserState createState() => _ScanUserState();
}

class _ScanUserState extends State<ScanUser> {
  bool switchState = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15), backgroundColor: primaryColor),
      body: Column(
        children: [
          Heading(title: 'SCAN TO CONNECT'),
          Expanded(
            child: _buildQrView(context),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
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
            child: Text('Scan the QR Code to connect', textAlign: TextAlign.center, textScaleFactor: 1.5, style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();
    var scannedDataStream;
    scannedDataStream = controller.scannedDataStream.listen((scanData) async {
      scannedDataStream.cancel();
      print('Barcode Type: ${describeEnum(scanData.format)}   Data: ${scanData.code}');
      String? userID = scanData.code;
      HapticFeedback.vibrate();
      Get.off(() => ViewProfile(userID: userID));
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
