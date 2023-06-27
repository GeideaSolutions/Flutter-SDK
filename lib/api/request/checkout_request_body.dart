import 'dart:async';

import 'package:geideapay/api/request/base/base_request_body.dart';
import 'package:geideapay/api/request/initiate_authentication_request_body.dart';
import 'package:geideapay/api/request/pay_direct_request_body.dart';
import 'package:geideapay/api/request/payer_authentication_request_body.dart';
import 'package:geideapay/common/card_utils.dart';
import 'package:geideapay/geideapay.dart';
import 'package:geideapay/models/address.dart';
import 'package:geideapay/widgets/checkout/checkout_options.dart';

class CheckoutRequestBody extends BaseRequestBody {

  CheckoutOptions checkoutOptions;

  PaymentCard? _paymentCard;
  late String amount;
  String? currency;

  String? callbackUrl;
  String? returnUrl;
  String? merchantReferenceID;
  bool? cardOnFile;
  String? paymentOperation;
  Address? billingAddress;
  Address? shippingAddress;
  String? customerEmail;
  String? paymentIntentId;

  late InitiateAuthenticationRequestBody initiateAuthenticationRequestBody;
  late PayerAuthenticationRequestBody payerAuthenticationRequestBody;
  late PayDirectRequestBody payDirectRequestBody;

  String? orderId;
  String? threeDSecureId;

  CheckoutRequestBody(this.checkoutOptions, this._paymentCard) {
    amount = checkoutOptions.amount.toString();
    currency = checkoutOptions.currency;
    callbackUrl = checkoutOptions.callbackUrl;
    returnUrl = checkoutOptions.returnUrl;
    merchantReferenceID = checkoutOptions.merchantReferenceID;
    cardOnFile = checkoutOptions.cardOnFile;
    paymentOperation = checkoutOptions.paymentOperation;
    billingAddress = checkoutOptions.billingAddress;
    shippingAddress = checkoutOptions.shippingAddress;
    customerEmail = checkoutOptions.customerEmail;
    paymentIntentId = checkoutOptions.paymentIntentId;

    initiateAuthenticationRequestBody = InitiateAuthenticationRequestBody(
       amount, currency, _paymentCard!.number,
        callbackUrl: callbackUrl,
        cardOnFile: cardOnFile,
        merchantReferenceID: merchantReferenceID,
        paymentOperation: paymentOperation,
        billingAddress: billingAddress,
        shippingAddress: shippingAddress,
        customerEmail: customerEmail,
        paymentIntentId: paymentIntentId);
  }

  void updatePayerAuthenticationRequestBody(String? orderId) {
    this.orderId = orderId;
    payerAuthenticationRequestBody = PayerAuthenticationRequestBody(
        amount, currency, _paymentCard, this.orderId!,
        cardOnFile: cardOnFile,
        merchantReferenceID: merchantReferenceID,
        paymentOperation: paymentOperation,
        callbackUrl: callbackUrl,
        billingAddress: billingAddress,
        shippingAddress: shippingAddress,
        customerEmail: customerEmail,
        paymentIntentId: paymentIntentId);
  }

  void updatePayDirectRequestBody(String? threeDSecureId) {
    this.threeDSecureId = threeDSecureId;
    payDirectRequestBody = PayDirectRequestBody(
        this.threeDSecureId!, orderId!, amount, currency, _paymentCard,
        paymentOperation: paymentOperation,
        callbackUrl: callbackUrl,
        paymentIntentId: paymentIntentId);
  }

  Map<String, Object?> paramsInitiateAuthenticationMap() {
    return initiateAuthenticationRequestBody.paramsMap();
  }

  Map<String, Object?> paramsPayerAuthenticationMap() {
    return payerAuthenticationRequestBody.paramsMap();
  }

  @override
  Map<String, Object?> paramsMap() {
    // set values will override additional params provided
    Map<String, Object?> params = {};
    params[BaseRequestBody.fieldAmount] = amount;
    params[BaseRequestBody.fieldCurrency] = currency;
    //params[BaseRequestBody.fieldCardNumber] = _cardNumber;
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
    return params
      ..removeWhere(
          (key, value) => value == null || (value is String && value.isEmpty));
  }

  toString() {
    return 'CheckoutRequestBody{amount: $amount, currency: $currency, callbackUrl: $callbackUrl, returnUrl: $returnUrl, merchantReferenceID: $merchantReferenceID, cardOnFile: $cardOnFile, paymentOperation: $paymentOperation, billingAddress: $billingAddress, shippingAddress: $shippingAddress, customerEmail: $customerEmail, paymentIntentId: $paymentIntentId}';
  }
}
