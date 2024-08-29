class MeezaDetail {
  String? transactionId;
  String? meezaTransactionId;
  String? type;
  String? transactionTimeStamp;
  String? adviceId;
  String? senderId;
  String? senderName;
  String? senderAddress;
  String? receiverId;
  String? receiverName;
  String? receiverScheme;
  String? receiverAddress;
  double? amount;
  String? currency;
  String? description;
  String? responseCode;
  String? responseDescription;
  double? interchange;
  String? interchangeAction;
  String? reference1;
  String? reference2;
  double? tips;
  double? convenienceFee;

  MeezaDetail(
      {this.transactionId,
      this.meezaTransactionId,
      this.type,
      this.transactionTimeStamp,
      this.adviceId,
      this.senderId,
      this.senderName,
      this.senderAddress,
      this.receiverId,
      this.receiverName,
      this.receiverScheme,
      this.receiverAddress,
      this.amount,
      this.currency,
      this.description,
      this.responseCode,
      this.responseDescription,
      this.interchange,
      this.interchangeAction,
      this.reference1,
      this.reference2,
      this.tips,
      this.convenienceFee});

  MeezaDetail.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    meezaTransactionId = json['meezaTransactionId'];
    type = json['type'];
    transactionTimeStamp = json['transactionTimeStamp'];
    adviceId = json['adviceId'];
    senderId = json['senderId'];
    senderName = json['senderName'];
    senderAddress = json['senderAddress'];
    receiverId = json['receiverId'];
    receiverName = json['receiverName'];
    receiverScheme = json['receiverScheme'];
    receiverAddress = json['receiverAddress'];
    amount = json['amount'];
    currency = json['currency'];
    description = json['description'];
    responseCode = json['responseCode'];
    responseDescription = json['responseDescription'];
    interchange = json['interchange'];
    interchangeAction = json['interchangeAction'];
    reference1 = json['reference1'];
    reference2 = json['reference2'];
    tips = json['tips'];
    convenienceFee = json['convenienceFee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionId'] = this.transactionId;
    data['meezaTransactionId'] = this.meezaTransactionId;
    data['type'] = this.type;
    data['transactionTimeStamp'] = this.transactionTimeStamp;
    data['adviceId'] = this.adviceId;
    data['senderId'] = this.senderId;
    data['senderName'] = this.senderName;
    data['senderAddress'] = this.senderAddress;
    data['receiverId'] = this.receiverId;
    data['receiverName'] = this.receiverName;
    data['receiverScheme'] = this.receiverScheme;
    data['receiverAddress'] = this.receiverAddress;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['description'] = this.description;
    data['responseCode'] = this.responseCode;
    data['responseDescription'] = this.responseDescription;
    data['interchange'] = this.interchange;
    data['interchangeAction'] = this.interchangeAction;
    data['reference1'] = this.reference1;
    data['reference2'] = this.reference2;
    data['tips'] = this.tips;
    data['convenienceFee'] = this.convenienceFee;
    return data;
  }
}
