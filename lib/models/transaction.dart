import 'package:geideapay/models/authenticationDetails.dart';
import 'package:geideapay/models/codes.dart';
import 'package:geideapay/models/paymentMethod.dart';

class Transaction {


  double? amount;
  bool? sameBank;
  String? transactionId, type, status, currency, source, authorizationCode, rrn,
      postilionDetails, terminalDetails, meezaDetails, bnplDetails,
      correlationId, createdDate, createdBy, updatedDate, updatedBy;
  PaymentMethod? paymentMethod;
  Codes? codes;
  AuthenticationDetails? authenticationDetails;


  Transaction(
      {this.transactionId, this.type, this.status, this.amount, this.currency, this.source, this.authorizationCode, this.rrn, this.sameBank, this.postilionDetails, this.terminalDetails, this.meezaDetails, this.bnplDetails, this.correlationId, this.createdDate, this.createdBy, this.updatedDate, this.updatedBy, this.paymentMethod, this.codes, this.authenticationDetails});

  Transaction.fromMap(Map<String, dynamic> map) {
    transactionId = map['transactionId'];
    type = map['type'];
    status = map['status'];
    amount =
    map['amount'] == null ? null : double.parse(map['amount'].toString());
    currency = map['currency'];
    source = map['source'];
    authorizationCode = map['authorizationCode'];
    rrn = map['rrn'];
    sameBank = map['sameBank'];
    postilionDetails = map['postilionDetails'];
    terminalDetails = map['terminalDetails'];
    meezaDetails = map['meezaDetails'];
    bnplDetails = map['bnplDetails'];
    correlationId = map['correlationId'];
    createdDate = map['createdDate'];
    createdBy = map['createdBy'];
    updatedDate = map['updatedDate'];
    updatedBy = map['updatedBy'];
    paymentMethod = map['paymentMethod'] == null ? null : PaymentMethod.fromMap(
        map['paymentMethod']);
    codes = map['codes'] == null ? null : Codes.fromMap(map['codes']);
    authenticationDetails =
    map['authenticationDetails'] == null ? null : AuthenticationDetails.fromMap(
        map['authenticationDetails']);
  }

  @override
  String toString() {
    return 'Transaction{transactionId: $transactionId, type: $type, status: $status, amount: $amount, currency: $currency, source: $source, authorizationCode: $authorizationCode, rrn: $rrn, sameBank: $sameBank, postilionDetails: $postilionDetails, terminalDetails: $terminalDetails, meezaDetails: $meezaDetails, bnplDetails: $bnplDetails, correlationId: $correlationId, createdDate: $createdDate, createdBy: $createdBy, updatedDate: $updatedDate, updatedBy: $updatedBy, paymentMethod: $paymentMethod, codes: $codes, authenticationDetails: $authenticationDetails}';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "transactionId": transactionId,
      "type": type,
      "status": status,
      "amount": amount,
      "currency": currency,
      "source": source,
      "authorizationCode": authorizationCode,
      "rrn": rrn,
      "sameBank": sameBank,
      "postilionDetails": postilionDetails,
      "terminalDetails": terminalDetails,
      "meezaDetails": meezaDetails,
      "bnplDetails": bnplDetails,
      "correlationId": correlationId,
      "createdDate": createdDate,
      "createdBy": createdBy,
      "updatedDate": updatedDate,
      "updatedBy": updatedBy,
      "paymentMethod": paymentMethod?.toMap(),
      "codes": codes?.toMap(),
      "authenticationDetails": authenticationDetails?.toMap()
    };
  }
}