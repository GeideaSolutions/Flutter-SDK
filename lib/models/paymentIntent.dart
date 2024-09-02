import 'package:geideapay/models/order.dart';

class PaymentIntent {
  String? id;
  String? paymentIntentId;
  String? parentPaymentIntentId;
  String? number;
  String? urlSlug;
  String? type;
  double? amount;
  String? currency;
  String? merchantId;
  String? merchantPublicKey;
  String? expiryDate;
  String? activationDate;
  String? status;
  String? customerId;
  String? eInvoiceUploadId;
  String? staticPaylinkId;
  String? subscriptionId;
  String? subscriptionOccurrenceId;
  List<Order>? orders;
  bool? isPending;
  String? createdDate;
  String? createdBy;
  String? updatedDate;
  String? updatedBy;

  PaymentIntent({
    this.id,
    this.paymentIntentId,
    this.parentPaymentIntentId,
    this.number,
    this.urlSlug,
    this.type,
    this.amount,
    this.currency,
    this.merchantId,
    this.merchantPublicKey,
    this.expiryDate,
    this.activationDate,
    this.status,
    this.customerId,
    this.eInvoiceUploadId,
    this.staticPaylinkId,
    this.subscriptionId,
    this.subscriptionOccurrenceId,
    this.orders,
    this.isPending,
    this.createdDate,
    this.createdBy,
    this.updatedDate,
    this.updatedBy,
  });

  PaymentIntent.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    paymentIntentId = json['paymentIntentId'];
    parentPaymentIntentId = json['parentPaymentIntentId'];
    number = json['number'];
    urlSlug = json['urlSlug'];
    type = json['type'];
    amount = json['amount'];
    currency = json['currency'];
    merchantId = json['merchantId'];
    merchantPublicKey = json['merchantPublicKey'];
    expiryDate = json['expiryDate'];
    activationDate = json['activationDate'];
    status = json['status'];
    customerId = json['customerId'];
    eInvoiceUploadId = json['eInvoiceUploadId'];
    staticPaylinkId = json['staticPaylinkId'];
    subscriptionId = json['subscriptionId'];
    subscriptionOccurrenceId = json['subscriptionOccurrenceId'];
    if (json['orders'] != null) {
      orders = <Order>[];
      json['orders'].forEach((v) {
        orders!.add(Order.fromMap(v));
      });
    }
    isPending = json['isPending'];
    createdDate = json['createdDate'];
    createdBy = json['createdBy'];
    updatedDate = json['updatedDate'];
    updatedBy = json['updatedBy'];
  }

  @override
  String toString() {
    return 'PaymentIntent${toMap()}';
  }

  Map<String, dynamic>? toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['paymentIntentId'] = paymentIntentId;
    data['parentPaymentIntentId'] = parentPaymentIntentId;
    data['number'] = number;
    data['urlSlug'] = urlSlug;
    data['type'] = type;
    data['amount'] = amount;
    data['currency'] = currency;
    data['merchantId'] = merchantId;
    data['merchantPublicKey'] = merchantPublicKey;
    data['expiryDate'] = expiryDate;
    data['activationDate'] = activationDate;
    data['status'] = status;
    data['customerId'] = customerId;
    data['eInvoiceUploadId'] = eInvoiceUploadId;
    data['staticPaylinkId'] = staticPaylinkId;
    data['subscriptionId'] = subscriptionId;
    data['subscriptionOccurrenceId'] = subscriptionOccurrenceId;
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toMap()).toList();
    }
    data['isPending'] = isPending;
    data['createdDate'] = createdDate;
    data['createdBy'] = createdBy;
    data['updatedDate'] = updatedDate;
    data['updatedBy'] = updatedBy;
    return data;
  }
}
