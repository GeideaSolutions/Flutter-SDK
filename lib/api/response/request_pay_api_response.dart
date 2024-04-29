import 'package:geideapay/api/response/api_response.dart';
import 'package:geideapay/common/my_strings.dart';

class RequestPayApiResponse extends ApiResponse {
  String? responseDescription;
  String? receiverName;
  String? receiverAddress;

  RequestPayApiResponse.unknownServerResponse() {
    responseCode = '100';
    detailedResponseMessage = 'Unknown server response';
  }

  RequestPayApiResponse.fromMap(Map<String, dynamic> map) {
    responseCode = map["responseCode"];
    responseDescription = map["responseDescription"];
    detailedResponseMessage = map["responseDescription"];
    receiverName = map["receiverName"];
    receiverAddress = map["receiverAddress"];
    fromMap(map);
  }

  RequestPayApiResponse({
    responseCode,
    detailedResponseCode,
    responseMessage,
    detailedResponseMessage,
    language,
    this.receiverAddress,
    this.receiverName,
    this.responseDescription,
  }) : super(
          responseCode: responseCode,
          detailedResponseCode: detailedResponseCode,
          responseMessage: responseMessage,
          detailedResponseMessage: detailedResponseMessage,
          language: language,
        );

  @override
  String toString() {
    return 'RequestPayApiResponse{receiverAddress: $receiverAddress, receiverName: $receiverName, responseDescription: $responseDescription, '
        'responseCode: $responseCode, detailedResponseCode: $detailedResponseCode, '
        'responseMessage: $responseMessage, detailedResponseMessage: $detailedResponseMessage, responseDescription: $responseDescription, '
        'language: $language}';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "receiverAddress": receiverAddress,
      "receiverName": receiverName,
      "responseDescription": responseDescription,
      "responseCode": responseCode,
      "detailedResponseCode": detailedResponseCode,
      "responseMessage": responseMessage,
      "detailedResponseMessage": detailedResponseMessage,
      "language": language
    };
  }

  RequestPayApiResponse.defaults() {
    detailedResponseMessage = Strings.userTerminated;
  }
}
