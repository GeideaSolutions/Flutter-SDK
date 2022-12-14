import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geideapay/common/geidea.dart';
import 'package:geideapay/geideapay.dart';
import 'package:test_app/apiFlow.dart';
import 'package:test_app/checkoutFlow.dart';

const String appName = 'Geidea Example';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String geideaPublicKey = '';
  String geideaApiPassword = '';
  var publicKeyTxt = TextEditingController();
  var apiPasswordTxt = TextEditingController();
  @override
  void initState() {
    publicKeyTxt.text = geideaPublicKey = 'f7bdf1db-f67e-409b-8fe7-f7ecf9634f70';
    apiPasswordTxt.text = geideaApiPassword = '0c9b36c1-3410-4b96-878a-dbd54ace4e9a';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(appName),  backgroundColor: Colors.red,),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: Form(
                child: SingleChildScrollView(
                    child: ListBody(
                        children: <Widget>[
                          TextField(
                            controller: publicKeyTxt,
                            onChanged: (value) {
                              setState(() {
                                geideaPublicKey = value;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Public Key',
                              labelText: 'Public Key',
                              contentPadding:
                              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(1.0)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextField(
                            controller: apiPasswordTxt,
                            onChanged: (value) {
                              setState(() {
                                geideaApiPassword = value;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Api Password',
                              labelText: 'Api Password',
                              contentPadding:
                              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(1.0)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                flex: 2,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: _getPlatformButton(
                                      'Checkout Flow',
                                          () => _handleCheckout(context),
                                      (geideaApiPassword != '' && geideaPublicKey != '') ?  true : false
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                flex: 2,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: _getPlatformButton(
                                      'API Flow',
                                          () => _handleApi(context),
                                      (geideaApiPassword != '' && geideaPublicKey != '') ?  true : false
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]
                    )
                )
            )
        )
    );
  }

  _handleCheckout(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CheckoutFlow(geideaPublicKey, geideaApiPassword)),
    );
  }

  _handleApi(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ApiFlow(geideaPublicKey, geideaApiPassword)),
    );
  }

  Widget _getPlatformButton(String string, Function() function, bool active) {
    // is still in progress
    Widget widget;
    if (Platform.isIOS) {
      widget = CupertinoButton(
        onPressed: function,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        color: active? CupertinoColors.activeBlue : CupertinoColors.inactiveGray,
        child: Text(
          string,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      widget = ElevatedButton(
        onPressed: active? function : null,
        child: Text(
          string.toUpperCase(),
          style: const TextStyle(fontSize: 17.0),
        ),
        style: ButtonStyle(
            backgroundColor: active? MaterialStateProperty.all(Colors.lightBlue) : MaterialStateProperty.all(Colors.grey)),
      );
    }
    return widget;
  }
}
