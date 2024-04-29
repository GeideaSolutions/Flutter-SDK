import 'package:geideapay/api/response/api_response.dart';

class Base64ImageApiResponse extends ApiResponse {
  String? image;
  String? type;
  String? message;
  String? paymentIntentId;

  Base64ImageApiResponse.unknownServerResponse() {
    responseCode = '100';
    detailedResponseMessage = 'Unknown server response';
  }

  Base64ImageApiResponse.fromMap(Map<String, dynamic> map) {
    image = map["image"];
    type = map["type"];
    message = map["message"];
    paymentIntentId = map["paymentIntentId"];

    fromMap(map);
  }

  Base64ImageApiResponse(
      {this.image,
      this.type,
      this.message,
      this.paymentIntentId,
      responseCode,
      detailedResponseCode,
      responseMessage,
      detailedResponseMessage,
      language})
      : super(
            responseCode: responseCode,
            detailedResponseCode: detailedResponseCode,
            responseMessage: responseMessage,
            detailedResponseMessage: detailedResponseMessage,
            language: language);

  @override
  String toString() {
    return 'DirectSessionApiResponse{image: $image, type: $type, message: $message, paymentIntentId: $paymentIntentId, '
        'responseCode: $responseCode, detailedResponseCode: $detailedResponseCode, '
        'responseMessage: $responseMessage, detailedResponseMessage: $detailedResponseMessage, '
        'language: $language}';
  }
}
