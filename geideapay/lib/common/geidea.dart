import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geideapay/api/request/cancel_request_body.dart';
import 'package:geideapay/api/request/capture_request_body.dart';
import 'package:geideapay/api/request/checkout_request_body.dart';
import 'package:geideapay/api/request/pay_direct_request_body.dart';
import 'package:geideapay/api/request/payer_authentication_request_body.dart';
import 'package:geideapay/api/request/refund_request_body.dart';
import 'package:geideapay/api/response/authentication_api_response.dart';
import 'package:geideapay/api/request/initiate_authentication_request_body.dart';
import 'package:geideapay/api/service/authentication_service.dart';
import 'package:geideapay/api/service/pay_service.dart';
import 'package:geideapay/common/exceptions.dart';
import 'package:geideapay/common/my_strings.dart';
import 'package:geideapay/common/platform_info.dart';
import 'package:geideapay/common/string_utils.dart';
import 'package:geideapay/common/utils.dart';
import 'package:geideapay/models/card.dart';
import 'package:geideapay/api/response/order_api_response.dart';
import 'package:geideapay/transaction/authentication_transaction_manager.dart';
import 'package:geideapay/transaction/pay_transaction_manager.dart';
import 'package:geideapay/widgets/checkout/checkout_options.dart';
import 'package:geideapay/widgets/checkout/credit_card_screen.dart';

class GeideapayPlugin {
  bool _sdkInitialized = false;
  String _publicKey = "";
  String _apiPassword = "";

  /// Initialize the Geideapay object. It should be called as early as possible
  /// (preferably in initState() of the Widget.
  ///
  /// [publicKey] - your Geideapay public key. This is mandatory
  /// [apiPassword] - your Geideapay API Password. This is mandatory
  ///
  ///
  initialize({required String publicKey, required String apiPassword}) async {
    assert(() {
      if (publicKey.isEmpty) {
        throw GeideaException('publicKey cannot be null or empty');
      }
      if (apiPassword.isEmpty) {
        throw GeideaException('API Password cannot be null or empty');
      }
      return true;
    }());

    if (sdkInitialized) return;

    _publicKey = publicKey;
    _apiPassword = apiPassword;
    _sdkInitialized = true;
  }

  dispose() {
    _publicKey = "";
    _apiPassword = "";
    _sdkInitialized = false;
  }

  bool get sdkInitialized => _sdkInitialized;

  String get publicKey {
    // Validate that the sdk has been initialized
    _validateSdkInitialized();
    return _publicKey;
  }

  String get apiPassword {
    // Validate that the sdk has been initialized
    _validateSdkInitialized();
    return _apiPassword;
  }

  void _performChecks() {
    //validate that sdk has been initialized
    _validateSdkInitialized();
    //check for null value
    if (_publicKey.isEmpty) {
      throw AuthenticationException(Utils.getKeyErrorMsg('public'));
    }
    if (_apiPassword.isEmpty) {
      throw AuthenticationException(Utils.getPasswordErrorMsg('API password'));
    }
  }

  /// Checkout operation
  ///
  /// [checkoutRequestBody] - the checkout request body
  ///

  Future<OrderApiResponse> checkout(
      {required BuildContext context, required CheckoutOptions checkoutOptions}) async {
    _performChecks();

    CreditCardScreen creditCardScreen = CreditCardScreen(checkoutOptions: checkoutOptions);

    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => creditCardScreen),
    );

    if(result == "OK")
      {
        checkoutOptions.cardOnFile = creditCardScreen.saveCard;
        CheckoutRequestBody checkoutRequestBody =
        CheckoutRequestBody(checkoutOptions, creditCardScreen.paymentCard);
        try{
          return _Geideapay(publicKey, apiPassword).checkout(checkoutRequestBody: checkoutRequestBody, context: context);
        }
        catch(e){
          throw e;
        }
      }
    else{
      return OrderApiResponse(responseCode: "-1", detailedResponseCode: "Payment cancelled");
    }


  }

  /// Initiate Authentication operation
  ///
  /// [initiateAuthenticationRequestBody] - the initiate authentication request body
  ///

  Future<AuthenticationApiResponse> initiateAuthentication(
      {required InitiateAuthenticationRequestBody
          initiateAuthenticationRequestBody}) {
    _performChecks();

    return _Geideapay(publicKey, apiPassword).initiateAuthentication(
        initiateAuthenticationRequestBody: initiateAuthenticationRequestBody);
  }

  /// Payer Authentication operation
  ///
  /// [payerAuthenticationRequestBody] - the payer authentication request body
  ///

  Future<AuthenticationApiResponse> payerAuthentication(
      {required PayerAuthenticationRequestBody
      payerAuthenticationRequestBody,
      required BuildContext context}) {
    _performChecks();

    return _Geideapay(publicKey, apiPassword).payerAuthentication(
        payerAuthenticationRequestBody: payerAuthenticationRequestBody,
        context: context);
  }

  /// Direct Pay operation
  ///
  /// [PayDirectRequestBody] - the direct pay request body
  ///

  Future<OrderApiResponse> directPay(
      {required PayDirectRequestBody
      payDirectRequestBody}) {
    _performChecks();

    return _Geideapay(publicKey, apiPassword).directPay(
        payDirectRequestBody: payDirectRequestBody);
  }

  /// Refund operation
  ///
  /// [RefundRequestBody] - the refund request body
  ///

  Future<OrderApiResponse> refund(
      {required RefundRequestBody
      refundRequestBody}) {
    _performChecks();

    return _Geideapay(publicKey, apiPassword).refund(
        refundRequestBody: refundRequestBody);
  }


  /// Cancel operation
  ///
  /// [CancelRequestBody] - the cancel request body
  ///

  Future<OrderApiResponse> cancel(
      {required CancelRequestBody
      cancelRequestBody}) {
    _performChecks();

    return _Geideapay(publicKey, apiPassword).cancel(
        cancelRequestBody: cancelRequestBody);
  }

  /// Void operation
  ///
  /// [RefundRequestBody] - the void request body
  ///

  Future<OrderApiResponse> voidOperation(
      {required RefundRequestBody
      refundRequestBody}) {
    _performChecks();

    return _Geideapay(publicKey, apiPassword).voidOperation(
        refundRequestBody: refundRequestBody);
  }

  Future<OrderApiResponse> capture(
      {required CaptureRequestBody
      captureRequestBody}) {
    _performChecks();

    return _Geideapay(publicKey, apiPassword).capture(
        captureRequestBody: captureRequestBody);
  }

  _validateSdkInitialized() {
    if (!sdkInitialized) {
      throw GeideaSdkNotInitializedException(
          'Geideapay SDK has not been initialized. The SDK has'
          ' to be initialized before use');
    }
  }
}

