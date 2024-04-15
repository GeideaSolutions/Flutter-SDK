import 'dart:async';
import 'package:geideapay/api/request/direct_session_request_body.dart';
import 'package:geideapay/api/response/direct_session_api_response.dart';
import 'package:geideapay/api/service/session_service.dart';
import 'package:geideapay/models/card.dart';
import 'package:geideapay/transaction/session_transaction_manager.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
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
import 'package:geideapay/common/utils.dart';
import 'package:geideapay/api/response/order_api_response.dart';
import 'package:geideapay/transaction/authentication_transaction_manager.dart';
import 'package:geideapay/transaction/pay_transaction_manager.dart';
import 'package:geideapay/widgets/checkout/checkout_options.dart';
import 'package:geideapay/widgets/checkout/credit_card_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class GeideapayPlugin {
  bool _sdkInitialized = false;
  String _publicKey = "";
  String _apiPassword = "";
  String _baseUrl = "";

  /// Initialize the Geideapay object. It should be called as early as possible
  /// (preferably in initState() of the Widget.
  ///
  /// [publicKey] - your Geideapay public key. This is mandatory
  /// [apiPassword] - your Geideapay API Password. This is mandatory
  /// [baseUrl] - your Geideapay API Base Url. This is mandatory eg: https://api.merchant.geidea.net/pgw/api
  ///
  ///
  initialize(
      {required String publicKey,
      required String apiPassword,
      required String baseUrl}) async {
    assert(() {
      if (publicKey.isEmpty) {
        throw GeideaException('publicKey cannot be null or empty');
      }
      if (apiPassword.isEmpty) {
        throw GeideaException('API Password cannot be null or empty');
      }
      if (baseUrl.isEmpty) {
        throw GeideaException('API Base Url cannot be null or empty');
      }
      return true;
    }());

    if (sdkInitialized) return;

    _publicKey = publicKey;
    _apiPassword = apiPassword;
    _baseUrl = baseUrl;
    _sdkInitialized = true;
  }

  dispose() {
    _publicKey = "";
    _apiPassword = "";
    _baseUrl = "";
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

  String get baseUrl {
    // Validate that the sdk has been initialized
    _validateSdkInitialized();
    return _baseUrl;
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
    if (_baseUrl.isEmpty) {
      throw AuthenticationException(Utils.getBaseUrlErrorMsg('API Base Url'));
    }
  }

  /// Checkout operation
  ///
  /// [checkoutRequestBody] - the checkout request body
  ///

  Future<OrderApiResponse> checkout(
      {required BuildContext context,
      required CheckoutOptions checkoutOptions}) async {
    _performChecks();

    AuthenticationApiResponse? authenticationApiResponse;
    CheckoutRequestBody? checkoutRequestBodyOfCardComplete;

    CreditCardScreen creditCardScreen = CreditCardScreen(
      checkoutOptions: checkoutOptions,
      onCardEditComplete: (PaymentCard paymentCard) async {
        authenticationApiResponse = null;

        checkoutRequestBodyOfCardComplete =
            CheckoutRequestBody(checkoutOptions, paymentCard);

        checkoutRequestBodyOfCardComplete!
            .updateDirectSessionRequestBody(publicKey, apiPassword);
        print(checkoutRequestBodyOfCardComplete!.directSessionRequestBody);
        DirectSessionApiResponse directSessionApiResponse = await createSession(
          directSessionRequestBody:
              checkoutRequestBodyOfCardComplete!.directSessionRequestBody,
        );
        print(directSessionApiResponse);
        if (directSessionApiResponse.session == null) {
          throw (directSessionApiResponse.detailedResponseMessage!);
        }
        checkoutRequestBodyOfCardComplete!
            .updateInitiateAuthenticationRequestBody(
                directSessionApiResponse.session);

        print(checkoutRequestBodyOfCardComplete!
            .initiateAuthenticationRequestBody);
        authenticationApiResponse = await initiateAuthentication(
            initiateAuthenticationRequestBody:
                checkoutRequestBodyOfCardComplete!
                    .initiateAuthenticationRequestBody);
        print(authenticationApiResponse);
      },
    );

    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => creditCardScreen),
    );

    if (result == "OK") {
      checkoutOptions.cardOnFile = creditCardScreen.saveCard;
      CheckoutRequestBody checkoutRequestBody =
          CheckoutRequestBody(checkoutOptions, creditCardScreen.paymentCard);
      try {
        return _Geideapay(publicKey, apiPassword, baseUrl).checkout(
          checkoutRequestBody:
              checkoutRequestBodyOfCardComplete ?? checkoutRequestBody,
          context: context,
          authenticationApiResponse: authenticationApiResponse,
        );
      } catch (e) {
        throw e;
      }
    } else {
      return OrderApiResponse(
          responseCode: "-1", detailedResponseCode: "Payment cancelled");
    }
  }

  /// Create Session operation
  ///
  /// [directSessionRequestBody] - the initiate create session request body
  ///

  Future<DirectSessionApiResponse> createSession(
      {required DirectSessionRequestBody directSessionRequestBody}) {
    _performChecks();

    return _Geideapay(publicKey, apiPassword, baseUrl)
        .createSession(directSessionRequestBody: directSessionRequestBody);
  }

  /// Initiate Authentication operation
  ///
  /// [initiateAuthenticationRequestBody] - the initiate authentication request body
  ///

  Future<AuthenticationApiResponse> initiateAuthentication(
      {required InitiateAuthenticationRequestBody
          initiateAuthenticationRequestBody}) {
    _performChecks();

    return _Geideapay(publicKey, apiPassword, baseUrl).initiateAuthentication(
        initiateAuthenticationRequestBody: initiateAuthenticationRequestBody);
  }

  /// Payer Authentication operation
  ///
  /// [payerAuthenticationRequestBody] - the payer authentication request body
  ///

  Future<AuthenticationApiResponse> payerAuthentication(
      {required PayerAuthenticationRequestBody payerAuthenticationRequestBody,
      required BuildContext context}) {
    _performChecks();

    return _Geideapay(publicKey, apiPassword, baseUrl).payerAuthentication(
        payerAuthenticationRequestBody: payerAuthenticationRequestBody,
        context: context);
  }

  /// Direct Pay operation
  ///
  /// [PayDirectRequestBody] - the direct pay request body
  ///

  Future<OrderApiResponse> directPay(
      {required PayDirectRequestBody payDirectRequestBody}) {
    _performChecks();

    return _Geideapay(publicKey, apiPassword, baseUrl)
        .directPay(payDirectRequestBody: payDirectRequestBody);
  }

  /// Refund operation
  ///
  /// [RefundRequestBody] - the refund request body
  ///

  Future<OrderApiResponse> refund(
      {required RefundRequestBody refundRequestBody}) {
    _performChecks();

    return _Geideapay(publicKey, apiPassword, baseUrl)
        .refund(refundRequestBody: refundRequestBody);
  }

  /// Cancel operation
  ///
  /// [CancelRequestBody] - the cancel request body
  ///

  Future<OrderApiResponse> cancel(
      {required CancelRequestBody cancelRequestBody}) {
    _performChecks();

    return _Geideapay(publicKey, apiPassword, baseUrl)
        .cancel(cancelRequestBody: cancelRequestBody);
  }

  /// Void operation
  ///
  /// [RefundRequestBody] - the void request body
  ///

  Future<OrderApiResponse> voidOperation(
      {required RefundRequestBody refundRequestBody}) {
    _performChecks();

    return _Geideapay(publicKey, apiPassword, baseUrl)
        .voidOperation(refundRequestBody: refundRequestBody);
  }

  Future<OrderApiResponse> capture(
      {required CaptureRequestBody captureRequestBody}) {
    _performChecks();

    return _Geideapay(publicKey, apiPassword, baseUrl)
        .capture(captureRequestBody: captureRequestBody);
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
  final String baseUrl;

  _Geideapay(this.publicKey, this.apiPassword, this.baseUrl);

  Future<OrderApiResponse> checkout({
    required CheckoutRequestBody checkoutRequestBody,
    required BuildContext context,
    AuthenticationApiResponse? authenticationApiResponse,
  }) async {
    try {
      if (authenticationApiResponse == null) {
        checkoutRequestBody.updateDirectSessionRequestBody(
            publicKey, apiPassword);
        print(checkoutRequestBody.directSessionRequestBody);
        DirectSessionApiResponse directSessionApiResponse = await createSession(
          directSessionRequestBody:
              checkoutRequestBody.directSessionRequestBody,
        );
        print(directSessionApiResponse);
        if (directSessionApiResponse.session == null) {
          throw (directSessionApiResponse.detailedResponseMessage!);
        }
        checkoutRequestBody.updateInitiateAuthenticationRequestBody(
            directSessionApiResponse.session);

        print(checkoutRequestBody.initiateAuthenticationRequestBody);
        authenticationApiResponse = await initiateAuthentication(
            initiateAuthenticationRequestBody:
                checkoutRequestBody.initiateAuthenticationRequestBody);
        print(authenticationApiResponse);
      }

      if (authenticationApiResponse.orderId == null) {
        throw (authenticationApiResponse.detailedResponseMessage!);
      }
      checkoutRequestBody.updatePayerAuthenticationRequestBody(
          authenticationApiResponse.orderId);

      print(checkoutRequestBody.payerAuthenticationRequestBody);
      AuthenticationApiResponse payerAuthenticationApiResponse =
          await payerAuthentication(
              payerAuthenticationRequestBody:
                  checkoutRequestBody.payerAuthenticationRequestBody,
              context: context);
      print(payerAuthenticationApiResponse);

      checkoutRequestBody.updatePayDirectRequestBody(
          payerAuthenticationApiResponse.threeDSecureId);

      print(checkoutRequestBody.payDirectRequestBody);
      OrderApiResponse orderApiResponse = await directPay(
          payDirectRequestBody: checkoutRequestBody.payDirectRequestBody);
      print(orderApiResponse);

      if (checkoutRequestBody.returnUrl != null) {
        Uri mainReturnURI = Uri.parse(checkoutRequestBody.returnUrl.toString());

        Map<String, String> mainReturnUriParam = {};
        mainReturnUriParam.addAll(mainReturnURI.queryParameters);
        mainReturnUriParam
            .addAll({"response": json.encode(orderApiResponse.toMap())});

        String finalReturnUrl = Path.join(mainReturnURI.toString(),
            orderApiResponse.responseMessage ?? "Failed");

        Uri returnUrlURI = Uri.parse(finalReturnUrl)
            .replace(queryParameters: mainReturnUriParam);

        if (!await launchUrl(returnUrlURI,
            mode: LaunchMode.externalApplication)) {
          print('Could not launch');
        }
      }
      return orderApiResponse;
    } catch (e) {
      throw (e);
    }
  }

  Future<DirectSessionApiResponse> createSession(
      {required DirectSessionRequestBody directSessionRequestBody}) {
    return SessionTransactionManager(
            context: null,
            service: SessionService(),
            apiPassword: apiPassword,
            publicKey: publicKey,
            baseUrl: baseUrl,
            directSessionRequestBody: directSessionRequestBody)
        .createSession();
  }

  Future<AuthenticationApiResponse> initiateAuthentication(
      {required InitiateAuthenticationRequestBody
          initiateAuthenticationRequestBody}) {
    return AuthenticationTransactionManager(
            context: null,
            service: AuthenticationService(),
            apiPassword: apiPassword,
            publicKey: publicKey,
            baseUrl: baseUrl,
            initiateAuthenticationRequestBody:
                initiateAuthenticationRequestBody)
        .initiateAuthentication();
  }

  Future<OrderApiResponse> directPay(
      {required PayDirectRequestBody payDirectRequestBody}) {
    return PayTransactionManager(
            service: PayService(),
            apiPassword: apiPassword,
            publicKey: publicKey,
            baseUrl: baseUrl,
            payDirectRequestBody: payDirectRequestBody)
        .payDirect();
  }

  Future<AuthenticationApiResponse> payerAuthentication(
      {required PayerAuthenticationRequestBody payerAuthenticationRequestBody,
      required BuildContext context}) {
    return AuthenticationTransactionManager(
            context: context,
            service: AuthenticationService(),
            apiPassword: apiPassword,
            publicKey: publicKey,
            baseUrl: baseUrl,
            payerAuthenticationRequestBody: payerAuthenticationRequestBody)
        .payerAuthentication();
  }

  Future<OrderApiResponse> refund(
      {required RefundRequestBody refundRequestBody}) {
    return PayTransactionManager(
            service: PayService(),
            apiPassword: apiPassword,
            publicKey: publicKey,
            baseUrl: baseUrl,
            refundRequestBody: refundRequestBody)
        .refund();
  }

  Future<OrderApiResponse> cancel(
      {required CancelRequestBody cancelRequestBody}) {
    return PayTransactionManager(
            service: PayService(),
            apiPassword: apiPassword,
            publicKey: publicKey,
            baseUrl: baseUrl,
            cancelRequestBody: cancelRequestBody)
        .cancel();
  }

  Future<OrderApiResponse> voidOperation(
      {required RefundRequestBody refundRequestBody}) {
    return PayTransactionManager(
            service: PayService(),
            apiPassword: apiPassword,
            publicKey: publicKey,
            baseUrl: baseUrl,
            refundRequestBody: refundRequestBody)
        .voidOperation();
  }

  Future<OrderApiResponse> capture(
      {required CaptureRequestBody captureRequestBody}) {
    return PayTransactionManager(
            service: PayService(),
            apiPassword: apiPassword,
            publicKey: publicKey,
            baseUrl: baseUrl,
            captureRequestBody: captureRequestBody)
        .capture();
  }
}

typedef OnTransactionChange<Transaction> = void Function(
    Transaction transaction);
typedef OnTransactionError<Object, Transaction> = void Function(
    Object e, Transaction transaction);
