import 'package:geideapay/api/request/base/base_request_body.dart';
import 'package:geideapay/models/deviceIdentification.dart';

class InitiateAuthenticationRequestBody extends BaseRequestBody {
  final String? sessionId;
  final String? merchantName;
  final String? callbackUrl;
  final bool? isSetPaymentMethodEnabled;
  final bool? isCreateCustomerEnabled;
  final String? paymentOperation;
  final bool? cardOnFile;
  final String? restrictPaymentMethods;
  final double? amount;
  final String? currency;
  final String? cardNumber;
  final String? source;
  final String? ReturnUrl;
  final DeviceIdentification? deviceIdentification;

  InitiateAuthenticationRequestBody(
    this.sessionId,
    this.cardNumber,
    this.ReturnUrl, {
    this.merchantName,
    this.callbackUrl,
    this.isSetPaymentMethodEnabled,
    this.isCreateCustomerEnabled,
    this.paymentOperation,
    this.cardOnFile,
    this.restrictPaymentMethods,
    this.amount,
    this.currency,
    this.source,
    this.deviceIdentification,
  });

  @override
  Map<String, Object?> paramsMap() {
    // set values will override additional params provided
    Map<String, Object?> params = {};
    params[BaseRequestBody.fieldSessionId] = sessionId;
    params[BaseRequestBody.fieldMerchantName] = merchantName;
    params[BaseRequestBody.fieldCallbackUrl] = callbackUrl;
    params[BaseRequestBody.fieldIsSetPaymentMethodEnabled] =
        isSetPaymentMethodEnabled;
    params[BaseRequestBody.fieldIsCreateCustomerEnabled] =
        isCreateCustomerEnabled;
    params[BaseRequestBody.fieldPaymentOperation] = paymentOperation;
    params[BaseRequestBody.fieldCardOnFile] = cardOnFile;
    params[BaseRequestBody.fieldRestrictPaymentMethods] =
        restrictPaymentMethods;
    params[BaseRequestBody.fieldAmount] = amount;
    params[BaseRequestBody.fieldCurrency] = currency;
    params[BaseRequestBody.fieldCardNumber] = cardNumber;
    params[BaseRequestBody.fieldSource] = source;
    params[BaseRequestBody.fieldReturnUrl2] = ReturnUrl;

    if (deviceIdentification != null) {
      params[BaseRequestBody.fieldDeviceIdentification] =
          deviceIdentification!.toMap();
    }

    return params
      ..removeWhere(
          (key, value) => value == null || (value is String && value.isEmpty));
  }

  @override
  toString() {
    return 'InitiateAuthenticationRequestBody{sessionId: $sessionId, merchantName: $merchantName, callbackUrl: $callbackUrl, isSetPaymentMethodEnabled: $isSetPaymentMethodEnabled, isCreateCustomerEnabled: $isCreateCustomerEnabled, paymentOperation: $paymentOperation, cardOnFile: $cardOnFile, restrictPaymentMethods: $restrictPaymentMethods, amount: $amount, currency: $currency, cardNumber: $cardNumber, source: $source, ReturnUrl: $ReturnUrl, deviceIdentification: $deviceIdentification}';
  }
}