class _Geideapay {
  final String publicKey;
  final String apiPassword;

  _Geideapay(this.publicKey, this.apiPassword);


  Future<OrderApiResponse> checkout(
      {
        required CheckoutRequestBody checkoutRequestBody,
        required BuildContext context
      }
      ) async {

    try {
      print(checkoutRequestBody.initiateAuthenticationRequestBody);
      AuthenticationApiResponse authenticationApiResponse =
      await initiateAuthentication(initiateAuthenticationRequestBody:
      checkoutRequestBody.initiateAuthenticationRequestBody);
      print(authenticationApiResponse);

      if(authenticationApiResponse.orderId == null)
        {
          throw(authenticationApiResponse.detailedResponseMessage!);
        }
      checkoutRequestBody.updatePayerAuthenticationRequestBody(authenticationApiResponse.orderId);

      print(checkoutRequestBody.payerAuthenticationRequestBody);
      AuthenticationApiResponse payerAuthenticationApiResponse =
      await payerAuthentication(payerAuthenticationRequestBody:
          checkoutRequestBody.payerAuthenticationRequestBody, context: context);
      print(payerAuthenticationApiResponse);

      checkoutRequestBody.updatePayDirectRequestBody(payerAuthenticationApiResponse.threeDSecureId);

      print(checkoutRequestBody.payDirectRequestBody);
      OrderApiResponse orderApiResponse =
      await directPay(payDirectRequestBody: checkoutRequestBody.payDirectRequestBody);
      print(orderApiResponse);
      
      return orderApiResponse;

    } catch (e) {
      throw(e);
    }



  }

  Future<AuthenticationApiResponse> initiateAuthentication(
      {required InitiateAuthenticationRequestBody
          initiateAuthenticationRequestBody}) {
    return AuthenticationTransactionManager(
            context: null,
            service: AuthenticationService(),
            apiPassword: apiPassword,
            publicKey: publicKey,
            initiateAuthenticationRequestBody:
                initiateAuthenticationRequestBody)
        .initiateAuthentication();
  }

  Future<OrderApiResponse> directPay(
      {required PayDirectRequestBody
      payDirectRequestBody}) {
    return PayTransactionManager(
        service: PayService(),
        apiPassword: apiPassword,
        publicKey: publicKey,
        payDirectRequestBody:
        payDirectRequestBody)
        .payDirect();
  }

  Future<AuthenticationApiResponse> payerAuthentication(
      {required PayerAuthenticationRequestBody
      payerAuthenticationRequestBody,
        required BuildContext context}) {
    return AuthenticationTransactionManager(
        context: context,
        service: AuthenticationService(),
        apiPassword: apiPassword,
        publicKey: publicKey,
        payerAuthenticationRequestBody:
        payerAuthenticationRequestBody)
        .payerAuthentication();
  }

  Future<OrderApiResponse> refund(
      {required RefundRequestBody refundRequestBody}) {
    return PayTransactionManager(
        service: PayService(),
        apiPassword: apiPassword,
        publicKey: publicKey,
        refundRequestBody:
        refundRequestBody)
        .refund();
  }

  Future<OrderApiResponse> cancel(
      {required CancelRequestBody cancelRequestBody}) {
    return PayTransactionManager(
        service: PayService(),
        apiPassword: apiPassword,
        publicKey: publicKey,
        cancelRequestBody:
        cancelRequestBody)
        .cancel();
  }

  Future<OrderApiResponse> voidOperation(
      {required RefundRequestBody refundRequestBody}) {
    return PayTransactionManager(
        service: PayService(),
        apiPassword: apiPassword,
        publicKey: publicKey,
        refundRequestBody:
        refundRequestBody)
        .voidOperation();
  }

  Future<OrderApiResponse> capture(
      {required CaptureRequestBody captureRequestBody}) {
    return PayTransactionManager(
        service: PayService(),
        apiPassword: apiPassword,
        publicKey: publicKey,
        captureRequestBody:
        captureRequestBody)
        .capture();
  }

}

typedef OnTransactionChange<Transaction> = void Function(
    Transaction transaction);
typedef OnTransactionError<Object, Transaction> = void Function(
    Object e, Transaction transaction);

