import 'package:geideapay/api/response/api_response.dart';

class AuthenticationApiResponse extends ApiResponse {
  String? orderId;
  String? threeDSecureId;
  String? html;
  String? gatewayDecision;

  AuthenticationApiResponse.unknownServerResponse() {
    responseCode = '100';
    detailedResponseMessage = 'Unknown server response';
  }

  AuthenticationApiResponse.fromMap(Map<String, dynamic> map) {
    orderId = map['orderId'];
    if (map.containsKey('redirectHtml')) {
      html = map['redirectHtml'];
    } else if (map.containsKey('htmlBodyContent')) {
      html = map['htmlBodyContent'];
    }
    threeDSecureId = map['threeDSecureId'];
    gatewayDecision = map['gatewayDecision'];

    fromMap(map);
  }

  AuthenticationApiResponse(
      {this.orderId,
      this.html,
      this.threeDSecureId,
      this.gatewayDecision,
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
    return 'AuthenticationApiResponse{orderId: $orderId, threeDSecureId: $threeDSecureId, html: $html, gatewayDecision: $gatewayDecision'
        'responseCode: $responseCode, detailedResponseCode: $detailedResponseCode, '
        'responseMessage: $responseMessage, detailedResponseMessage: $detailedResponseMessage, '
        'language: $language}';
  }
}
