import 'package:geideapay/api/response/order_api_response.dart';
import 'package:geideapay/api/response/payment_intent_api_response.dart';
import 'package:geideapay/api/response/payment_notification_api_response.dart';

import '../../response/request_pay_api_response.dart';

abstract class PayServiceContract {
  Future<OrderApiResponse> directPay(Map<String, Object?>? fields,
      String publicKey, String apiPassword, String baseUrl);

  Future<OrderApiResponse> payWithToken(Map<String, Object?>? fields,
      String publicKey, String apiPassword, String baseUrl);

  Future<OrderApiResponse> capture(Map<String, Object?>? fields,
      String publicKey, String apiPassword, String baseUrl);

  Future<OrderApiResponse> refund(Map<String, Object?>? fields,
      String publicKey, String apiPassword, String baseUrl);

  Future<OrderApiResponse> cancel(Map<String, Object?>? fields,
      String publicKey, String apiPassword, String baseUrl);

  Future<OrderApiResponse> voidOperation(Map<String, Object?>? fields,
      String publicKey, String apiPassword, String baseUrl);

  Future<RequestPayApiResponse> requestToPay(Map<String, Object?>? fields,
      String publicKey, String apiPassword, String baseUrl);

  Future<PaymentIntentApiResponse> paymentIntent(String paymentIntentId,
      String publicKey, String apiPassword, String baseUrl);

  Future<OrderApiResponse> orderDetail(String merchantPublicKey, String orderId,
      String publicKey, String apiPassword, String baseUrl);

  Future<PaymentNotificationApiResponse> paymentNotification(
      Map<String, Object?>? fields,
      String publicKey,
      String apiPassword,
      String baseUrl);
}
