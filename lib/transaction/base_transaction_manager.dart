import 'dart:async';
import 'dart:io';
import 'package:geideapay/api/response/authentication_api_response.dart';
import 'package:geideapay/api/response/direct_session_api_response.dart';
import 'package:geideapay/common/exceptions.dart';
import 'package:geideapay/api/response/order_api_response.dart';

abstract class BaseTransactionManager {
  bool processing = false;
  final String publicKey;
  final String apiPassword;
  final String baseUrl;

  BaseTransactionManager({
    required this.apiPassword,
    required this.publicKey,
    required this.baseUrl,
  });

  initiate() async {
    if (processing) throw ProcessingException();

    setProcessingOn();
    await postInitiate();
  }

  setProcessingOff() => processing = false;

  setProcessingOn() => processing = true;

  AuthenticationApiResponse notifyAuthenticationProcessingError(Object e) {
    setProcessingOff();

    if (e is TimeoutException || e is SocketException) {
      e = 'Please  check your internet connection or try again later';
    }
    return AuthenticationApiResponse(
        detailedResponseMessage: e.toString(), responseCode: "-1");
  }

  AuthenticationApiResponse onAuthenticationSuccess(
      AuthenticationApiResponse apiResponse) {
    return apiResponse;
  }

  postInitiate();

  OrderApiResponse notifyPayProcessingError(Object e) {
    setProcessingOff();

    if (e is TimeoutException || e is SocketException) {
      e = 'Please  check your internet connection or try again later';
    }
    return OrderApiResponse(
        detailedResponseMessage: e.toString(), responseCode: "-1");
  }

  OrderApiResponse onPaySuccess(OrderApiResponse apiResponse) {
    return apiResponse;
  }

  DirectSessionApiResponse notifySessionProcessingError(Object e) {
    setProcessingOff();

    if (e is TimeoutException || e is SocketException) {
      e = 'Please  check your internet connection or try again later';
    }
    return DirectSessionApiResponse(
        detailedResponseMessage: e.toString(), responseCode: "-1");
  }

  DirectSessionApiResponse onSessionSuccess(
      DirectSessionApiResponse apiResponse) {
    return apiResponse;
  }
}
