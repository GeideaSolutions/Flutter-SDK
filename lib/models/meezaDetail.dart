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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transactionId'] = transactionId;
    data['meezaTransactionId'] = meezaTransactionId;
    data['type'] = type;
    data['transactionTimeStamp'] = transactionTimeStamp;
    data['adviceId'] = adviceId;
    data['senderId'] = senderId;
    data['senderName'] = senderName;
    data['senderAddress'] = senderAddress;
    data['receiverId'] = receiverId;
    data['receiverName'] = receiverName;
    data['receiverScheme'] = receiverScheme;
    data['receiverAddress'] = receiverAddress;
    data['amount'] = amount;
    data['currency'] = currency;
    data['description'] = description;
    data['responseCode'] = responseCode;
    data['responseDescription'] = responseDescription;
    data['interchange'] = interchange;
    data['interchangeAction'] = interchangeAction;
    data['reference1'] = reference1;
    data['reference2'] = reference2;
    data['tips'] = tips;
    data['convenienceFee'] = convenienceFee;
    return data;
  }
}
