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
  final String? callbackUrl;
  final String? returnUrl;
  final String? merchantReferenceID;
  bool? cardOnFile;
  final String? paymentOperation;
  final Address? billing;
  final Address? shipping;
  final String? customerEmail;
  final String? paymentIntentId;

  Color? backgroundColor;
  Color? cardColor;
  Color? textColor;
  Color? payButtonColor;
  Color? cancelButtonColor;

  CheckoutOptions(this.amount, this.currency,
      {this.callbackUrl,
      this.returnUrl,
      this.cardOnFile,
      this.merchantReferenceID,
      this.paymentOperation,
      this.billing,
      this.shipping,
      this.customerEmail,
      this.paymentIntentId,
      this.backgroundColor,
      this.cardColor,
      this.textColor,
      this.payButtonColor,
      this.cancelButtonColor})
  {
    backgroundColor ??= const Color(0xff2c2222);
    cardColor ??= const Color(0xffff4d00);
    textColor ??= const Color(0xffffffff);
    payButtonColor ??= const Color(0xffff4d00);
    cancelButtonColor ??= const Color(0xff878787);
  }
}
