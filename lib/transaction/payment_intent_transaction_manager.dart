import 'dart:async';
import 'package:geideapay/api/response/payment_intent_api_response.dart';
import 'package:geideapay/api/service/contracts/pay_service_contract.dart';
import 'package:geideapay/common/exceptions.dart';
import 'package:geideapay/common/my_strings.dart';
import 'package:geideapay/transaction/base_transaction_manager.dart';

class PaymentIntentTransactionManager extends BaseTransactionManager {
  String paymentIntentId;

  final PayServiceContract service;

  PaymentIntentTransactionManager(
      {required this.service,
      required this.paymentIntentId,
      required String publicKey,
      required String apiPassword,
      required String baseUrl})
      : super(publicKey: publicKey, apiPassword: apiPassword, baseUrl: baseUrl);

  @override
  postInitiate() {}

  Future<PaymentIntentApiResponse> getOrderId() async {
    try {
      await initiate();
      return sendCreateSessionOnServer();
    } catch (e) {
      if (e is! ProcessingException) {
        setProcessingOff();
      }
      return PaymentIntentApiResponse(
          detailedResponseMessage: e.toString(), responseCode: "-1");
    }
  }

  Future<PaymentIntentApiResponse> sendCreateSessionOnServer() {
    Future<PaymentIntentApiResponse> future =
        service.paymentIntent(paymentIntentId, publicKey, apiPassword, baseUrl);
    return handleCreateSessionApiServerResponse(future);
  }

  Future<PaymentIntentApiResponse> handleCreateSessionApiServerResponse(
      Future<PaymentIntentApiResponse> future) async {
    try {
      final apiResponse = await future;
      return _initApiResponse(apiResponse);
    } catch (e) {
      return notifyPaymentIntentProcessingError(e);
    }
  }

  Future<PaymentIntentApiResponse> _initApiResponse(
      PaymentIntentApiResponse? apiResponse) {
    apiResponse ??= PaymentIntentApiResponse.unknownServerResponse();

    return handleCreateSesstionApiResponse(apiResponse);
  }

  Future<PaymentIntentApiResponse> handleCreateSesstionApiResponse(
      PaymentIntentApiResponse apiResponse) async {
    var code = apiResponse.responseCode?.toLowerCase();
    if (code == '000') {
      setProcessingOff();
      return onPaymentIntentSuccess(apiResponse);
    }

    if (code != '000') {
      return notifyPaymentIntentProcessingError(
          AuthenticationException(apiResponse.detailedResponseMessage!));
    }

    return notifyPaymentIntentProcessingError(
        GeideaException(Strings.unKnownResponse));
  }
}
