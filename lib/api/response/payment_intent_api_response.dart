import 'package:geideapay/api/response/api_response.dart';
import 'package:geideapay/common/my_strings.dart';
import 'package:geideapay/models/paymentIntent.dart';

class PaymentIntentApiResponse extends ApiResponse {
  PaymentIntent? paymentIntent;

  PaymentIntentApiResponse.unknownServerResponse() {
    responseCode = '100';
    detailedResponseMessage = 'Unknown server response';
  }

  PaymentIntentApiResponse.fromMap(Map<String, dynamic> map) {
    paymentIntent = map["paymentIntent"] == null ? null : PaymentIntent.fromMap(map["paymentIntent"]);
    fromMap(map);
  }

  PaymentIntentApiResponse({
    responseCode,
    detailedResponseCode,
    responseMessage,
    detailedResponseMessage,
    language,
    this.paymentIntent,
  }) : super(
          responseCode: responseCode,
          detailedResponseCode: detailedResponseCode,
          responseMessage: responseMessage,
          detailedResponseMessage: detailedResponseMessage,
          language: language,
        );

  @override
  String toString() {
    return 'PaymentIntentApiResponse{paymentIntent: $paymentIntent, '
        'responseCode: $responseCode, detailedResponseCode: $detailedResponseCode, '
        'responseMessage: $responseMessage, detailedResponseMessage: $detailedResponseMessage, '
        'language: $language}';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "paymentIntent": paymentIntent?.toMap(),
      "responseCode": responseCode,
      "detailedResponseCode": detailedResponseCode,
      "responseMessage": responseMessage,
      "detailedResponseMessage": detailedResponseMessage,
      "language": language
    };
  }

  PaymentIntentApiResponse.defaults() {
    detailedResponseMessage = Strings.userTerminated;
  }
}
