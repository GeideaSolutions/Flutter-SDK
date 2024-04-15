import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geideapay/api/request/direct_session_request_body.dart';
import 'package:geideapay/api/response/direct_session_api_response.dart';
import 'package:geideapay/api/service/contracts/session_service_contract.dart';
import 'package:geideapay/common/exceptions.dart';
import 'package:geideapay/common/my_strings.dart';
import 'package:geideapay/transaction/base_transaction_manager.dart';

class SessionTransactionManager extends BaseTransactionManager {
  DirectSessionRequestBody? directSessionRequestBody;
  BuildContext? context;

  final SessionServiceContract service;

  SessionTransactionManager(
      {required this.context,
      required this.service,
      this.directSessionRequestBody,
      required String publicKey,
      required String apiPassword,
      required String baseUrl})
      : super(publicKey: publicKey, apiPassword: apiPassword, baseUrl: baseUrl);

  @override
  postInitiate() {}

  Future<DirectSessionApiResponse> createSession() async {
    try {
      await initiate();
      return sendCreateSessionOnServer();
    } catch (e) {
      if (e is! ProcessingException) {
        setProcessingOff();
      }
      return DirectSessionApiResponse(
          detailedResponseMessage: e.toString(), responseCode: "-1");
    }
  }

  Future<DirectSessionApiResponse> sendCreateSessionOnServer() {
    Future<DirectSessionApiResponse> future = service.createSession(
        directSessionRequestBody?.paramsMap(), publicKey, apiPassword, baseUrl);
    return handleCreateSessionApiServerResponse(future);
  }

  Future<DirectSessionApiResponse> handleCreateSessionApiServerResponse(
      Future<DirectSessionApiResponse> future) async {
    try {
      final apiResponse = await future;
      return _initApiResponse(apiResponse);
    } catch (e) {
      return notifySessionProcessingError(e);
    }
  }

  Future<DirectSessionApiResponse> _initApiResponse(
      DirectSessionApiResponse? apiResponse) {
    apiResponse ??= DirectSessionApiResponse.unknownServerResponse();

    return handleCreateSesstionApiResponse(apiResponse);
  }

  Future<DirectSessionApiResponse> handleCreateSesstionApiResponse(
      DirectSessionApiResponse apiResponse) async {
    var status = apiResponse.responseMessage?.toLowerCase();
    var code = apiResponse.responseCode?.toLowerCase();
    if (status == 'success' && code == '000') {
      setProcessingOff();
      return onSessionSuccess(apiResponse);
    }

    if (code != '000') {
      return notifySessionProcessingError(
          AuthenticationException(apiResponse.detailedResponseMessage!));
    }

    return notifySessionProcessingError(
        GeideaException(Strings.unKnownResponse));
  }
}
