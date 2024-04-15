import 'package:geideapay/models/address.dart';
import 'package:geideapay/models/paymentIntent.dart';
import 'package:geideapay/models/paymentMethod.dart';
import 'package:geideapay/models/statementDescriptor.dart';
import 'package:geideapay/models/transaction.dart';

class Order {

  double? amount, tipAmount, convenienceFeeAmount, totalAmount,
      totalAuthorizedAmount, totalCapturedAmount, totalRefundedAmount;

  String? orderId, currency, language, detailedStatus, status, threeDSecureId,
      merchantId, merchantPublicKey, parentOrderId, merchantReferenceId,
      callbackUrl,
      customerEmail, returnUrl, tokenId, initiatedBy, agreementId,
      agreementType, paymentOperation, custom,
      paymentMethods, platform, description, customerReferenceId, customerId,
      recurrence, createdDate, createdBy, updatedDate, updatedBy;

  Address? billingAddress;
  Address? shippingAddress;

  bool? cardOnFile, setDefaultPaymentMethod, restrictPaymentMethods,
      createCustomer, isTokenPayment;

  PaymentIntent? paymentIntent;

  PaymentMethod? paymentMethod;

  StatementDescriptor? statementDescriptor;

  List<Transaction>? transactions;

  Order(
      {this.amount, this.tipAmount, this.convenienceFeeAmount, this.totalAmount, this.totalAuthorizedAmount, this.totalCapturedAmount, this.totalRefundedAmount, this.orderId, this.currency, this.language, this.detailedStatus, this.status, this.threeDSecureId, this.merchantId, this.merchantPublicKey, this.parentOrderId, this.merchantReferenceId, this.callbackUrl, this.customerEmail, this.returnUrl, this.tokenId, this.initiatedBy, this.agreementId, this.agreementType, this.paymentOperation, this.custom, this.paymentMethods, this.platform, this.description, this.customerReferenceId, this.customerId, this.recurrence, this.createdDate, this.createdBy, this.updatedDate, this.updatedBy, this.billingAddress, this.shippingAddress, this.cardOnFile, this.setDefaultPaymentMethod, this.restrictPaymentMethods, this.createCustomer, this.isTokenPayment, this.paymentIntent, this.paymentMethod, this.statementDescriptor, this.transactions});

  Order.fromMap(Map<String, dynamic> map) {
    amount =
    map['amount'] == null ? null : double.parse(map['amount'].toString());
    tipAmount =
    map['tipAmount'] == null ? null : double.parse(map['tipAmount'].toString());
    convenienceFeeAmount =
    map['convenienceFeeAmount'] == null ? null : double.parse(
        map['convenienceFeeAmount'].toString());
    totalAmount = map['totalAmount'] == null ? null : double.parse(
        map['totalAmount'].toString());
    totalAuthorizedAmount =
    map['totalAuthorizedAmount'] == null ? null : double.parse(
        map['totalAuthorizedAmount'].toString());
    totalCapturedAmount =
    map['totalCapturedAmount'] == null ? null : double.parse(
        map['totalCapturedAmount'].toString());
    totalRefundedAmount =
    map['totalRefundedAmount'] == null ? null : double.parse(
        map['totalRefundedAmount'].toString());
    orderId = map['orderId'];
    currency = map['currency'];
    language = map['language'];
    detailedStatus = map['detailedStatus'];
    status = map['status'];
    threeDSecureId = map['threeDSecureId'];
    merchantId = map['merchantId'];
    merchantPublicKey = map['merchantPublicKey'];
    parentOrderId = map['parentOrderId'];
    merchantReferenceId = map['merchantReferenceId'];
    callbackUrl = map['callbackUrl'];
    customerEmail = map['customerEmail'];
    returnUrl = map['returnUrl'];
    tokenId = map['tokenId'];
    initiatedBy = map['initiatedBy'];
    agreementId = map['agreementId'];
    agreementType = map['agreementType'];
    paymentOperation = map['paymentOperation'];
    custom = map['custom'];
    paymentMethods = map['paymentMethods'];
    platform = map['platform'];
    description = map['description'];
    customerReferenceId = map['customerReferenceId'];
    customerId = map['customerId'];
    recurrence = map['recurrence'];
    createdDate = map['createdDate'];
    createdBy = map['createdBy'];
    updatedDate = map['updatedDate'];
    updatedBy = map['updatedBy'];
    billingAddress = map['billingAddress'] != null
        ? Address.fromMap(map['billingAddress'])
        : null;
    shippingAddress = map['shippingAddress'] != null
        ? Address.fromMap(map['shippingAddress'])
        : null;
    cardOnFile = map['cardOnFile'];
    setDefaultPaymentMethod = map['setDefaultPaymentMethod'];
    restrictPaymentMethods = map['restrictPaymentMethods'];
    createCustomer = map['createCustomer'];
    isTokenPayment = map['isTokenPayment'];
    paymentIntent = map['paymentIntent'] == null ? null : PaymentIntent.fromMap(
        map['paymentIntent']);
    paymentMethod = map['paymentMethod'] == null ? null : PaymentMethod.fromMap(
        map['paymentMethod']);
    statementDescriptor =
    map['statementDescriptor'] == null ? null : StatementDescriptor.fromMap(
        map['statementDescriptor']);
    transactions = List<Transaction>.from(
        map['transactions'].map((x) => Transaction.fromMap(x)));
  }

