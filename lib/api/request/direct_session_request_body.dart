import 'package:geideapay/api/request/base/base_request_body.dart';
import 'package:geideapay/models/appearance.dart';

class DirectSessionRequestBody extends BaseRequestBody {
  // Mandatory fields
  final double _amount;
  final String _currency;
  final String timestamp;
  final String merchantReferenceID;
  final String signature;

  // Optional fields
  final String? callbackUrl;
  final String? language;
  final bool? cardOnFile;
  final String? paymentIntentId;
  final String? paymentOperation;
  final Appearance? appearance;

  DirectSessionRequestBody(
    this._amount,
    this._currency,
    this.timestamp,
    this.merchantReferenceID,
    this.signature, {
    this.callbackUrl,
    this.language,
    this.cardOnFile = false,
    this.paymentIntentId,
    this.paymentOperation,
    this.appearance,
  });

  @override
  Map<String, Object?> paramsMap() {
    // set values will override additional params provided
    Map<String, Object?> params = {};
    params[BaseRequestBody.fieldAmount] = _amount;
    params[BaseRequestBody.fieldCurrency] = _currency;
    params[BaseRequestBody.fieldTimestamp] = timestamp;
    params[BaseRequestBody.fieldMerchantReferenceID] = merchantReferenceID;
    params[BaseRequestBody.fieldSignature] = signature;

    params[BaseRequestBody.fieldCallbackUrl] = callbackUrl;
    params[BaseRequestBody.fieldLanguage] = language;
    params[BaseRequestBody.fieldCardOnFile] = cardOnFile;
    params[BaseRequestBody.fieldPaymentIntentId] = paymentIntentId;
    params[BaseRequestBody.fieldPaymentOperation] = paymentOperation;

    if (appearance != null) {
      params[BaseRequestBody.fieldAppearance] = appearance!.toMap();
    }

    return params
      ..removeWhere(
          (key, value) => value == null || (value is String && value.isEmpty));
  }

  @override
  toString() {
    return 'DirectSessionRequestBody{_amount: $_amount, _currency: $_currency, timestamp: $timestamp, merchantReferenceID: $merchantReferenceID, signature: $signature, callbackUrl: $callbackUrl, language: $language, cardOnFile: $cardOnFile, paymentIntentId: $paymentIntentId, paymentOperation: $paymentOperation, appearance: $appearance}';
  }
}
