import 'package:geideapay/api/request/base/base_request_body.dart';

class Base64ImageRequestBody extends BaseRequestBody {
  // Mandatory fields
  final String? merchantPublicKey;
  final String? sessionId;

  Base64ImageRequestBody(this.merchantPublicKey, this.sessionId);

  @override
  Map<String, Object?> paramsMap() {
    // set values will override additional params provided
    Map<String, Object?> params = {};
    params[BaseRequestBody.fieldMerchantPublicKey] = merchantPublicKey;
    params[BaseRequestBody.fieldSessionId] = sessionId;

    return params
      ..removeWhere(
          (key, value) => value == null || (value is String && value.isEmpty));
  }

  @override
  toString() {
    return 'Base64ImageRequestBody{merchantPublicKey: $merchantPublicKey, sessionId: $sessionId}';
  }
}
