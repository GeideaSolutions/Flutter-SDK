import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geideapay/api/request/payer_authentication_request_body.dart';
import 'package:geideapay/api/response/authentication_api_response.dart';
import 'package:geideapay/api/request/initiate_authentication_request_body.dart';
import 'package:geideapay/api/service/contracts/authentication_service_contract.dart';
import 'package:geideapay/common/exceptions.dart';
import 'package:geideapay/common/my_strings.dart';
import 'package:geideapay/transaction/base_transaction_manager.dart';
import 'package:geideapay/widgets/threeds.dart';

class AuthenticationTransactionManager extends BaseTransactionManager {
  InitiateAuthenticationRequestBody? initiateAuthenticationRequestBody;
  PayerAuthenticationRequestBody? payerAuthenticationRequestBody;
  BuildContext? context;

  final AuthenticationServiceContract service;

  AuthenticationTransactionManager(
      {required this.context,
      required this.service,
      this.initiateAuthenticationRequestBody,
      this.payerAuthenticationRequestBody,
      required String publicKey,
      required String apiPassword,
      required String baseUrl})
      : super(publicKey: publicKey, apiPassword: apiPassword, baseUrl: baseUrl);

  @override
  postInitiate() {}

  Future<AuthenticationApiResponse> initiateAuthentication() async {
    try {
      await initiate();
      return sendInitiateAuthenticationOnServer();
    } catch (e) {
      if (e is! ProcessingException) {
        setProcessingOff();
      }
      return AuthenticationApiResponse(
          detailedResponseMessage: e.toString(), responseCode: "-1");
    }
  }

  Future<AuthenticationApiResponse> sendInitiateAuthenticationOnServer() {
    Future<AuthenticationApiResponse> future = service.initiateAuthentication(
        initiateAuthenticationRequestBody?.paramsMap(),
        publicKey,
        apiPassword,
        baseUrl);
    return handleAuthenticationApiServerResponse(future);
  }

  Future<AuthenticationApiResponse> handleAuthenticationApiServerResponse(
      Future<AuthenticationApiResponse> future) async {
    try {
      final apiResponse = await future;
      return _initApiResponse(apiResponse);
    } catch (e) {
      return notifyAuthenticationProcessingError(e);
    }
  }

  Future<AuthenticationApiResponse> _initApiResponse(
      AuthenticationApiResponse? apiResponse) {
    apiResponse ??= AuthenticationApiResponse.unknownServerResponse();

    return handleAuthenticationApiResponse(apiResponse);
  }

  Future<AuthenticationApiResponse> handleAuthenticationApiResponse(
      AuthenticationApiResponse apiResponse) async {
    var status = apiResponse.responseMessage?.toLowerCase();
    var code = apiResponse.responseCode?.toLowerCase();
    if (status == 'success' && code == '000') {
      if (context != null) {
        String? responseHtml = apiResponse.html;
        responseHtml = responseHtml!
            .replaceAll('target="redirectTo3ds1Frame"', 'target="_top"');
        responseHtml =
            responseHtml.replaceAll('target="challengeFrame"', 'target="_top"');

        String? returnUrl = initiateAuthenticationRequestBody?.ReturnUrl;
        returnUrl ??= payerAuthenticationRequestBody?.ReturnUrl;

        await Navigator.push(
          context!,
          MaterialPageRoute(
              builder: (context) => ThreeDSPage(responseHtml, returnUrl)),
        );
      }

      setProcessingOff();
      return onAuthenticationSuccess(apiResponse);
    }

    if (code != '000') {
      return notifyAuthenticationProcessingError(
          AuthenticationException(apiResponse.detailedResponseMessage!));
    }

    return notifyAuthenticationProcessingError(
        GeideaException(Strings.unKnownResponse));
  }

  Future<AuthenticationApiResponse> payerAuthentication() async {
    try {
      await initiate();
      return sendPayerAuthenticationOnServer();
    } catch (e) {
      if (e is! ProcessingException) {
        setProcessingOff();
      }
      return AuthenticationApiResponse(
          detailedResponseMessage: e.toString(), responseCode: "-1");
    }
  }

  Future<AuthenticationApiResponse> sendPayerAuthenticationOnServer() {
    Future<AuthenticationApiResponse> future = service.authenticatePayer(
        payerAuthenticationRequestBody?.paramsMap(),
        publicKey,
        apiPassword,
        baseUrl);
    return handleAuthenticationApiServerResponse(future);
  }
}
