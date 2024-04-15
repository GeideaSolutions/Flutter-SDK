import 'package:geideapay/api/request/base/base_request_body.dart';
import 'package:geideapay/geideapay.dart';
import 'package:geideapay/models/deviceIdentification.dart';

class PayerAuthenticationRequestBody extends BaseRequestBody {
  final String? sessionId;
  final String? orderId;
  final String? callbackUrl;
  final String? ReturnUrl;
  final bool? cardOnFile;
  final String? paymentOperation;
  final PaymentCard? paymentMethod;
  final DeviceIdentification? deviceIdentification;
  final String? merchantName;
  final bool? restrictPaymentMethods;
  final bool? isCreateCustomerEnabled;
  final bool? isSetPaymentMethodEnabled;
  final bool? javaEnabled;
  final bool? javaScriptEnabled;
  final String? browser;
  final int? timeZone;
  final String? source;

  PayerAuthenticationRequestBody(
    this.sessionId,
    this.orderId,
    this.paymentMethod,
    this.deviceIdentification,
    this.timeZone, {
    this.source = "MobileApp",
    this.ReturnUrl,
    this.callbackUrl,
    this.cardOnFile,
    this.paymentOperation,
    this.merchantName,
    this.restrictPaymentMethods,
    this.isSetPaymentMethodEnabled,
    this.isCreateCustomerEnabled,
    this.javaEnabled,
    this.javaScriptEnabled,
    this.browser,
  });

  @override
  Map<String, Object?> paramsMap() {
    // set values will override additional params provided
    Map<String, Object?> params = {};
    params[BaseRequestBody.fieldSessionId] = sessionId;
    params[BaseRequestBody.fieldOrderId] = orderId;
    params[BaseRequestBody.fieldCallbackUrl] = callbackUrl;
    params[BaseRequestBody.fieldCardOnFile] = cardOnFile;
    params[BaseRequestBody.fieldPaymentOperation] = paymentOperation;
    params[BaseRequestBody.fieldPaymentMethod] = paymentMethod?.toMap();
    params[BaseRequestBody.fieldDeviceIdentification] =
        deviceIdentification?.toMap();
    params[BaseRequestBody.fieldMerchantName] = merchantName;
    params[BaseRequestBody.fieldRestrictPaymentMethods] =
        restrictPaymentMethods;
    params[BaseRequestBody.fieldIsSetPaymentMethodEnabled] =
        isSetPaymentMethodEnabled;
    params[BaseRequestBody.fieldIsCreateCustomerEnabled] =
        isCreateCustomerEnabled;
    params[BaseRequestBody.fieldJavaEnabled] = javaEnabled;
    params[BaseRequestBody.fieldJavaScriptEnabled] = javaScriptEnabled;
    params[BaseRequestBody.fieldBrowser] = browser;
    params[BaseRequestBody.fieldTimeZone] = timeZone;
    params[BaseRequestBody.fieldSource] = source;

    return params
      ..removeWhere(
          (key, value) => value == null || (value is String && value.isEmpty));
  }

  @override
  toString() {
    return 'PayerAuthenticationRequestBody{sessionId: $sessionId, orderId: $orderId, callbackUrl: $callbackUrl, cardOnFile: $cardOnFile, paymentOperation: $paymentOperation, paymentMethod: $paymentMethod, deviceIdentification: $deviceIdentification, merchantName: $merchantName, restrictPaymentMethods: $restrictPaymentMethods, isSetPaymentMethodEnabled: $isSetPaymentMethodEnabled, isCreateCustomerEnabled: $isCreateCustomerEnabled, javaEnabled: $javaEnabled, javaScriptEnabled: $javaScriptEnabled, browser: $browser, timeZone: $timeZone, source: $source}';
  }
}
