import 'package:geideapay/api/request/base/post_pay_operation_request_body.dart';


class CaptureRequestBody extends PostPayOperationRequestBody {
  String? callbackUrl_, paymentIntentId_;
  CaptureRequestBody(String orderId, {this.callbackUrl_, this.paymentIntentId_})
      :super(orderId, callbackUrl: callbackUrl_, paymentIntentId: paymentIntentId_);

  toString () {
    return 'CaptureRequestBody{callbackUrl: $callbackUrl_, paymentIntentId: $paymentIntentId_}';
  }

}
