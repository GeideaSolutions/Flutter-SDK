import 'dart:ui';
import 'package:geideapay/models/address.dart';

class CheckoutOptions {
  final double amount;
  final String? currency;
  String? callbackUrl;
  String? returnUrl;
  final String? merchantReferenceID;
  bool? cardOnFile, showAddress, showSaveCard, showEmail;
  String? paymentOperation;
  Address? billingAddress;
  Address? shippingAddress;
  String? customerEmail;
  final String? paymentIntentId;
  String? lang;
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
        this.showAddress,
        this.showSaveCard,
        this.showEmail}) {
    if (paymentOperation != null && paymentOperation!.startsWith("Default")) {
      paymentOperation = null;
    }
    backgroundColor ??= const Color(0xff2c2222);
    cardColor ??= const Color(0xffff4d00);
    textColor ??= const Color(0xffffffff);
    payButtonColor ??= const Color(0xffff4d00);
    cancelButtonColor ??= const Color(0xff878787);
    lang ??= "en";
    showAddress ??= false;
    showSaveCard ??= false;
    showEmail ??= false;
    if (billingAddress != null && billingAddress!.isempty()) {
      billingAddress = null;
    }
    if (shippingAddress != null && shippingAddress!.isempty()) {
      shippingAddress = null;
    }
  }
}