  @override
  String toString() {
    return 'Order{amount: $amount, tipAmount: $tipAmount, convenienceFeeAmount: $convenienceFeeAmount, totalAmount: $totalAmount, totalAuthorizedAmount: $totalAuthorizedAmount, totalCapturedAmount: $totalCapturedAmount, totalRefundedAmount: $totalRefundedAmount, orderId: $orderId, currency: $currency, language: $language, detailedStatus: $detailedStatus, status: $status, threeDSecureId: $threeDSecureId, merchantId: $merchantId, merchantPublicKey: $merchantPublicKey, parentOrderId: $parentOrderId, merchantReferenceId: $merchantReferenceId, callbackUrl: $callbackUrl, customerEmail: $customerEmail, returnUrl: $returnUrl, tokenId: $tokenId, initiatedBy: $initiatedBy, agreementId: $agreementId, agreementType: $agreementType, paymentOperation: $paymentOperation, custom: $custom, paymentMethods: $paymentMethods, platform: $platform, description: $description, customerReferenceId: $customerReferenceId, customerId: $customerId, recurrence: $recurrence, createdDate: $createdDate, createdBy: $createdBy, updatedDate: $updatedDate, updatedBy: $updatedBy, billingAddress: $billingAddress, shippingAddress: $shippingAddress, cardOnFile: $cardOnFile, setDefaultPaymentMethod: $setDefaultPaymentMethod, restrictPaymentMethods: $restrictPaymentMethods, createCustomer: $createCustomer, isTokenPayment: $isTokenPayment, paymentIntent: $paymentIntent, paymentMethod: $paymentMethod, statementDescriptor: $statementDescriptor, transactions: $transactions}';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "amount": amount,
      "tipAmount": tipAmount,
      "convenienceFeeAmount": convenienceFeeAmount,
      "totalAmount": totalAmount,
      "totalAuthorizedAmount": totalAuthorizedAmount,
      "totalCapturedAmount": totalCapturedAmount,
      "totalRefundedAmount": totalRefundedAmount,
      "orderId": orderId,
      "currency": currency,
      "language": language,
      "detailedStatus": detailedStatus,
      "status": status,
      "threeDSecureId": threeDSecureId,
      "merchantId": merchantId,
      "merchantPublicKey": merchantPublicKey,
      "parentOrderId": parentOrderId,
      "merchantReferenceId": merchantReferenceId,
      "callbackUrl": callbackUrl,
      "customerEmail": customerEmail,
      "returnUrl": returnUrl,
      "tokenId": tokenId,
      "initiatedBy": initiatedBy,
      "agreementId": agreementId,
      "agreementType": agreementType,
      "paymentOperation": paymentOperation,
      "custom": custom,
      "paymentMethods": paymentMethods,
      "platform": platform,
      "description": description,
      "customerReferenceId": customerReferenceId,
      "customerId": customerId,
      "recurrence": recurrence,
      "createdDate": createdDate,
      "createdBy": createdBy,
      "updatedDate": updatedDate,
      "updatedBy": updatedBy,
      "billingAddress": billingAddress?.toMap(),
      "shippingAddress": shippingAddress?.toMap(),
      "cardOnFile": cardOnFile,
      "setDefaultPaymentMethod": setDefaultPaymentMethod,
      "restrictPaymentMethods": restrictPaymentMethods,
      "createCustomer": createCustomer,
      "isTokenPayment": isTokenPayment,
      "paymentIntent": paymentIntent?.toMap(),
      "paymentMethod": paymentMethod?.toMap(),
      "statementDescriptor": statementDescriptor?.toMap(),
      "transactions": (transactions != null) ? transactions?.map((v) =>
          v.toMap()).toList() : null
    };
  }
}
