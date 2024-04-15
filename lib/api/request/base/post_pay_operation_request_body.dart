import 'package:geideapay/api/request/base/base_request_body.dart';

class PostPayOperationRequestBody extends BaseRequestBody {

  final String _orderId;
  final String? callbackUrl;
  final String? reason;
  final String? paymentIntentId;
  PostPayOperationRequestBody(this._orderId, {this.callbackUrl, this.reason, this.paymentIntentId});

  @override
  Map<String, Object?> paramsMap() {
    // set values will override additional params provided
    Map<String, Object?> params = {};
    params[BaseRequestBody.fieldOrderId] = _orderId;
    params[BaseRequestBody.fieldCallbackUrl] = callbackUrl;
    params[BaseRequestBody.fieldReason] = reason;
    params[BaseRequestBody.fieldPaymentIntentId] = paymentIntentId;
    return params..removeWhere((key, value) => value == null || (value is String && value.isEmpty));
  }
}
