import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart' as webviewf;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';

class ThreeDSPage extends StatefulWidget {
  final String? html;
  final String? returnURL;

  const ThreeDSPage(this.html, this.returnURL, {Key? key}) : super(key: key);

  @override
  _ThreeDSPageState createState() => _ThreeDSPageState();
}

class _ThreeDSPageState extends State<ThreeDSPage> {
  late final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }
  }

  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("3DS")),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: '',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
            webViewController
                .currentUrl()
                .then((value) => print("current url is " + value.toString()));
            _onLoadHtmlStringExample(webViewController, context, widget.html);
          },
          onProgress: (int progress) {
            print('WebView is loading (progress : $progress%)');
          },
          onWebResourceError: (WebResourceError error) {
            print('WebResourceError: $error');

            if (Platform.isIOS) {
              Navigator.of(context).pop();
            }
          },
          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },
          onPageStarted: (String url) {
            print('Page started loading: $url, ${widget.returnURL}');
            if (url.startsWith(widget.returnURL ?? "")) {
              Navigator.of(context).pop();
            }
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
            // if (url.startsWith(widget.returnURL)) {
            //   Navigator.of(context).pop();
            // }
          },
          navigationDelegate: (webviewf.NavigationRequest request) {
            print('allowing navigation to $request');
            if (request.url.startsWith(widget.returnURL ?? "")) {
              Navigator.of(context).pop();
              return webviewf.NavigationDecision.prevent;
            }
            return webviewf.NavigationDecision.navigate;
          },
          gestureNavigationEnabled: true,
          backgroundColor: const Color(0x00000000),
        );
      }),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Future<void> _onLoadHtmlStringExample(
      WebViewController controller, BuildContext context, String? html) async {
    await controller.loadHtmlString(html!);
  }
}
