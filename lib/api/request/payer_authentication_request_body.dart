import 'dart:async';

import 'package:geideapay/api/request/base/base_request_body.dart';
import 'package:geideapay/common/card_utils.dart';
import 'package:geideapay/geideapay.dart';
import 'package:geideapay/models/address.dart';

class PayerAuthenticationRequestBody extends BaseRequestBody {

  final String _amount;
  final String? _currency;
  final PaymentCard? _paymentMethod;
  final String _orderId;

  
  final bool? cardOnFile;
  final String? merchantReferenceID;
  final String? paymentOperation;
  final String? callbackUrl;
  final Address? billing;
  final Address? shipping;
  final String? customerEmail;
  final String? returnUrl;
  final String? paymentIntentId;

  PayerAuthenticationRequestBody(
      this._amount, this._currency, this._paymentMethod, this._orderId,
      {this.cardOnFile, this.merchantReferenceID, this.paymentOperation,
        this.callbackUrl, this.billing, this.shipping, this.customerEmail,
        this.returnUrl, this.paymentIntentId});

  @override
  Map<String, Object?> paramsMap() {
    // set values will override additional params provided
    Map<String, Object?> params = {};
    params[BaseRequestBody.fieldOrderId] = _orderId;
    params[BaseRequestBody.fieldAmount] = _amount;
    params[BaseRequestBody.fieldCurrency] = _currency;
    params[BaseRequestBody.fieldCallbackUrl] = callbackUrl;
    params[BaseRequestBody.fieldCardOnFile] = cardOnFile;
    params[BaseRequestBody.fieldBrowser] = "Flutetr SDK";

    params[BaseRequestBody.fieldPaymentMethod] = _paymentMethod!.toMap();

    params[BaseRequestBody.fieldReturnUrl] = returnUrl;
    params[BaseRequestBody.fieldCardOnFile] = cardOnFile;
    params[BaseRequestBody.fieldMerchantReferenceID] = merchantReferenceID;
    params[BaseRequestBody.fieldPaymentOperation] = paymentOperation;

    if (billing != null) {
      params[BaseRequestBody.fieldBilling] = billing!.toMap();
    }

    if (shipping != null) {
      params[BaseRequestBody.fieldShipping] = shipping!.toMap();
    }

    params[BaseRequestBody.fieldCustomerEmail] = customerEmail;
    params[BaseRequestBody.fieldPaymentIntentId] = paymentIntentId;
    

    return params..removeWhere((key, value) => value == null || (value is String && value.isEmpty));
  }
}
