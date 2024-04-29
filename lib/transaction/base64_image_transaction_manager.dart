import 'dart:async';

import 'package:geideapay/api/request/base64_image_request_body.dart';
import 'package:geideapay/api/response/base64_image_api_response.dart';
import 'package:geideapay/api/service/contracts/base64_image_service_contract.dart';
import 'package:geideapay/common/exceptions.dart';
import 'package:geideapay/common/my_strings.dart';
import 'package:geideapay/transaction/base_transaction_manager.dart';

class Base64ImageTransactionManager extends BaseTransactionManager {
  Base64ImageRequestBody? base64imageRequestBody;

  final Base64ImageServiceContract service;

  Base64ImageTransactionManager(
      {required this.service,
      this.base64imageRequestBody,
      required String publicKey,
      required String apiPassword,
      required String baseUrl})
      : super(publicKey: publicKey, apiPassword: apiPassword, baseUrl: baseUrl);

  @override
  postInitiate() {}

  Future<Base64ImageApiResponse> generateImage() async {
    try {
      await initiate();
      return sendCreateSessionOnServer();
    } catch (e) {
      if (e is! ProcessingException) {
        setProcessingOff();
      }
      return Base64ImageApiResponse(
          detailedResponseMessage: e.toString(), responseCode: "-1");
    }
  }

  Future<Base64ImageApiResponse> sendCreateSessionOnServer() {
    Future<Base64ImageApiResponse> future = service.generateImage(
        base64imageRequestBody?.paramsMap(), publicKey, apiPassword, baseUrl);
    return handleCreateSessionApiServerResponse(future);
  }

  Future<Base64ImageApiResponse> handleCreateSessionApiServerResponse(
      Future<Base64ImageApiResponse> future) async {
    try {
      final apiResponse = await future;
      return _initApiResponse(apiResponse);
    } catch (e) {
      return notifyImageProcessingError(e);
    }
  }

  Future<Base64ImageApiResponse> _initApiResponse(
      Base64ImageApiResponse? apiResponse) {
    apiResponse ??= Base64ImageApiResponse.unknownServerResponse();

    return handleCreateSesstionApiResponse(apiResponse);
  }

  Future<Base64ImageApiResponse> handleCreateSesstionApiResponse(
      Base64ImageApiResponse apiResponse) async {
    var status = apiResponse.responseMessage?.toLowerCase();
    var code = apiResponse.responseCode?.toLowerCase();
    if (status == 'success' && code == '000') {
      setProcessingOff();
      return onImageSuccess(apiResponse);
    }

    if (code != '000') {
      return notifyImageProcessingError(
          AuthenticationException(apiResponse.detailedResponseMessage!));
    }

    return notifyImageProcessingError(GeideaException(Strings.unKnownResponse));
  }
}
