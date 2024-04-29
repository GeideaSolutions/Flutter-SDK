import 'package:geideapay/api/response/api_response.dart';
import 'package:geideapay/common/my_strings.dart';
import 'package:geideapay/models/order.dart';

class OrderApiResponse extends ApiResponse {
  Order? order;

  OrderApiResponse.unknownServerResponse() {
    responseCode = '100';
    detailedResponseMessage = 'Unknown server response';
  }

  OrderApiResponse.fromMap(Map<String, dynamic> map) {
    order = map["order"] == null ? null : Order.fromMap(map["order"]);
    fromMap(map);
  }

  OrderApiResponse({
    responseCode,
    detailedResponseCode,
    responseMessage,
    detailedResponseMessage,
    language,
    this.order,
  }) : super(
    responseCode: responseCode,
    detailedResponseCode: detailedResponseCode,
    responseMessage: responseMessage,
    detailedResponseMessage: detailedResponseMessage,
    language: language,
  );

  @override
  String toString() {
    return 'OrderApiResponse{order: $order, '
        'responseCode: $responseCode, detailedResponseCode: $detailedResponseCode, '
        'responseMessage: $responseMessage, detailedResponseMessage: $detailedResponseMessage, '
        'language: $language}';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "order": order?.toMap(),
      "responseCode": responseCode,
      "detailedResponseCode": detailedResponseCode,
      "responseMessage": responseMessage,
      "detailedResponseMessage": detailedResponseMessage,
      "language": language
    };
  }

  OrderApiResponse.defaults() {
    detailedResponseMessage = Strings.userTerminated;
  }
}
