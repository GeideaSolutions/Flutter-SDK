import 'dart:convert';

import 'package:flutter/material.dart';

import '../count_down_timer/circular_countdown_timer.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({
    Key? key,
    required this.currency,
    required this.amount,
    required this.base64ImageString,
    this.title,
    this.loadingTitle,
    this.infoTitle1,
    this.infoTitle2,
    this.infoTitle3,
    this.infoTitle4,
    this.progressColor,
    this.progressBackgroundColor,
    this.progressTextColor,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  final String? title;
  final String? currency;
  final String? amount;
  final String? loadingTitle;
  final String? infoTitle1;
  final String? infoTitle2;
  final String? infoTitle3;
  final String? infoTitle4;
  final String base64ImageString;
  final Color? progressColor;
  final Color? progressTextColor;
  final Color? progressBackgroundColor;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  State<QRCodeScreen> createState() => QRCodeScreenState();
}

class QRCodeScreenState extends State<QRCodeScreen> {
  final CountDownController _controller = CountDownController();
  final int _duration = 15;

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _controller.restart(duration: _duration));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: widget.backgroundColor,
          body: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    child: Text(
                      widget.title ?? "Mobile Wallet Payment",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: widget.textColor,
                      ),
                    ),
                    onTap: () {
                      _controller.restart(duration: _duration);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text.rich(
                    TextSpan(
                        text: widget.currency ?? "",
                        children: <InlineSpan>[
                          const TextSpan(
                            text: " ",
                          ),
                          TextSpan(
                            text: widget.amount ?? "",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: widget.textColor,
                            ),
                          ),
                        ]),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CircularCountDownTimer(
                    duration: _duration,
                    initialDuration: _duration,
                    controller: _controller,
                    width: 50,
                    height: 50,
                    ringColor: widget.progressTextColor ?? Colors.grey[300]!,
                    ringGradient: null,
                    fillColor:
                        widget.progressColor ?? Colors.purpleAccent[100]!,
                    fillGradient: null,
                    backgroundColor:
                        widget.progressBackgroundColor ?? Colors.purple[500],
                    backgroundGradient: null,
                    strokeWidth: 5.0,
                    strokeCap: StrokeCap.round,
                    textStyle: TextStyle(
                        fontSize: 16.0,
                        color: widget.progressTextColor ?? Colors.grey[300]!,
                        fontWeight: FontWeight.bold),
                    textFormat: CountdownTextFormat.S,
                    isReverse: false,
                    isReverseAnimation: false,
                    isTimerTextShown: true,
                    autoStart: false,
                    onStart: () {
                      // debugPrint('Countdown Started');
                    },
                    onComplete: () {
                      // debugPrint('Countdown Ended');
                      Navigator.pop(context);
                    },
                    onChange: (String timeStamp) {
                      // debugPrint('Countdown Changed $timeStamp');
                    },
                    timeFormatterFunction:
                        (defaultFormatterFunction, duration) {
                      if (duration.inSeconds == 0) {
                        return "Start";
                      } else {
                        return Function.apply(
                            defaultFormatterFunction, [duration]);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.loadingTitle ?? "We are waiting for you",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.infoTitle1 ??
                        "Open the notification from your wallet application and follow the instructions in order finalize the payment.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: widget.textColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.infoTitle2 ?? "Do not close this page",
                    style: TextStyle(color: widget.textColor),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Image.memory(
                    base64Decode(widget.base64ImageString),
                    height: 200,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.infoTitle3 ?? "Don't receive a notification?",
                    style: TextStyle(color: widget.textColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.infoTitle4 ??
                        "Scan the QR coe using your wallet application to intiate the payment",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: widget.textColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () => Future.value(false));
  }
}
