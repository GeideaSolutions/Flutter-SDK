class ApiResponse {
  String? responseCode;
  String? detailedResponseCode;
  String? responseMessage;
  String? detailedResponseMessage;
  String? language;

  ApiResponse({
    this.responseCode,
    this.detailedResponseCode,
    this.responseMessage,
    this.detailedResponseMessage,
    this.language,
  });

  fromMap(Map<String, dynamic> map) {
    responseCode = map['responseCode'];
    detailedResponseCode = map['detailedResponseCode'];
    responseMessage = map['responseMessage'];
    detailedResponseMessage = map['detailedResponseMessage'];
    language = map['language'];
  }
}
