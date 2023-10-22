import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  final String? url;

  MyWebView({@required this.url});

  @override
  MyWebViewState createState() => MyWebViewState();
}

class MyWebViewState extends State<MyWebView> {



  @override
  void initState() {
    super.initState();
    // Enable virtual display.
  //  if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/images/applogo.png', height: AppBar().preferredSize.height - 15)),
      body:Container()
      // WebViewWidget(initialUrl: widget.url,),
    );
  }
}
