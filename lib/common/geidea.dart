import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

        return _Geideapay(publicKey, apiPassword).checkout(checkoutRequestBody: checkoutRequestBody, context: context);
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
  /// [RefundRequestBody] - the refund request body
  ///

  Future<OrderApiResponse> cancel(
      {required RefundRequestBody
      refundRequestBody}) {
    _performChecks();

    return _Geideapay(publicKey, apiPassword).cancel(
        refundRequestBody: refundRequestBody);
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

  /// Make payment using Geideapay's checkout form. The plugin will handle the whole
  /// processes involved.
  ///
  /// [context] - the widget's BuildContext
  ///
  /// [charge] - the charge object.
  ///
  /// [method] - The payment method to use(card, bank). It defaults to
  /// [CheckoutMethod.selectable] to allow the user to select. For [CheckoutMethod.bank]
  ///  or [CheckoutMethod.selectable], it is
  /// required that you supply an access code to the [Charge] object passed to [charge].
  /// For [CheckoutMethod.card], though not recommended, passing a reference to the
  /// [Charge] object will do just fine.
  ///
  /// Notes:
  ///
  /// * You can also pass the [PaymentCard] object and we'll use it to prepopulate the
  /// card  fields if card payment is being used
  ///
  /// [fullscreen] - Whether to display the payment in a full screen dialog or not
  ///
  /// [logo] - The widget to display at the top left of the payment prompt.
  /// Defaults to an Image widget with Geideapay's logo.
  ///
  /// [hideEmail] - Whether to hide the email from the user. When
  /// `false` and an email is passed to the [charge] object, the email
  /// will be displayed at the top right edge of the UI prompt. Defaults to
  /// `false`
  ///
  /// [hideAmount]  - Whether to hide the amount from the  payment prompt.
  /// When `false` the payment amount and currency is displayed at the
  /// top of payment prompt, just under the email. Also the payment
  /// call-to-action will display the amount, otherwise it will display
  /// "Continue". Defaults to `false`
  // Future<OrderApiResponse> checkout(
  //   BuildContext context, {
  //   required Charge charge,
  //   bool fullscreen = false,
  //   Widget? logo,
  //   bool hideEmail = false,
  //   bool hideAmount = false,
  // }) async {
  //   return _Geideapay(publicKey, apiPassword).checkout(
  //     context,
  //     charge: charge,
  //     fullscreen: fullscreen,
  //     logo: logo,
  //     hideAmount: hideAmount,
  //     hideEmail: hideEmail,
  //   );
  // }

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
      AuthenticationApiResponse authenticationApiResponse =
      await initiateAuthentication(initiateAuthenticationRequestBody:
      checkoutRequestBody.initiateAuthenticationRequestBody);

      checkoutRequestBody.updatePayerAuthenticationRequestBody(authenticationApiResponse.orderId);

      AuthenticationApiResponse payerAuthenticationApiResponse =
      await payerAuthentication(payerAuthenticationRequestBody:
          checkoutRequestBody.payerAuthenticationRequestBody, context: context);

      checkoutRequestBody.updatePayDirectRequestBody(payerAuthenticationApiResponse.threeDSecureId);

      OrderApiResponse orderApiResponse =
      await directPay(payDirectRequestBody: checkoutRequestBody.payDirectRequestBody);

      return orderApiResponse;

    } catch (e) {
      rethrow;
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
      {required RefundRequestBody refundRequestBody}) {
    return PayTransactionManager(
        service: PayService(),
        apiPassword: apiPassword,
        publicKey: publicKey,
        refundRequestBody:
        refundRequestBody)
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

