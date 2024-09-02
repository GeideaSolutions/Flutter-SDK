import 'dart:async';
import 'package:geideapay/api/request/base/post_pay_operation_request_body.dart';
import 'package:geideapay/api/response/payment_notification_api_response.dart';
import 'package:geideapay/api/service/contracts/pay_service_contract.dart';
import 'package:geideapay/common/exceptions.dart';
import 'package:geideapay/common/my_strings.dart';
import 'package:geideapay/transaction/base_transaction_manager.dart';

class PaymentNotificationTransactionManager extends BaseTransactionManager {
  PostPayOperationRequestBody? postPayOperationRequestBody;

  final PayServiceContract service;

  PaymentNotificationTransactionManager(
      {required this.service,
      this.postPayOperationRequestBody,
      required String publicKey,
      required String apiPassword,
      required String baseUrl})
      : super(publicKey: publicKey, apiPassword: apiPassword, baseUrl: baseUrl);

  @override
  postInitiate() {}

  Future<PaymentNotificationApiResponse> meezaPaymentNotification() async {
    try {
      await initiate();
      return sendCreateSessionOnServer();
    } catch (e) {
      if (e is! ProcessingException) {
        setProcessingOff();
      }
      return PaymentNotificationApiResponse(errors: e.toString(), status: -1);
    }
  }

  Future<PaymentNotificationApiResponse> sendCreateSessionOnServer() {
    Future<PaymentNotificationApiResponse> future = service.paymentNotification(
        postPayOperationRequestBody?.paramsMap(),
        publicKey,
        apiPassword,
        baseUrl);
    return handleCreateSessionApiServerResponse(future);
  }

  Future<PaymentNotificationApiResponse> handleCreateSessionApiServerResponse(
      Future<PaymentNotificationApiResponse> future) async {
    try {
      final apiResponse = await future;
      return _initApiResponse(apiResponse);
    } catch (e) {
      return notifyPaymentNotificationProcessingError(e);
    }
  }

  Future<PaymentNotificationApiResponse> _initApiResponse(
      PaymentNotificationApiResponse? apiResponse) {
    apiResponse ??= PaymentNotificationApiResponse.unknownServerResponse();

    return handleCreateSesstionApiResponse(apiResponse);
  }

  Future<PaymentNotificationApiResponse> handleCreateSesstionApiResponse(
      PaymentNotificationApiResponse apiResponse) async {
    if (apiResponse.status == 200) {
      setProcessingOff();
      return onPaymentNotificationSuccess(apiResponse);
    }

    if (apiResponse.status == null) {
      return notifyPaymentNotificationProcessingError(
          AuthenticationException(apiResponse.errors!));
    }

    return notifyPaymentNotificationProcessingError(
        GeideaException(Strings.unKnownResponse));
  }
}
