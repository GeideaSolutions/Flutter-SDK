import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geideapay/api/request/initiate_authentication_request_body.dart';
import 'package:geideapay/api/request/pay_direct_request_body.dart';
import 'package:geideapay/api/request/payer_authentication_request_body.dart';
import 'package:geideapay/api/request/refund_request_body.dart';
import 'package:geideapay/api/response/authentication_api_response.dart';
import 'package:geideapay/api/response/order_api_response.dart';
import 'package:geideapay/common/geidea.dart';
import 'package:geideapay/geideapay.dart';
import 'package:geideapay/widgets/checkout/checkout_options.dart';


class ApiFlow extends StatefulWidget {

  String geideaPublicKey = '';

  String geideaApiPassword = '';

  ApiFlow(this.geideaPublicKey, this.geideaApiPassword, {Key? key}) : super(key: key);

  @override
  _ApiFlowState createState() => _ApiFlowState();
}

class _ApiFlowState extends State<ApiFlow> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _verticalSizeBox = const SizedBox(height: 20.0);
  final _horizontalSizeBox = const SizedBox(width: 10.0);
  final plugin = GeideapayPlugin();
  final _border = Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.red,
  );
  int _radioValue = 0;
  bool _apiInProgress = false;
  bool _checkoutInProgress = false;
  String _apiAmount = "100";
  String _checkoutAmount = "100";
  String _currency = "EGP";
  final String _callbackUrl = "https://returnurl.com";
  final String _returnUrl ="https://returnurl.com";
  final bool _cardOnFile = true;

  String? _cardNumber = "4242424242424242";
  String? cardholderName = "Ahmed";
  String? _cvv = "123";
  int? _expiryMonth = 11;
  int? _expiryYear = 25;

  String? _orderId;

  String? _threeDSecureId;

  PaymentCard? card;

  OrderApiResponse? orderApiResponse;

  @override
  void initState() {
    plugin.initialize(publicKey: widget.geideaPublicKey, apiPassword: widget.geideaApiPassword );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout Flow"), backgroundColor: Colors.red,),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const SizedBox(
                  height: 40.0,
                ),
                const Text("APIs Flow", style: TextStyle(
                    fontSize: 21.0, fontWeight: FontWeight.bold)),
                _verticalSizeBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child:
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Amount',
                        ),
                        initialValue: _apiAmount,
                        validator: validateNumber('amount'),
                        onSaved: (String? value) => _apiAmount = value!,
                      ),
                    ),
                    _horizontalSizeBox,
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Currency',
                        ),
                        onSaved: (String? value) =>
                        _currency = (value ?? "EGP"),
                        initialValue: _currency,
                      ),
                    ),
                  ],
                ),
                _verticalSizeBox,
                TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Card holder name',
                  ),
                  validator: validateNumber('card holder name'),
                  onSaved: (String? value) => cardholderName = value,
                  initialValue: cardholderName,
                ),
                _verticalSizeBox,
                TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Card number',
                  ),
                  validator: validateNumber('card number'),
                  onSaved: (String? value) => _cardNumber = value,
                  initialValue: _cardNumber,
                ),
                _verticalSizeBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'CVV',
                        ),
                        initialValue: _cvv,
                        validator: validateNumber('cvv'),
                        onSaved: (String? value) => _cvv = value!,
                      ),
                    ),
                    _horizontalSizeBox,
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Expiry Month',
                        ),
                        onSaved: (String? value) =>
                        _expiryMonth = int.tryParse(value ?? ""),
                        initialValue: _expiryMonth.toString(),
                        validator: validateNumber('expiry month'),
                      ),
                    ),
                    _horizontalSizeBox,
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Expiry Year',
                        ),
                        onSaved: (String? value) =>
                        _expiryYear = int.tryParse(value ?? ""),
                        initialValue: _expiryYear.toString(),
                        validator: validateNumber('expiry year'),
                      ),
                    )
                  ],
                ),
                _verticalSizeBox,
                Theme(
                  data: Theme.of(context).copyWith(
                    accentColor: green,
                    primaryColorLight: Colors.white,
                    primaryColorDark: navyBlue,
                    textTheme: Theme
                        .of(context)
                        .textTheme
                        .copyWith(
                      bodyText2: const TextStyle(
                        color: lightBlue,
                      ),
                    ),
                  ),
                  child: Builder(
                    builder: (context) {
                      return _apiInProgress
                          ? Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Platform.isIOS
                            ? const CupertinoActivityIndicator()
                            : const CircularProgressIndicator(),
                      )
                          : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _verticalSizeBox,
                          const SizedBox(
                            height: 40.0,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _horizontalSizeBox,
                              Flexible(
                                flex: 2,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: _getPlatformButton(
                                      'initiate authentication',
                                          () => _handleInitAuth(context),
                                      true
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _horizontalSizeBox,
                              Flexible(
                                flex: 2,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: _getPlatformButton(
                                      'Payer authentication',
                                          () => _handlePayerAuth(context),
                                      _orderId != null
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _horizontalSizeBox,
                              Flexible(
                                flex: 2,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: _getPlatformButton(
                                      'Pay with card',
                                          () => _handlePayCard(context),
                                      _orderId != null &&
                                          _threeDSecureId != null
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _horizontalSizeBox,
                              Flexible(
                                flex: 2,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: _getPlatformButton(
                                      'Refund',
                                          () => _handleRefund(context),
                                      orderApiResponse != null
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String truncate(String text, { length: 200, omission: '...' }) {
    if (length >= text.length) {
      return text;
    }
    return text.replaceRange(length, text.length, omission);
  }

  _handleInitAuth(BuildContext context) async {

    if (_formKey.currentState!.validate()) {
      setState(() => _apiInProgress = true);
      _formKey.currentState?.save();

      card = _getCardFromUI();

      InitiateAuthenticationRequestBody initiateAuthenticationRequestBody =
      InitiateAuthenticationRequestBody(_apiAmount, _currency, card?.number,
          callbackUrl: _callbackUrl,
          cardOnFile: _cardOnFile);
      try {
        AuthenticationApiResponse response = await plugin
            .initiateAuthentication(
            initiateAuthenticationRequestBody: initiateAuthenticationRequestBody);
        print('Response = $response');
        setState(() => _apiInProgress = false);
        _orderId = response.orderId;
        _updateStatus(
            response.detailedResponseMessage, truncate(response.toString()));
      } catch (e) {
        setState(() => _apiInProgress = false);
        _showMessage("Check console for error");
        rethrow;
      }
    }
  }

  _handlePayerAuth(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _apiInProgress = true);
      _formKey.currentState?.save();

      PayerAuthenticationRequestBody payerAuthenticationRequestBody =
      PayerAuthenticationRequestBody(_apiAmount, _currency, card, _orderId!,
          callbackUrl: _callbackUrl, cardOnFile: _cardOnFile);

      try {
        AuthenticationApiResponse response =
        await plugin.payerAuthentication(
            payerAuthenticationRequestBody: payerAuthenticationRequestBody,
            context: context);
        print('Response = $response');
        setState(() => _apiInProgress = false);

        _updateStatus(
            response.detailedResponseMessage, truncate(response.toString()));

        _orderId = response.orderId;
        _threeDSecureId = response.threeDSecureId;
      } catch (e) {
        setState(() => _apiInProgress = false);
        _showMessage("Check console for error");
        rethrow;
      }
    }
  }

  _handlePayCard(BuildContext context) async {
    setState(() => _apiInProgress = true);
    _formKey.currentState?.save();

    PayDirectRequestBody payDirectRequestBody =
    PayDirectRequestBody(_threeDSecureId!, _orderId!, _apiAmount, _currency, card,
        callbackUrl: _callbackUrl);

    try {
      orderApiResponse =
      await plugin.directPay(payDirectRequestBody: payDirectRequestBody);
      print('Response = $orderApiResponse');
      setState(() => _apiInProgress = false);

      _updateStatus(orderApiResponse!.detailedResponseMessage, truncate(orderApiResponse!.toString()));

    } catch (e) {
      setState(() => _apiInProgress = false);
      _showMessage("Check console for error");
      rethrow;
    }
  }

  _handleRefund(BuildContext context) async {
    setState(() => _apiInProgress = true);
    _formKey.currentState?.save();

    RefundRequestBody refundRequestBody =
    RefundRequestBody(_orderId!);

    try {
      OrderApiResponse response =
      await plugin.refund(refundRequestBody: refundRequestBody);
      print('Response = $response');
      setState(() => _apiInProgress = false);

      _updateStatus(response.detailedResponseMessage, truncate(response.toString()));

    } catch (e) {
      setState(() => _apiInProgress = false);
      _showMessage("Check console for error");
      rethrow;
    }
  }

  _handleCheckout(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      CheckoutOptions checkoutOptions = CheckoutOptions(
        _checkoutAmount, _currency,
        callbackUrl: _callbackUrl,
        //lang: "AR"
      );

      setState(() => _checkoutInProgress = true);

      try {
        OrderApiResponse response =
        await plugin.checkout(
            context: context, checkoutOptions: checkoutOptions);
        print('Response = $response');
        setState(() => _checkoutInProgress = false);

        _updateStatus(
            response.detailedResponseMessage, truncate(response.toString()));
      } catch (e) {
        setState(() => _checkoutInProgress = false);
        _showMessage("Check console for error");
        rethrow;
      }
    }
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: _cardNumber,
      name: cardholderName,
      cvc: _cvv,
      expiryMonth: _expiryMonth,
      expiryYear: _expiryYear,
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

  _updateStatus(String? reference, String? message) {
    _showMessage('Reference: $reference \n Response: $message',
        const Duration(seconds: 7));
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: duration,
      action: SnackBarAction(
          label: 'CLOSE',
          onPressed: () =>
              ScaffoldMessenger.of(context).removeCurrentSnackBar()),
    ));
  }

  bool get _isLocal => _radioValue == 0;

  validateNumber(String s) {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter ' + s;
      }
      return null;
    };
  }
}

const Color green = Color(0xFF3db76d);
const Color lightBlue = Color(0xFF34a5db);
const Color navyBlue = Color(0xFF031b33);