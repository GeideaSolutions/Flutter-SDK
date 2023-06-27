import 'dart:async';

import 'package:geideapay/api/request/base/base_request_body.dart';
import 'package:geideapay/common/card_utils.dart';
import 'package:geideapay/models/address.dart';

class InitiateAuthenticationRequestBody extends BaseRequestBody {

  final String _amount;
  final String? _currency;
  final String? _cardNumber;

  final String? callbackUrl;
  String? returnUrl;
  final String? merchantReferenceID;
  final bool? cardOnFile;
  final String? paymentOperation;
  final Address? billingAddress;
  final Address? shippingAddress;
  final String? customerEmail;
  final String? paymentIntentId;

  InitiateAuthenticationRequestBody(this._amount, this._currency,
      this._cardNumber, {this.callbackUrl,
      this.cardOnFile, this.merchantReferenceID, this.paymentOperation,
        this.billingAddress, this.shippingAddress, this.customerEmail, this.paymentIntentId})
  {
    returnUrl = "https://returnurl.com";
  }

  @override
  Map<String, Object?> paramsMap() {
    // set values will override additional params provided
    Map<String, Object?> params = {};
    params[BaseRequestBody.fieldAmount] = _amount;
    params[BaseRequestBody.fieldCurrency] = _currency;
    params[BaseRequestBody.fieldCardNumber] = _cardNumber;
    params[BaseRequestBody.fieldCallbackUrl] = callbackUrl;
    params[BaseRequestBody.fieldReturnUrl] = returnUrl;
    params[BaseRequestBody.fieldCardOnFile] = cardOnFile;
    params[BaseRequestBody.fieldMerchantReferenceID] = merchantReferenceID;
    params[BaseRequestBody.fieldPaymentOperation] = paymentOperation;

    if (billingAddress != null) {
      params[BaseRequestBody.fieldBilling] = billingAddress!.toMap();
    }

    if (shippingAddress != null) {
      params[BaseRequestBody.fieldShipping] = shippingAddress!.toMap();
    }
    
    params[BaseRequestBody.fieldCustomerEmail] = customerEmail;
    params[BaseRequestBody.fieldPaymentIntentId] = paymentIntentId;
    return params..removeWhere((key, value) => value == null || (value is String && value.isEmpty));
  }

  toString() {
    return 'InitiateAuthenticationRequestBody{_amount: $_amount, _currency: $_currency, _cardNumber: $_cardNumber, callbackUrl: $callbackUrl, returnUrl: $returnUrl, cardOnFile: $cardOnFile, merchantReferenceID: $merchantReferenceID, paymentOperation: $paymentOperation, billingAddress: $billingAddress, shippingAddress: $shippingAddress, customerEmail: $customerEmail, paymentIntentId: $paymentIntentId}';
  }
}
