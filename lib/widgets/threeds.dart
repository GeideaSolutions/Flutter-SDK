import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io' show Platform;

class ThreeDSPage extends StatefulWidget {
  final String? html;
  final String? returnURL;

  const ThreeDSPage(this.html, this.returnURL, {Key? key}) : super(key: key);

  @override
  _ThreeDSPageState createState() => _ThreeDSPageState();
}

class _ThreeDSPageState extends State<ThreeDSPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel('Toaster', onMessageReceived: (message) {
        // ignore: deprecated_member_use
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url, ${widget.returnURL}');
            if (url.startsWith(widget.returnURL ?? "")) {
              Navigator.of(context).pop();
            }
          },
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) async {
            debugPrint('WebResourceError: $error');
            await Future.delayed(const Duration(seconds: 2));
            if (mounted && Platform.isIOS) {
              Navigator.of(context).pop();
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('allowing navigation to $request');
            if (request.url.startsWith(widget.returnURL ?? "")) {
              Navigator.of(context).pop();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString(widget.html.toString());
  }

  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("3DS")),
      body: Builder(builder: (BuildContext context) {
        return WebViewWidget(
          controller: _controller,
        );
      }),
    );
  }
}
