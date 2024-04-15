import 'package:geideapay/api/response/api_response.dart';
import 'package:geideapay/models/session.dart';

class DirectSessionApiResponse extends ApiResponse {
  Session? session;

  DirectSessionApiResponse.unknownServerResponse() {
    responseCode = '100';
    detailedResponseMessage = 'Unknown server response';
  }

  DirectSessionApiResponse.fromMap(Map<String, dynamic> map) {
    session = map["session"] == null ? null : Session.fromJson(map["session"]);
    fromMap(map);
  }

  DirectSessionApiResponse(
      {this.session,
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
    return 'DirectSessionApiResponse{session: $session, '
        'responseCode: $responseCode, detailedResponseCode: $detailedResponseCode, '
        'responseMessage: $responseMessage, detailedResponseMessage: $detailedResponseMessage, '
        'language: $language}';
  }
}
