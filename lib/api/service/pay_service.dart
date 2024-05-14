import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:geideapay/api/response/order_api_response.dart';
import 'package:geideapay/api/response/payment_intent_api_response.dart';
import 'package:geideapay/api/response/payment_notification_api_response.dart';
import 'package:geideapay/api/service/base_service.dart';
import 'package:geideapay/api/service/contracts/pay_service_contract.dart';
import 'package:geideapay/common/exceptions.dart';
import 'package:geideapay/common/my_strings.dart';
import 'package:geideapay/common/extensions.dart';
import 'package:http/http.dart' as http;

import '../response/request_pay_api_response.dart';

class PayService with BaseApiService implements PayServiceContract {
  @override
  Future<OrderApiResponse> directPay(Map<String, Object?>? fields,
      String publicKey, String apiPassword, String baseUrl) async {
    var url = '$baseUrl/pgw/api/v2/direct/pay';
    return genResponse(url, fields, publicKey, apiPassword);
  }

  @override
  Future<OrderApiResponse> payWithToken(Map<String, Object?>? fields,
      String publicKey, String apiPassword, String baseUrl) async {
    var url = '$baseUrl/pgw/api/v1/direct/pay/token';
    return genResponse(url, fields, publicKey, apiPassword);
  }

  @override
  Future<OrderApiResponse> cancel(Map<String, Object?>? fields,
      String publicKey, String apiPassword, String baseUrl) async {
    var url = '$baseUrl/pgw/api/v1/direct/cancel';
    return genResponse(url, fields, publicKey, apiPassword);
  }

  @override
  Future<OrderApiResponse> capture(Map<String, Object?>? fields,
      String publicKey, String apiPassword, String baseUrl) async {
    var url = '$baseUrl/pgw/api/v1/direct/capture';
    return genResponse(url, fields, publicKey, apiPassword);
  }

  @override
  Future<OrderApiResponse> refund(Map<String, Object?>? fields,
      String publicKey, String apiPassword, String baseUrl) async {
    var url = '$baseUrl/pgw/api/v1/direct/refund';
    return genResponse(url, fields, publicKey, apiPassword);
  }

  @override
  Future<OrderApiResponse> voidOperation(Map<String, Object?>? fields,
      String publicKey, String apiPassword, String baseUrl) async {
    var url = '$baseUrl/pgw/api/v1/direct/refund';
    return genResponse(url, fields, publicKey, apiPassword);
  }

  @override
  Future<RequestPayApiResponse> requestToPay(Map<String, Object?>? fields,
      String publicKey, String apiPassword, String baseUrl) async {
    var url = '$baseUrl/meeza/api/v2/direct/transaction/requestToPay';
    return genRequestPayResponse(url, fields, publicKey, apiPassword);
  }

  @override
  Future<PaymentIntentApiResponse> paymentIntent(String paymentIntentId,
      String publicKey, String apiPassword, String baseUrl) {
    var url = '$baseUrl/payment-intent/api/v1/paymentIntent/$paymentIntentId';
    return genPaymentIntentResponse(
        url, paymentIntentId, publicKey, apiPassword);
  }

  @override
  Future<OrderApiResponse> orderDetail(String merchantPublicKey, String orderId,
      String publicKey, String apiPassword, String baseUrl) {
    var url = '$baseUrl/pgw/api/v1/order/$merchantPublicKey/$orderId';
    return genResponseGet(url, publicKey, apiPassword);
  }

  @override
  Future<PaymentNotificationApiResponse> paymentNotification(
      Map<String, Object?>? fields,
      String publicKey,
      String apiPassword,
      String baseUrl) {
    var url = '$baseUrl/pgw/api/v1/MeezaPaymentNotification';
    return genPaymentNotificaitonResponse(url, fields, publicKey, apiPassword);
  }

  Future<OrderApiResponse> genResponse(String url, Map<String, Object?>? fields,
      String publicKey, String apiPassword) async {
    genHeaders(publicKey, apiPassword);

    http.Response response = await http.post(url.toUri(),
        body: jsonEncode(fields), headers: headers);
    var body = response.body;

    var statusCode = response.statusCode;

    switch (statusCode) {
      case HttpStatus.ok:
        Map<String, dynamic> responseBody = json.decode(body);
        return OrderApiResponse.fromMap(responseBody);
      case HttpStatus.gatewayTimeout:
        throw PayException('Gateway timeout error');
      default:
        throw PayException(Strings.unKnownResponse);
    }
  }

  Future<RequestPayApiResponse> genRequestPayResponse(
      String url,
      Map<String, Object?>? fields,
      String publicKey,
      String apiPassword) async {
    genHeaders(publicKey, apiPassword);

    http.Response response = await http.post(url.toUri(),
        body: jsonEncode(fields), headers: headers);
    var body = response.body;

    var statusCode = response.statusCode;

    switch (statusCode) {
      case HttpStatus.ok:
        Map<String, dynamic> responseBody = json.decode(body);
        return RequestPayApiResponse.fromMap(responseBody);
      case HttpStatus.gatewayTimeout:
        throw PayException('Gateway timeout error');
      default:
        throw PayException(Strings.unKnownResponse);
    }
  }

  Future<PaymentIntentApiResponse> genPaymentIntentResponse(String url,
      String paymentIntentId, String publicKey, String apiPassword) async {
    genHeaders(publicKey, apiPassword);

    http.Response response = await http.get(url.toUri(), headers: headers);
    var body = response.body;

    var statusCode = response.statusCode;

    switch (statusCode) {
      case HttpStatus.ok:
        Map<String, dynamic> responseBody = json.decode(body);
        return PaymentIntentApiResponse.fromMap(responseBody);
      case HttpStatus.gatewayTimeout:
        throw PayException('Gateway timeout error');
      default:
        throw PayException(Strings.unKnownResponse);
    }
  }

  Future<OrderApiResponse> genResponseGet(
      String url, String publicKey, String apiPassword) async {
    genHeaders(publicKey, apiPassword);

    http.Response response = await http.get(url.toUri(), headers: headers);
    var body = response.body;

    var statusCode = response.statusCode;

    switch (statusCode) {
      case HttpStatus.ok:
        Map<String, dynamic> responseBody = json.decode(body);
        return OrderApiResponse.fromMap(responseBody);
      case HttpStatus.gatewayTimeout:
        throw PayException('Gateway timeout error');
      case HttpStatus.badRequest:
        Map<String, dynamic> responseBody = json.decode(body);
        return OrderApiResponse.fromMap(responseBody);
      default:
        throw PayException(Strings.unKnownResponse);
    }
  }

  Future<PaymentNotificationApiResponse> genPaymentNotificaitonResponse(
      String url,
      Map<String, Object?>? fields,
      String publicKey,
      String apiPassword) async {
    genHeaders(publicKey, apiPassword);

    http.Response response = await http.post(url.toUri(),
        body: jsonEncode(fields), headers: headers);
    var body = response.body;

    var statusCode = response.statusCode;

    switch (statusCode) {
      case HttpStatus.ok:
        if (body.isNotEmpty) {
          Map<String, dynamic> responseBody = json.decode(body);
          return PaymentNotificationApiResponse.fromJson(responseBody);
        } else {
          return PaymentNotificationApiResponse(status: 200);
        }
      case HttpStatus.gatewayTimeout:
        throw PayException('Gateway timeout error');
      default:
        throw PayException(Strings.unKnownResponse);
    }
  }
}
