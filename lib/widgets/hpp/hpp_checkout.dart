import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/services.dart';

class HPPCheckout extends StatefulWidget {
  const HPPCheckout({Key? key,
    required this.hppURL,
    required this.sessionId,
    required this.returnURL})
      : super(key: key);

  final String hppURL;
  final String sessionId;
  final String? returnURL;

  @override
  State<HPPCheckout> createState() => HPPCheckoutState();
}

class HPPCheckoutState extends State<HPPCheckout> {

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          javaScriptEnabled: true,
          javaScriptCanOpenWindowsAutomatically: true));

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Theme
          .of(context)
          .appBarTheme
          .backgroundColor,
    ));

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(0.0, 0.0),
        child: Container(),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
                url: Uri.parse("${widget.hppURL}${widget.sessionId}")),
            initialOptions: options,
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            shouldOverrideUrlLoading: (controller, navigationAction) {
              return Future.value(NavigationActionPolicy.ALLOW);
            },
            onLoadError: (controller, url, code, message) {},
            onLoadHttpError: (controller, url, statusCode, description) {},
            onUpdateVisitedHistory: (controller, url, androidIsReload) async {
              if (url.toString().startsWith(widget.returnURL ?? "")) {
                Navigator.pop(context, url?.queryParameters);
              }
            },
            onConsoleMessage: (controller, consoleMessage) {},
            // onProgressChanged: (){
            //   if (progress >= 100) {
            //     setState(() {
            //       _isLoading = true;
            //     });
            //   }else{
            //     _isLoading = false;
            //   }
            // },
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                _isLoading = false;
              });
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
    );
  }
}
