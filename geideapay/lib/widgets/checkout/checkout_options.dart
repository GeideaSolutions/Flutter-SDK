import 'dart:async';
import 'dart:ui';
import 'dart:ui';

import 'package:geideapay/api/request/base/base_request_body.dart';
import 'package:geideapay/api/request/initiate_authentication_request_body.dart';
import 'package:geideapay/api/request/pay_direct_request_body.dart';
import 'package:geideapay/api/request/payer_authentication_request_body.dart';
import 'package:geideapay/common/card_utils.dart';
import 'package:geideapay/geideapay.dart';
import 'package:geideapay/models/address.dart';

class CheckoutOptions {
  final String amount;
  final String? currency;
  String? callbackUrl;
  String? returnUrl;
  final String? merchantReferenceID;
  bool? cardOnFile, showBilling, showShipping, showSaveCard;
  String? paymentOperation;
  Address? billingAddress;
  Address? shippingAddress;
  final String? customerEmail;
  final String? paymentIntentId;
  String? lang;
  Color? backgroundColor;
  Color? cardColor;
  Color? textColor;
  Color? payButtonColor;
  Color? cancelButtonColor;

  CheckoutOptions(this.amount, this.currency,
      {
        this.callbackUrl,
        this.cardOnFile,
        this.merchantReferenceID,
        this.paymentOperation,
        this.billingAddress,
        this.shippingAddress,
        this.customerEmail,
        this.paymentIntentId,
        this.backgroundColor,
        this.cardColor,
        this.textColor,
        this.payButtonColor,
        this.cancelButtonColor,
        this.lang,
      this.showBilling,
      this.showShipping,
      this.showSaveCard})
  {
    if(paymentOperation != null && paymentOperation!.startsWith("Default"))
      {
        paymentOperation = null;
      }
    returnUrl = "https://returnurl.com";
    backgroundColor ??= const Color(0xff2c2222);
    cardColor ??= const Color(0xffff4d00);
    textColor ??= const Color(0xffffffff);
    payButtonColor ??= const Color(0xffff4d00);
    cancelButtonColor ??= const Color(0xff878787);
    lang ??= "EN";
    showBilling ??= false;
    showShipping ??= false;
    showSaveCard ??= false;
    if(this.billingAddress != null && (this.billingAddress!).isempty())
      this.billingAddress = null;
    if(this.shippingAddress != null && (this.shippingAddress!).isempty())
      this.shippingAddress = null;
  }
}
