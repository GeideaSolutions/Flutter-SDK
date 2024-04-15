class Codes {

  String? acquirerCode, acquirerMessage, responseCode, responseMessage,
      detailedResponseCode, detailedResponseMessage;

  Codes(
      {this.acquirerCode, this.acquirerMessage, this.responseCode, this.responseMessage, this.detailedResponseCode, this.detailedResponseMessage});


  Codes.fromMap(Map<String, dynamic> map) {
    acquirerCode = map['acquirerCode'];
    acquirerMessage = map['acquirerMessage'];
    responseCode = map['responseCode'];
    responseMessage = map['responseMessage'];
    detailedResponseCode = map['detailedResponseCode'];
    detailedResponseMessage = map['detailedResponseMessage'];
  }

  @override
  String toString() {
    return 'Codes{acquirerCode: $acquirerCode, acquirerMessage: $acquirerMessage, responseCode: $responseCode, responseMessage: $responseMessage, detailedResponseCode: $detailedResponseCode, detailedResponseMessage: $detailedResponseMessage}';
  }

  @override
  Map<String, dynamic>? toMap() {
    return {
      "acquirerCode": acquirerCode,
      "acquirerMessage": acquirerMessage,
      "responseCode": responseCode,
      "responseMessage": responseMessage,
      "detailedResponseCode": detailedResponseCode,
      "detailedResponseMessage": detailedResponseMessage
    };
  }
}