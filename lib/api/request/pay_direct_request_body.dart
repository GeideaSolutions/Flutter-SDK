import 'package:geideapay/api/request/base/base_request_body.dart';
import 'package:geideapay/geideapay.dart';

class PayDirectRequestBody extends BaseRequestBody {
  final String? orderId;
  final String? threeDSecureId;
  final String? sessionId;
  final String? paymentOperation;
  final String? customerPhoneNumber;
  final String? customerPhoneCountryCode;
  final PaymentCard? paymentMethod;
  final String? returnUrl;
  final String? source;

  PayDirectRequestBody(
    this.sessionId,
    this.orderId,
    this.threeDSecureId,
    this.paymentMethod, {
    this.source = "MobileApp",
    this.paymentOperation,
    this.customerPhoneNumber,
    this.customerPhoneCountryCode,
    this.returnUrl,
  });

  @override
  Map<String, Object?> paramsMap() {
    // set values will override additional params provided
    Map<String, Object?> params = {};
    params[BaseRequestBody.fieldOrderId] = orderId;
    params[BaseRequestBody.fieldThreeDSecureId] = threeDSecureId;
    params[BaseRequestBody.fieldSessionId] = sessionId;
    params[BaseRequestBody.fieldPaymentOperation] = paymentOperation;
    params[BaseRequestBody.fieldCustomerPhoneNumber] = customerPhoneNumber;
    params[BaseRequestBody.fieldCustomerPhoneCountryCode] =
        customerPhoneCountryCode;
    params[BaseRequestBody.fieldPaymentMethod] = paymentMethod!.toMap();
    params[BaseRequestBody.fieldReturnUrl] = returnUrl;
    params[BaseRequestBody.fieldSource] = source;

    return params
      ..removeWhere(
          (key, value) => value == null || (value is String && value.isEmpty));
  }

  @override
  toString() {
    return 'PayDirectRequestBody{orderId: $orderId, threeDSecureId: $threeDSecureId, sessionId: $sessionId, paymentOperation: $paymentOperation, customerPhoneNumber: $customerPhoneNumber, customerPhoneCountryCode: $customerPhoneCountryCode, paymentMethod: $paymentMethod, returnUrl: $returnUrl, source: $source}';
  }
}
