import 'dart:async';

import 'package:geideapay/api/request/base/base_request_body.dart';
import 'package:geideapay/common/card_utils.dart';
import 'package:geideapay/geideapay.dart';

class PayDirectRequestBody extends BaseRequestBody {

  final String _threeDSecureId;
  final String _orderId;
  final String _amount;
  final String? _currency;
  final PaymentCard? _paymentMethod;

  final String? paymentOperation;
  final String? callbackUrl;
  final String? paymentIntentId;
  
  PayDirectRequestBody(this._threeDSecureId,this._orderId,
      this._amount, this._currency, this._paymentMethod,
      {this.paymentOperation, this.callbackUrl, this.paymentIntentId});

  @override
  Map<String, Object?> paramsMap() {
    // set values will override additional params provided
    Map<String, Object?> params = {};
    params[BaseRequestBody.fieldOrderId] = _orderId;
    params[BaseRequestBody.fieldThreeDSecureId] = _threeDSecureId;
    params[BaseRequestBody.fieldAmount] = _amount;
    params[BaseRequestBody.fieldCurrency] = _currency;
    
    params[BaseRequestBody.fieldBrowser] = "Flutetr SDK";

    params[BaseRequestBody.fieldPaymentMethod] = _paymentMethod!.toMap();
    
    params[BaseRequestBody.fieldPaymentOperation] = paymentOperation;
    params[BaseRequestBody.fieldCallbackUrl] = callbackUrl;
    params[BaseRequestBody.fieldPaymentIntentId] = paymentIntentId;
    

    return params..removeWhere((key, value) => value == null || (value is String && value.isEmpty));
  }
}
