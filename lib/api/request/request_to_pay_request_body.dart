import 'package:geideapay/api/request/base/base_request_body.dart';
import 'package:geideapay/models/deviceIdentification.dart';

class RequestToPayRequestBody extends BaseRequestBody {
  // Mandatory fields
  final String? receiverId;
  final String? merchantPublicKey;
  final String? paymentIntentId;
  final String? sessionId;

  String? merchantName;
  DeviceIdentification? deviceIdentification;

  RequestToPayRequestBody(
    this.receiverId,
    this.merchantPublicKey,
    this.paymentIntentId,
    this.sessionId, {
    this.merchantName,
    this.deviceIdentification,
  });

  @override
  Map<String, Object?> paramsMap() {
    // set values will override additional params provided
    Map<String, Object?> params = {};
    params[BaseRequestBody.fieldReceiverIdKey] = receiverId;
    params[BaseRequestBody.fieldMerchantPublicKey] = merchantPublicKey;
    params[BaseRequestBody.fieldMerchantName] = merchantName;
    params[BaseRequestBody.fieldPaymentIntentId] = paymentIntentId;
    params[BaseRequestBody.fieldSessionId] = sessionId;

    if (deviceIdentification != null) {
      params[BaseRequestBody.fieldDeviceIdentification] =
          deviceIdentification?.toMap();
    }

    return params
      ..removeWhere(
          (key, value) => value == null || (value is String && value.isEmpty));
  }

  @override
  toString() {
    return 'RequestToPayRequestBody{receiverId: $receiverId, merchantPublicKey: $merchantPublicKey, merchantName: $merchantName, deviceIdentification: $deviceIdentification, paymentIntentId: $paymentIntentId, sessionId: $sessionId}';
  }
}
